import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/user/model/user.dart';
import 'package:quadro_platform/features/workshop_authentication/models/workshop_user.dart';
import 'package:quadro_platform/features/workshop_main_screen/models/maintenance_request_data_model.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/repository_manager.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';
import 'package:quadro_platform/shared/enum/offers_filter.dart';

part 'offers_state.dart';

// use     id: "RQcyfgqN9ld9GeaOhlgKC2LK5ih2"  for testing purposes

class OffersCubit extends Cubit<OffersState> {
  Map<OffersFilter, List<MaintenanceRequestDomainModel>>? statusMap;
  final RepositoryManager _manager;
  OffersCubit(
    this._manager,
  ) : super(const OfferFetchloading(index: 0));

  Future<Map<OffersFilter, List<MaintenanceRequestDomainModel>>?> fetchOffers({
    required String id,
    required RequestType type,
  }) async {
    if (statusMap != null) return statusMap!;

    return statusMap = await _manager.getoffers(id: id, type: type);
  }

  Future<String> getIdBasedOnRequestType(
      {required RequestType requestType}) async {
    final String id;
    if (requestType == RequestType.vehicle_owner_id) {
      QuadroUser? user;
      user ??= await _manager.userRepository.getUserById(_manager.authUserId);
      id = user?.id ?? "";
    } else {
      Workshop? workshop;
      workshop ??= await _manager.workshopRepository
          .getWorkshopById(id: _manager.authUserId);
      id = workshop.ownerId;
    }
    return id;
  }

  Future<void> handleOfferFilterChange(int index, RequestType type) async {
    final status = OffersFilter.values[index];
    emit(OfferFetchloading(index: index));
    try {
      final id = await getIdBasedOnRequestType(requestType: type);
// "3a1BWhzZZCQv7hfHlhHa"
      // final map = await fetchOffers(id: id, type: type);

      switch (status) {
        case OffersFilter.all:
          statusMap = await _manager.getoffers(id: id, type: type);

          emit(OfferFetchAllSuccess(
              allOffers: statusMap![OffersFilter.all]!, index: index));
          break;
        case OffersFilter.inprogress:
          statusMap = await _manager.getoffers(id: id, type: type);

          emit(OfferFetchInprogressSuccess(
              inprogressOffers: statusMap![OffersFilter.inprogress]!,
              index: index));
          break;
        case OffersFilter.pending:
          statusMap = await _manager.getoffers(id: id, type: type);

          emit(OfferFetchPendingSuccess(
              pendingOffers: statusMap![OffersFilter.pending]!, index: index));
          break;
        case OffersFilter.requests:
          // "3a1BWhzZZCQv7hfHlhHa"
          final requests = await _manager.getRequestslist(id: id, type: type);
          emit(RequestSuccess(requests: requests, index: index));
          statusMap = null;
          break;
        case OffersFilter.accepted:
          statusMap = await _manager.getoffers(id: id, type: type);
          emit(OfferFetchAcceptedSuccess(
              acceptedOffers: statusMap![OffersFilter.accepted]!,
              index: index));
          break;
        case OffersFilter.rejected:
          statusMap = await _manager.getoffers(id: id, type: type);
          emit(OfferFetchRejectedSuccess(
              rejectedOffers: statusMap![OffersFilter.rejected]!,
              index: index));
          break;
        case OffersFilter.completed:
          statusMap = await _manager.getoffers(id: id, type: type);
          emit(OfferFetchCompletedSuccess(
              completed: statusMap![OffersFilter.completed]!, index: index));
          break;
      }
    } catch (e) {
      emit(OfferFetchFailure(error: e.toString(), index: index));
    }
  }
}
