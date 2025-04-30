// ignore_for_file: prefer_initializing_formals

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:quadro_platform/features/user/repository/user_repository.dart';
import 'package:quadro_platform/features/workshop_authentication/models/firestore_exceptions.dart';
import 'package:quadro_platform/features/workshop_authentication/repository/workshop_repo.dart';
import 'package:quadro_platform/features/workshop_main_screen/models/maintenance_request_data_model.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/maintenance_requests_repo.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/models/maintenance_request.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/models/offers.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/offers_repository.dart';
import 'package:quadro_platform/features/workshop_profile/repository/reviews_repository.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';
import 'package:quadro_platform/shared/enum/offer_status.dart';
import 'package:quadro_platform/shared/utils/extension/coordination_togeopoint.dart';

import '../../../common/controller/services/location_services.dart';
import '../../../shared/enum/offers_filter.dart';
import '../../../user/view/workshop_search/model/workshop_model.dart';
import '../../user/model/user.dart';
import '../../workshop_authentication/models/workshop_user.dart';
import '../../workshop_profile/model/Review_Domain.dart';

class RepositoryManager {
  final OffersRepository offersRepository;
  final UserRepository userRepository;
  final WorkshopRepository workshopRepository;
  final MaintenanceRequestsRepository maintenanceRequestsRepository;
  final ReviewsRepository reviewsRepository;

  RepositoryManager(
      {required OffersRepository offersRepository,
      required UserRepository userRepository,
      required ReviewsRepository reviewsRepository,
      required WorkshopRepository workshopRepository,
      required MaintenanceRequestsRepository maintenanceRequestsRepository})
      : offersRepository = offersRepository,
        userRepository = userRepository,
        reviewsRepository = reviewsRepository,
        workshopRepository = workshopRepository,
        maintenanceRequestsRepository = maintenanceRequestsRepository;
  Future<void> addOffer(Offer offer) async {
    try {
      final offerId = await offersRepository.addOfferToFirebase(offer);
      await maintenanceRequestsRepository
          .updateRequest(id: offer.requestId, map: {"offer_id": offerId});
    } on FirebaseException catch (e) {
      throw FirestoreReadWriteFailure(e.code);
    }
  }

  String get authUserId => userRepository.getuserId ?? "";
  Future<QuadroUser?> getCashedQuadroUser() async {
    final user = await userRepository.getCachedUser();
    return user;
  }

  Future<Workshop?> getCashedWorkshop() async {
    final workshop = await workshopRepository.getCachedUser();
    return workshop;
  }

  // fetch all maitenance requests or limit the number of requests
  Stream<List<MaintenanceRequestDomainModel>> fetchRequests({
    required String id,
    required RequestType type,
    int? limit,
    required bool withOffer,
  }) {
    try {
      Query query = maintenanceRequestsRepository.maintenanceRequestRef
          .where(type.name, isEqualTo: id)
          .where("offer_id", isNull: withOffer);

      if (limit != null) query = query.limit(limit);

      return _convertToDomainModelStream(query, withOffer);
    } on FirebaseException catch (e) {
      throw FirestoreReadWriteFailure.fromCode(
        e.code,
      );
    }
  }

// get either offers or requests
  Future<List<MaintenanceRequestDomainModel>> getRequestslist({
    required String id,
    required RequestType type,
  }) async {
    final query = await maintenanceRequestsRepository.maintenanceRequestRef
        .where(type.name, isEqualTo: id)
        .where("offer_id", isNull: true)
        .get();
    final docs = query.docs;
    final relatedData = await _fetchRelatedData(docs, true);
    return docs.map(
      (doc) {
        final request = doc.data();
        return _mapToMaintenanceDomainModel(doc.id, request, relatedData);
      },
    ).toList();
  }

  Future<Map<OffersFilter, List<MaintenanceRequestDomainModel>>> getoffers({
    required String id,
    required RequestType type,
  }) async {
    final query = await maintenanceRequestsRepository.maintenanceRequestRef
        .where(type.name, isEqualTo: id)
        .where("offer_id", isNull: false)
        .get();

    final docs = query.docs;
    final relatedData = await _fetchRelatedData(docs, false);

    // Initialize offers map with empty lists
    final Map<OffersFilter, List<MaintenanceRequestDomainModel>> offersMap = {
      OffersFilter.all: [],
      OffersFilter.pending: [],
      OffersFilter.inprogress: [],
      OffersFilter.accepted: [],
      OffersFilter.rejected: [],
      OffersFilter.completed: []
    };

    // Map document IDs to their snapshots
    final docMap = {
      for (var doc in docs) (doc.data()).offerId: doc,
    };

    // Helper to add grouped offers to the map
    void addGroupedOffers(
      Map<String, Offer> offersByStatus,
      OffersFilter status,
    ) {
      offersByStatus.forEach((key, offer) {
        final requestDoc = docMap[offer.id];
        if (requestDoc != null) {
          final request = requestDoc.data();
          offersMap[status]?.add(
            MaintenanceRequestDomainModel(
                id: requestDoc.id,
                user: relatedData.users[request.vehicleOwnerId]!,
                workshop: relatedData.workshops[request.workshopId]!,
                carCompany: request.carCompany,
                carModel: request.carModel,
                description: request.description,
                requestStatus: request.status,
                dateCreated: request.dateCreated.toDate(),
                offer: offer,
                carImageUrl: request.requestImageUrl),
          );
        }
      });
    }

    // Add grouped offers for each status
    addGroupedOffers(relatedData.groupedOffers?[OfferStatus.pending] ?? {},
        OffersFilter.pending);
    addGroupedOffers(relatedData.groupedOffers?[OfferStatus.inprogress] ?? {},
        OffersFilter.inprogress);
    addGroupedOffers(relatedData.groupedOffers?[OfferStatus.accepted] ?? {},
        OffersFilter.accepted);
    addGroupedOffers(relatedData.groupedOffers?[OfferStatus.rejected] ?? {},
        OffersFilter.rejected);
    addGroupedOffers(relatedData.groupedOffers?[OfferStatus.completed] ?? {},
        OffersFilter.completed);

    // Aggregate all offers into OfferStatus.all
    offersMap[OffersFilter.all] = [
      ...offersMap[OffersFilter.pending]!,
      ...offersMap[OffersFilter.inprogress]!,
      ...offersMap[OffersFilter.accepted]!,
      ...offersMap[OffersFilter.rejected]!,
      ...offersMap[OffersFilter.completed]!,
    ];

    return offersMap;
  }

