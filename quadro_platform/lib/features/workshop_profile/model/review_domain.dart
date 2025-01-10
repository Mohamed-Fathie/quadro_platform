import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quadro_platform/features/user/model/user.dart';

@immutable
class ReviewDomainModel extends Equatable {
  final QuadroUser user;

  final double rating;
  final String reviewComment;
  final String id;
  final String? workshopComment;
  final DateTime dateCreated;

  const ReviewDomainModel(
      {required this.user,
      required this.rating,
      required this.reviewComment,
      required this.id,
      required this.workshopComment,
      required this.dateCreated});

  @override
  List<Object?> get props =>
      [user, rating, reviewComment, workshopComment, dateCreated, id];
}
