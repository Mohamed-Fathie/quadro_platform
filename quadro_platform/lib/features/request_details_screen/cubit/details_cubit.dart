import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart' show TextEditingController;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/workshop_main_screen/models/maintenance_request_data_model.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/models/maintenance_request.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/offers_repository.dart';
import 'package:quadro_platform/features/workshop_profile/repository/model/review.dart';
import 'package:quadro_platform/features/workshop_profile/repository/reviews_repository.dart';
import 'package:quadro_platform/shared/enum/offer_status.dart';
import 'package:quadro_platform/user/view/maintenance_request/cubit/maintenacne_request_cubit.dart';

import '../../../shared/enum/maitenance_request_status.dart';
import '../../workshop_main_screen/repository/maintenance_requests_repo.dart';

part 'details_state.dart';

class DetailsCubit extends Cubit<RequestDetailsState> {
  final ReviewsRepository review;
  final MaintenanceRequestsRepository maintenanceRequestsRepository;
  final OffersRepository offersRepository;
  final TextEditingController commentController = TextEditingController();

  DetailsCubit(
      this.maintenanceRequestsRepository, this.offersRepository, this.review)
      : super(const RequestDetailsState(
            canMarkCompleted: false,
            canMarkInProgress: false,
            canRateService: false,
            canRespond: false));
  Future<void> deleteRequest(String id) async {
    await maintenanceRequestsRepository.updateRequest(
        id: id, map: {"status": MaitenanceRequestStatus.rejected.name});
  }

  void initionlization({
    required RequestType requestType,
    required MaintenanceRequestDomainModel request,
  }) {
    emit(RequestDetailsState(
        canMarkCompleted: requestType == RequestType.workshop_id &&
            request.offer?.status == OfferStatus.inprogress,
        canRespond: requestType == RequestType.vehicle_owner_id &&
            request.offer != null &&
            request.offer?.status != OfferStatus.rejected &&
            request.offer?.status != OfferStatus.accepted &&
            request.offer?.status != OfferStatus.inprogress &&
            request.offer?.status != OfferStatus.completed,
        canMarkInProgress: requestType == RequestType.workshop_id &&
            request.offer?.status == OfferStatus.accepted,
        canRateService: requestType == RequestType.vehicle_owner_id &&
            request.requestStatus != MaitenanceRequestStatus.inProgress &&
            request.requestStatus != MaitenanceRequestStatus.complted &&
            request.offer?.status == OfferStatus.completed));
  }

  @override
  Future<void> close() {
    commentController.dispose();
    return super.close();
  }

  void acceptOffer(String requestId, String offerId) async {
    // Implement acceptance logic
    emit(state.copyWith(
        canRespond: false, offerStatus: OfferStatus.accepted.arabicName));
    await maintenanceRequestsRepository.updateRequest(
        id: requestId, map: {"status": MaitenanceRequestStatus.accepted.name});
    await offersRepository
        .updateOffer(id: offerId, map: {"status": OfferStatus.accepted.name});
  }

  void rejectOffer(String requestId, String offerId) async {
    emit(state.copyWith(
        canRespond: false, offerStatus: OfferStatus.rejected.arabicName));

    await maintenanceRequestsRepository.updateRequest(
        id: requestId, map: {"status": MaitenanceRequestStatus.offerSent.name});
    await offersRepository
        .updateOffer(id: offerId, map: {"status": OfferStatus.rejected.name});
  }

  Future<void> markOfferInProgress(
      {required String requestId, required String offerId}) async {
    emit(state.copyWith(
        canMarkInProgress: false,
        offerStatus: OfferStatus.inprogress.arabicName));

    //  await maintenanceRequestsRepository.updateRequest(id: requestId, map: map)
    await offersRepository
        .updateOffer(id: offerId, map: {"status": OfferStatus.inprogress.name});
  }

  Future<void> markOfferAsCompleted({
    required String requestId,
    required String offerId,
  }) async {
    try {
      emit(state.copyWith(
          canMarkCompleted: false,
          offerStatus: OfferStatus.completed.arabicName));

      await offersRepository.updateOffer(
          id: offerId, map: {"status": OfferStatus.completed.name});
      // Add any additional state updates or events
    } catch (e) {
      // Handle error
    }
  }

  Future<void> submitRating({
    required String userId,
    String? comment,
    required String workshopId,
    required String requestId,
    required String offerId,
    required double rating,
  }) async {
    review.setWorkshopId(workshopId);
    await review.addReview(Review(
        userId: userId,
        rating: rating,
        reviewComment: comment == null
            ? null
            : comment.trim().isEmpty
                ? null
                : comment.trim(),
        workshopComment: null,
        dateCreated: DateTime.now()));
    await maintenanceRequestsRepository.updateRequest(
        id: requestId, map: {"status": MaitenanceRequestStatus.complted.name});
    emit(state.copyWith(canRateService: false));
  }
}
