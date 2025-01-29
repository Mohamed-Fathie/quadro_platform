import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quadro_platform/features/workshop_authentication/models/firestore_exceptions.dart';
import 'package:quadro_platform/features/workshop_authentication/models/workshop_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/utils/hleper_function/list_splitter.dart';

class WorkshopRepository {
  final FirebaseFirestore _firestore;
  late final CollectionReference workshopRef;
  //mokable class , injecting firestore instance into the constructor and using converter for type safty
  WorkshopRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance {
    workshopRef = _firestore.collection("workshop").withConverter<Workshop>(
          fromFirestore: (snapshot, _) => Workshop.fromJson(snapshot.data()!),
          toFirestore: (workshop, _) => workshop.toJson(),
        );
  }

  // add workshop to firestore
  Future<void> addWorkshop(Workshop workshop) async {
    try {
      await workshopRef.doc(workshop.ownerId).set(workshop);
    } on FirebaseException catch (e) {
      throw FirestoreReadWriteFailure.fromCode(e.code);
    }
  }

// get the current workshop from firestore
  Future<Workshop> getWorkshopById({required String id}) {
    try {
      return workshopRef.doc(id).get().then(
            (value) => value.data()! as Workshop,
          );
    } on FirebaseException catch (e) {
      throw FirestoreReadWriteFailure.fromCode(e.code);
    }
  }

  // Helper function to batch fetch Workshops
  Future<Map<String, Workshop>> fetchWorkshops(Set<String> workshopIds) async {
    final List<String> ids = workshopIds.toList();
    final List<List<String>> chunks = splitIntoChunks(ids, 10);

    List<Future<Map<String, Workshop>>> futures = chunks.map(
      (chunk) async {
        final snapshots =
            await workshopRef.where(FieldPath.documentId, whereIn: chunk).get();
        return {for (var doc in snapshots.docs) doc.id: doc.data() as Workshop};
      },
    ).toList();
    final List<Map<String, Workshop>> workshopChunks =
        await Future.wait(futures);
    return workshopChunks.fold(
      <String, Workshop>{},
      (previousValue, element) =>
          {...previousValue as Map<String, Workshop>, ...element},
    );
  }

  //Cache User Data
  Future<void> cacheUser(Workshop workshop) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = workshop.toJsonMap();
    await prefs.setString('cached_workshop', jsonEncode(userJson));
  }

//Retrieve Cached User Data
  Future<Workshop?> getCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final workshopString = prefs.getString('cached_workshop');

    if (workshopString == null) {
      log("The cached workshop is null");
      return null;
    }

    try {
      final Map<String, dynamic> userJson = jsonDecode(workshopString);

      return Workshop.fromJson(userJson);
    } catch (e, stacktrace) {
      log("Error decoding workshop JSON: $e");
      log("Stacktrace: $stacktrace");
      return null;
    }
  }

  // Clear Cached User Data when log out or delete account
  Future<void> clearCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_workshop');
  }
}
