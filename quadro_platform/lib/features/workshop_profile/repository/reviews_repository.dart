import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../workshop_authentication/models/firestore_exceptions.dart';
import 'model/review.dart';

/// for workshop owner set workshop Id via repository construtor immediately and use its API
/// for vehicle owner set workshop id via setter before using its APi
class ReviewsRepository {
  final FirebaseFirestore _firestore;
  String? _currentWorkshopId;

  ReviewsRepository({
    FirebaseFirestore? firestore,
    String? workshopId,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _currentWorkshopId = workshopId;

  // Dynamic setter for updating the workshopId
  void setWorkshopId(String workshopId) {
    _currentWorkshopId = workshopId;
  }

  CollectionReference<Review>? get _reviewRef {
    log(_currentWorkshopId ?? " id is null ");
    if (_currentWorkshopId == null) {
      return null; // Prevent invalid queries if workshopId is not set
    }
    return _firestore
        .collection('workshop')
        .doc(_currentWorkshopId)
        .collection('Reviews')
        .withConverter<Review>(
          fromFirestore: (snapshot, _) =>
              Review.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (review, _) => review.toJson(),
        );
  }

  Future<Map<String, dynamic>> getAverageRatingAndReviewCount() async {
    if (_reviewRef == null) throw Exception("Workshop ID is not set.");
    try {
      // Perform an aggregation query to get the count and average rating
      final aggregation = await _reviewRef!
          .aggregate(
            count(),
            average('rating'),
          )
          .get();

      // Extract results
      final reviewCount = aggregation.count; // Total number of reviews
      final averageRating = aggregation.getAverage('rating'); // Average rating
      return {
        'averageRating': averageRating ?? 0.0,
        'reviewCount': reviewCount ?? 0,
      };
    } on FirebaseException catch (e) {
      throw FirestoreReadWriteFailure(e.code);
    }
  }

  Future<void> addReview(Review review) async {
    if (_reviewRef == null) throw Exception("Workshop ID is not set.");
    try {
      await _reviewRef!.add(review);
    } on FirebaseException catch (e) {
      throw FirestoreReadWriteFailure(e.code);
    }
  }

  Future<void> updateReview(
      String reviewId, Map<String, dynamic> updatedData) async {
    if (_reviewRef == null) throw Exception("Workshop ID is not set.");
    try {
      await _reviewRef!.doc(reviewId).update(updatedData);
    } on FirebaseException catch (e) {
      throw FirestoreReadWriteFailure(e.code);
    }
  }

  Future<List<Review>> getReviews() async {
    if (_reviewRef == null) throw Exception("Workshop ID is not set.");
    try {
      final querySnapshot =
          await _reviewRef!.where('reviewComment', isNull: false).get();
      final reviews = querySnapshot.docs.map((doc) => doc.data()).toList();
      return reviews;
    } on FirebaseException catch (e) {
      throw FirestoreReadWriteFailure(e.code);
    }
  }
}
