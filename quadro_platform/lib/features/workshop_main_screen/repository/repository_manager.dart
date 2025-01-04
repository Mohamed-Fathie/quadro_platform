import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quadro_platform/features/user/repository/user_repository.dart';
import 'package:quadro_platform/features/workshop_authentication/models/firestore_exceptions.dart';
import 'package:quadro_platform/features/workshop_authentication/repository/workshop_repo.dart';
import 'package:quadro_platform/features/workshop_main_screen/models/maintenance_request_data_model.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/maintenance_requests_repo.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/models/maintenance_request.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/models/offers.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/offers_repository.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';

import '../../user/model/user.dart';
import '../../workshop_authentication/models/workshop_user.dart';

class RepositoryManager {
  final OffersRepository _offersRepository;
  final UserRepository _userRepository;
  final WorkshopRepository _workshopRepository;
  final MaintenanceRequestsRepository _maintenanceRequestsRepository;

  RepositoryManager(
      {required OffersRepository offersRepository,
      required UserRepository userRepository,
      required WorkshopRepository workshopRepository,
      required MaintenanceRequestsRepository maintenanceRequestsRepository})
      : _offersRepository = offersRepository,
        _userRepository = userRepository,
        _workshopRepository = workshopRepository,
        _maintenanceRequestsRepository = maintenanceRequestsRepository;
  Future<void> addOffer(Offer offer) async {
    try {
      final offerId = await _offersRepository.addOfferToFirebase(offer);
      await _maintenanceRequestsRepository
          .updateRequest(id: offer.requestId, map: {"offer_id": offerId});
    } on FirebaseException catch (e) {
      throw FirestoreReadWriteFailure(e.code);
    }
  }

  // fetch all maitenance requests or limit the number of requests
  Stream<List<MaintenanceRequestDomainModel>> fetchRequests({
    required String id,
    required RequestType type,
    int? limit,
    required bool withOffer,
  }) {
    try {
      Query query = _maintenanceRequestsRepository.maintenanceRequestRef
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

  Stream<List<MaintenanceRequestDomainModel>> _convertToDomainModelStream(
    Query query,
    bool withOffer,
  ) {
    return query.snapshots().asyncMap((snapshot) async {
      final docs = snapshot.docs;
      final relatedData = await _fetchRelatedData(docs, withOffer);
      return docs.map((doc) {
        final maintenanceRequest = doc.data() as MaintenanceRequest;
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
      String id, MaintenanceRequest request, _RelatedData relatedData) {
    return MaintenanceRequestDomainModel(
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

    // Initialize offers only if needed
    final Map<String, Offer?>? offers;
    if (withOffers) {
      offers = null;
    } else {
      final offerIds = {
        for (var doc in docs) (doc.data() as MaintenanceRequest).offerId
      };
      offers = await _offersRepository.fetchOffersBySet(offerIds);
    }

    // Fetch related data
    final users = await _userRepository.fetchUsers(userIds);
    final workshops = await _workshopRepository.fetchWorkshops(workshopIds);

    // Return consolidated data
    return _RelatedData(users, workshops, offers);
  }
}

/// Helper class for related data
class _RelatedData {
  final Map<String, QuadroUser> users;
  final Map<String, Workshop> workshops;
  final Map<String, Offer?>? offers;

  _RelatedData(
    this.users,
    this.workshops,
    this.offers,
  );
}

// import 'package:equatable/equatable.dart';
// import 'package:quadro_platform/features/user/model/user.dart';
// import 'package:quadro_platform/features/workshop_authentication/models/workshop_user.dart';
// import 'package:quadro_platform/features/workshop_main_screen/repository/models/maintenance_request.dart';
// import 'package:quadro_platform/shared/enum/offer_status.dart';
// import 'package:quadro_platform/shared/enum/spare_parts.dart';

// class OffersDomainModel extends Equatable {
//   final Workshop workshop;
//   final QuadroUser user;

//   final MaintenanceRequest request;
//   final double servicePrice;
//   final int guaranteePeriod;
//   final SparePartsStatus partsStatus;
//   final OfferStatus offerStatus;
//   final DateTime dateCreated;

//   const OffersDomainModel({
//     required this.workshop,
//     required this.user,
//     required this.request,
//     required this.servicePrice,
//     required this.guaranteePeriod,
//     required this.partsStatus,
//     required this.offerStatus,
//     required this.dateCreated,
//   });

//   // CopyWith Method
//   OffersDomainModel copyWith({
//     Workshop? workshop,
//     QuadroUser? user,
//     MaintenanceRequest? request,
//     double? servicePrice,
//     int? guaranteePeriod,
//     SparePartsStatus? partsStatus,
//     OfferStatus? offerStatus,
//     DateTime? dateCreated,
//   }) {
//     return OffersDomainModel(
//       workshop: workshop ?? this.workshop,
//       request: request ?? this.request,
//       servicePrice: servicePrice ?? this.servicePrice,
//       guaranteePeriod: guaranteePeriod ?? this.guaranteePeriod,
//       partsStatus: partsStatus ?? this.partsStatus,
//       offerStatus: offerStatus ?? this.offerStatus,
//       dateCreated: dateCreated ?? this.dateCreated,
//       user: user ?? this.user,
//     );
//   }

//   // toString Method
//   @override
//   String toString() {
//     return 'OffersDomainModel('
//         'workshop: ${workshop.toString()}, '
//         'request: ${request.toString()}, '
//         'servicePrice: $servicePrice, '
//         'guaranteePeriod: $guaranteePeriod, '
//         'partsStatus: $partsStatus, '
//         'offerStatus: $offerStatus, '
//         'dateCreated: $dateCreated)';
//   }

//   // Equatable Props
//   @override
//   List<Object?> get props => [
//         workshop,
//         request,
//         servicePrice,
//         guaranteePeriod,
//         partsStatus,
//         offerStatus,
//         dateCreated,
//         user
//       ];
// }
