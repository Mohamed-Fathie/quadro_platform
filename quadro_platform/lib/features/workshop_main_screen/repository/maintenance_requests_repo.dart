import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quadro_platform/features/user/repository/user_repository.dart';
import 'package:quadro_platform/features/workshop_authentication/models/firestore_exceptions.dart';
import 'package:quadro_platform/features/workshop_authentication/repository/workshop_repo.dart';
import 'package:quadro_platform/features/workshop_main_screen/models/maintenance_request_data_model.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/models/maintenance_request.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/offers_repository.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';
import 'package:quadro_platform/shared/utils/hleper_function/list_splitter.dart';

class MaintenanceRequestsRepository {
  final FirebaseFirestore _firestore;
  final WorkshopRepository _workshopRepository;
  final UserRepository _userRepository;
  final OffersRepository _offersRepository;
  late final CollectionReference<MaintenanceRequest> maintenanceRequestRef;

  MaintenanceRequestsRepository({
    FirebaseFirestore? firestore,
    WorkshopRepository? workshopRepository,
    UserRepository? userRepository,
    OffersRepository? offersRepository,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _workshopRepository = workshopRepository ?? WorkshopRepository(),
        _userRepository = userRepository ?? UserRepository(),
        _offersRepository = offersRepository ?? OffersRepository() {
    maintenanceRequestRef = _firestore
        .collection("MaintenanceRequests")
        .withConverter<MaintenanceRequest>(
          fromFirestore: (snapshot, options) =>
              MaintenanceRequest.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (request, options) => request.toMap(),
        );
  }
  // Helper function to batch fetch Maintenance Requests
  Future<Map<String, MaintenanceRequest>> fetchMaintenanceRequests(
      Set<String> requestIds) async {
    final List<String> request = requestIds.toList();
    final List<List<String>> chunks = splitIntoChunks(request, 10);

    final List<Future<Map<String, MaintenanceRequest>>> futures = chunks.map(
      (chunk) async {
        final snapshots = await maintenanceRequestRef
            .where(FieldPath.documentId, whereIn: chunk)
            .get();
        return {for (var doc in snapshots.docs) doc.id: doc.data()};
      },
    ).toList();
    final List<Map<String, MaintenanceRequest>> requestsChunks =
        await Future.wait(futures);

    return requestsChunks.fold(
      <String, MaintenanceRequest>{},
      (previousValue, element) =>
          {...previousValue as Map<String, MaintenanceRequest>, ...element},
    );
  }

  Future<MaintenanceRequest> getMaintenanceRequestById(
      {required String id}) async {
    try {
      return await maintenanceRequestRef.doc(id).get().then(
            (snapshot) => snapshot.data()!,
          );
    } on FirebaseException catch (e) {
      throw FirestoreReadWriteFailure.fromCode(e.code);
    }
  }

  // fetch all maitenance requests or limit the number of requests
  Stream<List<MaintenanceRequestDomainModel>> fetchRequests(
    String id,
    RequestType type, {
    int? limit,
  }) {
    try {
      Query query = maintenanceRequestRef.where(type.name, isEqualTo: id);

      // Add the limit if provided
      if (limit != null) {
        query = query.limit(limit);
      }

      return query.snapshots().asyncMap((snapshot) async {
        final docs = snapshot.docs;
        final userIds = docs
            .map((doc) => (doc.data() as MaintenanceRequest).vehicleOwnerId)
            .toSet();
        final workshopIds = docs
            .map((doc) => (doc.data() as MaintenanceRequest).workshopId)
            .toSet();
        final offerIds = docs
            .map((doc) => (doc.data() as MaintenanceRequest).offerId)
            .toSet();
        final userMap = await _userRepository.fetchUsers(userIds);
        final workshopMap =
            await _workshopRepository.fetchWorkshops(workshopIds);
        final offersMap = await _offersRepository.fetchOffersBySet(offerIds);
        return docs.map(
          (request) {
            final maintenanceRequest = request.data() as MaintenanceRequest;
            final user = userMap[maintenanceRequest.vehicleOwnerId];
            final workshop = workshopMap[maintenanceRequest.workshopId];
            final offer = offersMap[maintenanceRequest.offerId];
            return MaintenanceRequestDomainModel(
                user: user!,
                id: request.id,
                workshop: workshop!,
                carCompany: maintenanceRequest.carCompany,
                carModel: maintenanceRequest.carModel,
                description: maintenanceRequest.description,
                requestStatus: maintenanceRequest.status,
                dateCreated: maintenanceRequest.dateCreated.toDate(),
                offer: offer);
          },
        ).toList();
      });
    } on FirebaseException catch (e) {
      throw FirestoreReadWriteFailure.fromCode(e.code);
    }
  }
}