  Future<List<ReviewDomainModel>> getReviews(
      {required String workshopId}) async {
    try {
      reviewsRepository.setWorkshopId(workshopId);
      final reviews = await reviewsRepository.getReviews();
      final user = await userRepository.fetchUsers(reviews
          .map(
            (e) => e.userId,
          )
          .toSet());
      return reviews.map((review) {
        final reviewUser = user[review.userId]!;
        return ReviewDomainModel(
            id: review.id ?? "",
            user: reviewUser,
            rating: review.rating,
            reviewComment: review.reviewComment,
            workshopComment: review.workshopComment,
            dateCreated: review.dateCreated);
      }).toList();
    } on FirebaseException catch (e) {
      throw FirestoreReadWriteFailure(e.code);
    }
  }

  Stream<List<MaintenanceRequestDomainModel>> _convertToDomainModelStream(
    Query query,
    bool withOffer,
  ) {
    return query.snapshots().asyncMap((snapshot) async {
      final docs = snapshot.docs;
      final relatedData = await _fetchRelatedData(docs, withOffer);

      return docs.map((doc) {
        final maintenanceRequest = doc.data() as MaintenanceRequest;
        log(maintenanceRequest.toMap().toString());
        return _mapToMaintenanceDomainModel(
          doc.id,
          maintenanceRequest,
          relatedData,
        );
      }).toList();
    });
  }

  /// Map to MaintenanceRequestDomainModel for offers
  MaintenanceRequestDomainModel _mapToMaintenanceDomainModel(
    String id,
    MaintenanceRequest request,
    _RelatedData relatedData,
  ) {
    return MaintenanceRequestDomainModel(
      carImageUrl: request.requestImageUrl,
      user: relatedData.users[request.vehicleOwnerId]!,
      id: id,
      workshop: relatedData.workshops[request.workshopId]!,
      carCompany: request.carCompany,
      carModel: request.carModel,
      description: request.description,
      requestStatus: request.status,
      dateCreated: request.dateCreated.toDate(),
      offer: relatedData.offers?[request.offerId],
    );
  }

// fetch nearby workshop
  Stream<List<WorkshopModel>> getNearbyWorkshops(double radiusInKm) async* {
    final currentLocation = await LocationServices.getCurrentLocation();
    yield* GeoCollectionReference(workshopRepository.workshopRef)
        .subscribeWithin(
      center: currentLocation.toGeoFirePoint(),
      radiusInKm: radiusInKm,
      field: 'coordination',
      geopointFrom: (data) {
        return (data as Workshop).coordination?.data["geopoint"] as GeoPoint;
      },
      strictMode: true, // Ensures accurate radius filtering
    )
        .asyncMap((snapshotList) async {
      return Future.wait(snapshotList.map((firestoreWorkshop) async {
        final workshop = firestoreWorkshop.data()! as Workshop;
        reviewsRepository.setWorkshopId(workshop.ownerId);
        final reviewData =
            await reviewsRepository.getAverageRatingAndReviewCount();
        final dynamic ratingValue = reviewData["averageRating"];
        final double avg =
            ratingValue != null ? (ratingValue as num).toDouble() : 0.0;

        return WorkshopModel(workshop: workshop, average: avg);
      }));
    });
  }

  /// Fetch related data for maintenance requests
  Future<_RelatedData> _fetchRelatedData(
      List<QueryDocumentSnapshot> docs, bool withOffers) async {
    // Extract unique user and workshop IDs
    final userIds = {
      for (var doc in docs) (doc.data() as MaintenanceRequest).vehicleOwnerId
    };
    final workshopIds = {
      for (var doc in docs) (doc.data() as MaintenanceRequest).workshopId
    };

    log("message");
    // Initialize offers only if needed
    final Map<String, Offer?>? offers;
    final Map<OfferStatus, Map<String, Offer>>? groupedOffers;
    if (withOffers) {
      offers = null;
      groupedOffers = null;
    } else {
      final offerIds = {
        for (var doc in docs) (doc.data() as MaintenanceRequest).offerId
      };

      final offersMap = await offersRepository.fetchOffersBySet(offerIds);
      offers = offersMap['allOffers'] as Map<String, Offer?>;
      groupedOffers = offersMap['groupedByStatus'];
    }

    // Fetch related data
    final users = await userRepository.fetchUsers(userIds);
    final workshops = await workshopRepository.fetchWorkshops(workshopIds);

    // Return consolidated data
    return _RelatedData(groupedOffers, users, workshops, offers);
  }
}

/// Helper class for related data
class _RelatedData {
  final Map<String, QuadroUser> users;
  final Map<String, Workshop> workshops;
  final Map<String, Offer?>? offers;
  final Map<OfferStatus, Map<String, Offer>>? groupedOffers;

  _RelatedData(
    this.groupedOffers,
    this.users,
    this.workshops,
    this.offers,
  );
}
