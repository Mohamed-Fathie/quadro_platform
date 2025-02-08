import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/workshop_authentication/models/workshop_user.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/offers_repository.dart';
import 'package:quadro_platform/features/workshop_profile/repository/model/review.dart';
import 'package:quadro_platform/features/workshop_profile/repository/reviews_repository.dart';
import 'package:quadro_platform/shared/enum/offer_status.dart';

import '../../../shared/enum/maitenance_request_status.dart';
import '../../workshop_main_screen/repository/maintenance_requests_repo.dart';

part 'details_state.dart';

class DetailsCubit extends Cubit<DetailsState> {
  final ReviewsRepository review;
  final MaintenanceRequestsRepository maintenanceRequestsRepository;
  final OffersRepository offersRepository;
  DetailsCubit(
      this.maintenanceRequestsRepository, this.offersRepository, this.review)
      : super(DetailsInitial());
  Future<void> deleteRequest(String id) async {
    await maintenanceRequestsRepository.updateRequest(
        id: id, map: {"status": MaitenanceRequestStatus.rejected.name});
  }

  void acceptOffer(String requestId, String offerId) async {
    log(" here is the accpted offer : $offerId");
    // Implement acceptance logic
    await maintenanceRequestsRepository.updateRequest(
        id: requestId, map: {"status": MaitenanceRequestStatus.offerSent.name});
    await offersRepository
        .updateOffer(id: offerId, map: {"status": OfferStatus.accepted.name});
  }

  void rejectOffer(String requestId, String offerId) async {
    await maintenanceRequestsRepository.updateRequest(
        id: requestId, map: {"status": MaitenanceRequestStatus.offerSent.name});
    await offersRepository
        .updateOffer(id: offerId, map: {"status": OfferStatus.rejected.name});
  }

  Future<void> markOfferInProgress(
      {required String requestId, required String offerId}) async {
    //  await maintenanceRequestsRepository.updateRequest(id: requestId, map: map)
    await offersRepository
        .updateOffer(id: offerId, map: {"status": OfferStatus.inprogress.name});
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
        reviewComment: comment,
        workshopComment: null,
        dateCreated: DateTime.now()));
    await maintenanceRequestsRepository.updateRequest(
        id: requestId,
        map: {"status": MaitenanceRequestStatus.inProgress.name});
  }
}
