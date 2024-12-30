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
import '../models/offers_domain_model.dart';

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

  // fetch all maitenance requests or limit the number of requests
  Stream<List<MaintenanceRequestDomainModel>> fetchRequests({
    required String id,
    required RequestType type,
    int? limit,
  }) {
    try {
      Query query = _maintenanceRequestsRepository.maintenanceRequestRef
              .where(type.name, isEqualTo: id)
          // .where("offer_id", isNull: false)
          ;

      if (limit != null) {
        query = query.limit(limit);
      }

      return query.snapshots().asyncMap((snapshot) async {
        final docs = snapshot.docs;
        final relatedData = await _fetchRelatedData(docs);

        return docs.map((doc) {
          final maintenanceRequest = doc.data() as MaintenanceRequest;
          return _mapToMaintenanceDomainModel(
            doc.id,
            maintenanceRequest,
            relatedData,
          );
        }).toList();
      });
    } on FirebaseException catch (e) {
      throw FirestoreReadWriteFailure.fromCode(e.code);
    }
  }

  Stream<List<OffersDomainModel>> fetchOffers({
    required String workshopId,
    int? limit,
  }) {
    try {
      Query query = _offersRepository.offersRef
          .where('workshop_id', isEqualTo: workshopId);

      if (limit != null) {
        query = query.limit(limit);
      }

      return query.snapshots().asyncMap((snapshot) async {
        final docs = snapshot.docs;
        final relatedData = await _fetchOfferRelatedData(docs);

        return docs.map((doc) {
          final offer = doc.data() as Offer;
          return _mapToOfferDomainModel(offer, relatedData);
        }).toList();
      });
    } on FirebaseException catch (e) {
      throw FirestoreReadWriteFailure(e.code);
    }
  }

  /// Map to MaintenanceRequestDomainModel
  MaintenanceRequestDomainModel _mapToMaintenanceDomainModel(
      String id, MaintenanceRequest request, _RelatedData relatedData) {
    log(id);
    return MaintenanceRequestDomainModel(
      user: relatedData.users[request.vehicleOwnerId]!,
      id: id,
      workshop: relatedData.workshops[request.workshopId]!,
      carCompany: request.carCompany,
      carModel: request.carModel,
      description: request.description,
      requestStatus: request.status,
      dateCreated: request.dateCreated.toDate(),
      offer: relatedData.offers[request.offerId],
    );
  }

  /// Map to OffersDomainModel
  OffersDomainModel _mapToOfferDomainModel(
      Offer offer, _OfferRelatedData data) {
    final request = data.requests[offer.requestId]!;
    final user = data.users[request.vehicleOwnerId]!;
    log(offer.toJson().toString());
    return OffersDomainModel(
      user: user,
      workshop: data.workshops[offer.workshopId]!,
      request: request,
      servicePrice: offer.servicePrice,
      guaranteePeriod: offer.guaranteePeriod,
      partsStatus: offer.sparePartsStatus,
      offerStatus: offer.status,
      dateCreated: offer.dateCreated.toDate(),
    );
  }

  /// Fetch related data for offers
  Future<_OfferRelatedData> _fetchOfferRelatedData(
      List<QueryDocumentSnapshot> docs) async {
    final requestIds =
        docs.map((doc) => (doc.data() as Offer).requestId).toSet();
    final workshopIds =
        docs.map((doc) => (doc.data() as Offer).workshopId).toSet();
    final requests = await _maintenanceRequestsRepository
        .fetchMaintenanceRequests(requestIds);
    final userIds = requests.values
        .map(
          (e) => e.vehicleOwnerId,
        )
        .toSet();
    final users = await _userRepository.fetchUsers(userIds);

    final workshops = await _workshopRepository.fetchWorkshops(workshopIds);

    return _OfferRelatedData(workshops, requests, users);
  }

  /// Fetch related data for maintenance requests
  Future<_RelatedData> _fetchRelatedData(
      List<QueryDocumentSnapshot> docs) async {
    final userIds = docs
        .map((doc) => (doc.data() as MaintenanceRequest).vehicleOwnerId)
        .toSet();
    final workshopIds = docs
        .map((doc) => (doc.data() as MaintenanceRequest).workshopId)
        .toSet();
    final offerIds =
        docs.map((doc) => (doc.data() as MaintenanceRequest).offerId).toSet();

    final users = await _userRepository.fetchUsers(userIds);
    final workshops = await _workshopRepository.fetchWorkshops(workshopIds);
    final offers = await _offersRepository.fetchOffersBySet(offerIds);

    return _RelatedData(users, workshops, offers);
  }
}

/// Helper class for related data
class _RelatedData {
  final Map<String, QuadroUser> users;
  final Map<String, Workshop> workshops;
  final Map<String, Offer?> offers;

  _RelatedData(this.users, this.workshops, this.offers);
}

class _OfferRelatedData {
  final Map<String, Workshop> workshops;
  final Map<String, MaintenanceRequest> requests;
  final Map<String, QuadroUser> users;

  _OfferRelatedData(this.workshops, this.requests, this.users);
}
