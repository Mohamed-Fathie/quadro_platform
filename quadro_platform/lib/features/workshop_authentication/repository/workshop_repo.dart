import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quadro_platform/features/workshop_authentication/models/firestore_exceptions.dart';
import 'package:quadro_platform/features/workshop_authentication/models/workshop_user.dart';

class WorkshopRepository {
  final FirebaseFirestore _firestore;
  late final CollectionReference workshopRef;
  //mokable class , injecting firestore instance into the constructor and using converter for type safty
  WorkshopRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance {
    workshopRef = _firestore.collection("workshop").withConverter<Workshop>(
          fromFirestore: (snapshot, options) =>
              Workshop.fromJson(snapshot.data()!),
          toFirestore: (workshop, options) => workshop.toJson(),
        );
  }

  // add workshop to firestore
  Future<void> addWorkshop(Workshop workshop) async {
    await workshopRef.doc(workshop.ownerId).set(workshop).onError(
          (error, stackTrace) =>
              throw FirestroeReadWriteFailure.fromCode(error.code),
        );
  }
}
