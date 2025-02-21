import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String? id;
  final String userId;
  final double rating;
  final String? reviewComment;
  final String? workshopComment;
  final DateTime dateCreated;

  const Review({
    this.id,
    required this.userId,
    required this.rating,
    required this.reviewComment,
    required this.workshopComment,
    required this.dateCreated,
  });

  @override
  List<Object?> get props => [
        id,
        dateCreated,
        userId,
        rating,
        workshopComment,
        reviewComment,
      ];

  // Factory constructor to create a Review instance from JSON
  factory Review.fromJson(String id, Map<String, dynamic> json) {
    return Review(
      id: id,
      userId: json['userId'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewComment: json['reviewComment'] as String?,
      workshopComment: json['workshopComment'] as String?,
      dateCreated: (json['dateCreated'] as Timestamp).toDate(),
    );
  }

  // Method to convert a Review instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'rating': rating,
      'reviewComment': reviewComment,
      'workshopComment': workshopComment,
      'dateCreated': Timestamp.fromDate(dateCreated),
    };
  }
}
