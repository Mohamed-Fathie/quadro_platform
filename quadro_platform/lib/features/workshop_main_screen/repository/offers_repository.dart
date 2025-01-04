import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quadro_platform/features/workshop_authentication/models/firestore_exceptions.dart';
import 'package:quadro_platform/features/workshop_authentication/repository/workshop_repo.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/maintenance_requests_repo.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/models/offers.dart';
import 'package:quadro_platform/shared/utils/hleper_function/list_splitter.dart';

class OffersRepository {
  final FirebaseFirestore _firestore;
  late CollectionReference offersRef;

  OffersRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance {
    offersRef = _firestore.collection("Offers").withConverter<Offer>(
          fromFirestore: (snapshot, options) =>
              Offer.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (offer, options) => offer.toJson(),
        );
  }
  Future<String> addOfferToFirebase(Offer offer) async {
    try {
      final offerId = await offersRef.add(offer);
      return offerId.id;
    } on FirebaseException catch (e) {
      throw FirestoreReadWriteFailure(e.code);
    }
  }

  Future<Offer?> getOfferByRequestId({required String requestId}) async {
    try {
      return await offersRef
          .where('request_id', isEqualTo: requestId)
          .get()
          .then(
            (value) => value.docs
                .map(
                  (offer) => offer.exists ? offer as Offer : null,
                )
                .first,
          );
    } on FirebaseException catch (e) {
      throw FirestoreReadWriteFailure(e.code);
    }
  }

  Future<Map<String, Offer?>> fetchOffersBySet(Set<String?> offerIds) async {
    // Filter out null values
    final List<String?> validOfferIds =
        offerIds.where((id) => id != null).toList();

    // Split valid offer IDs into chunks of 10 (Firestore limit for 'whereIn')
    final List<List<String?>> chunks = splitIntoChunks(validOfferIds, 10);

    // Fetch data for each chunk concurrently
    final List<Future<Map<String, Offer?>>> fetchFutures =
        chunks.map((chunk) async {
      // Query Firestore for the current chunk
      final querySnapshot =
          await offersRef.where(FieldPath.documentId, whereIn: chunk).get();

      // Convert snapshot to a Map of Offer IDs to Offer objects
      return {
        for (final doc in querySnapshot.docs) doc.id: doc.data() as Offer?
      };
    }).toList();

    // Wait for all futures to complete and combine the results
    final List<Map<String, Offer?>> fetchedChunks =
        await Future.wait(fetchFutures);

    // Merge all maps into a single map
    return fetchedChunks.fold<Map<String, Offer?>>(
      {},
      (accumulator, currentChunk) => {...accumulator, ...currentChunk},
    );
  }
}
