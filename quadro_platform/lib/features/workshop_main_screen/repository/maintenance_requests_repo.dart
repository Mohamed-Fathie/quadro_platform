import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quadro_platform/features/workshop_authentication/models/firestore_exceptions.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/models/maintenance_request.dart';
import 'package:quadro_platform/shared/utils/hleper_function/list_splitter.dart';

class MaintenanceRequestsRepository {
  final FirebaseFirestore _firestore;

  late final CollectionReference<MaintenanceRequest> maintenanceRequestRef;

  MaintenanceRequestsRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance {
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

  Future<void> updateRequest(
      {required String id, required Map<String, String> map}) async {
    try {
      await maintenanceRequestRef.doc(id).update(map);
    } on FirebaseException catch (e) {
      throw FirestoreReadWriteFailure.fromCode(e.code);
    }
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
}
