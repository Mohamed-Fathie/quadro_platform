import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/repository_manager.dart';
import 'package:quadro_platform/features/workshop_profile/model/Review_Domain.dart';
import 'package:quadro_platform/features/workshop_profile/repository/reviews_repository.dart';
import 'package:quadro_platform/shared/enum/workshop_profile_menu.dart';

import '../../../common/controller/services/auth_services.dart';
import '../../workshop_authentication/models/firestore_exceptions.dart';
import '../../workshop_authentication/models/workshop_user.dart';
import '../../workshop_authentication/repository/workshop_repo.dart';

part 'workshop_profile_state.dart';

class WorkshopProfileCubit extends Cubit<WorkshopProfileState> {
  final RepositoryManager repoManager;
  final WorkshopRepository workshopRepo;
  ReviewsRepository? reviewsRepo; // Dynamically initialized
  Workshop? workshop;

  WorkshopProfileCubit({
    this.workshop,
    required this.repoManager,
    required this.workshopRepo,
  }) : super(const WorkshopProfileState(
          commentErrorMessages: {},
          reviewslist: [],
          status: WorkshopProfileStatus.loading,
        ));
  void onSelectedMenu(WorkshopProfileMenu clecked, BuildContext context) async {
    switch (clecked) {
      case WorkshopProfileMenu.logout:
        AuthServices.logOutUser(context);
        await workshopRepo.clearCachedUser();
      case WorkshopProfileMenu.edit:
        emit(state.copyWith(status: WorkshopProfileStatus.editing));
    }
  }

  void refereshe() async {
    emit(state.copyWith(status: WorkshopProfileStatus.edited));
    emit(state.copyWith(
      status: WorkshopProfileStatus.loading,
    ));
    Workshop? refershedWorkshop = await workshopRepo.getCachedUser();
    refershedWorkshop ??=
        await workshopRepo.getWorkshopById(id: repoManager.authUserId);
    workshop = refershedWorkshop;
    await initialize();
  }

  Future<void> initialize() async {
    try {
      // Resolve the workshop either from the provided data or cached data
      // workshop = null;
      // log("first workshop: ${workshop?.toJson().toString() ?? "workshop is null "}");

      workshop ??= await workshopRepo.getCachedUser();
      // log("second workshop: ${workshop?.toJson().toString() ?? "workshop is null "}");

      workshop ??=
          await workshopRepo.getWorkshopById(id: repoManager.authUserId);
      // log("third workshop: ${workshop?.toJson().toString() ?? "workshop is null "}");

      reviewsRepo = ReviewsRepository(workshopId: workshop!.ownerId);
      final average = await reviewsRepo?.getAverageRatingAndReviewCount();
      emit(state.copyWith(
          reviewInfo: average,
          status: WorkshopProfileStatus.success,
          workshop: workshop));
    } on FirestoreReadWriteFailure catch (e) {
      emit(state.copyWith(
          errorMessage: e.message, status: WorkshopProfileStatus.failure));
    }
  }

  Future<void> workshopProfileReviewFetched() async {
    try {
      final reviewlist =
          await repoManager.getReviews(workshopId: workshop!.ownerId);
      emit(state.copyWith(
          reviewslist: reviewlist,
          status: WorkshopProfileStatus.fetchreviewsuccess));
    } on FirestoreReadWriteFailure catch (e) {
      emit(state.copyWith(
          errorMessage: e.message, status: WorkshopProfileStatus.failure));
    }
  }

  Future<void> submitWorkshopComment(String reviewId, String comment) async {
    final isvalid = validateAndEmit(
      value: comment,
      validator: validateCommentField,
      errorCallback: (errorMessage) {
        final updatedMessages =
            Map<String, String?>.from(state.commentErrorMessages);
        if (errorMessage == null) {
          updatedMessages.remove(reviewId);
        } else {
          updatedMessages[reviewId] = errorMessage;
        }
        emit(state.copyWith(commentErrorMessages: updatedMessages));
      },
    );
    if (!isvalid) {
      return;
    }
    emit(state.copyWith(status: WorkshopProfileStatus.sendingLoading));

    try {
      await reviewsRepo!.updateReview(reviewId, {"workshopComment": comment});
      // Update local state with the new comment
      emit(state.copyWith(
        status: WorkshopProfileStatus.fetchreviewsuccess,
      ));
      workshopProfileReviewFetched();
    } catch (e) {
      emit(state.copyWith(status: WorkshopProfileStatus.failure));
    }
  }

  void onCommentFieldChanged(String? value, String reviewId) {
    validateAndEmit(
      value: value,
      validator: validateCommentField,
      errorCallback: (errorMessage) {
        final updatedMessages =
            Map<String, String?>.from(state.commentErrorMessages);
        if (errorMessage == null) {
          updatedMessages.remove(reviewId);
        } else {
          updatedMessages[reviewId] = errorMessage;
        }

        emit(state.copyWith(commentErrorMessages: updatedMessages));
      },
    );
  }

  bool validateAndEmit({
    required String? value,
    required String? Function(String?) validator,
    required Function(String?) errorCallback,
  }) {
    final validationMessage = validator(value);
    final isValid = validationMessage == null;

    errorCallback(isValid ? null : validationMessage);
    return isValid;
  }

  String? validateCommentField(String? value) {
    if (value == null || value.isEmpty) {
      return "الحقل لا يمكن أن يكون فارغًا."; // "Field cannot be empty."
    }

    if (value.length > 200) {
      return "الرد يجب ألا يتجاوز 200 حرف."; // "Reply must not exceed 200 characters."
    }
    return null; // Valid input
  }
}
