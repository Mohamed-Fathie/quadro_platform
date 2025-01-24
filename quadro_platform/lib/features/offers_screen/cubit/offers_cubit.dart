import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
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
      final user = await _manager.getCashedQuadroUser();
      id = user.id;
    } else {
      final workshop = await _manager.getCashedWorkshop();
      id = workshop.ownerId;
    }
    return id;
  }

  Future<void> handleOfferFilterChange(int index, RequestType type) async {
    final status = OffersFilter.values[index];
    emit(OfferFetchloading(index: index));

    try {
      final id = await getIdBasedOnRequestType(requestType: type);

      final map = await fetchOffers(id: "3a1BWhzZZCQv7hfHlhHa", type: type);
      switch (status) {
        case OffersFilter.all:
          emit(OfferFetchAllSuccess(
              allOffers: map![OffersFilter.all]!, index: index));
          break;
        case OffersFilter.inprogress:
          emit(OfferFetchInprogressSuccess(
              inprogressOffers: map![OffersFilter.inprogress]!, index: index));
          break;
        case OffersFilter.pending:
          emit(OfferFetchPendingSuccess(
              pendingOffers: map![OffersFilter.pending]!, index: index));
          break;
        case OffersFilter.requests:
          final requests = await _manager.getRequestslist(
              id: "3a1BWhzZZCQv7hfHlhHa", type: type);
          emit(RequestSuccess(requests: requests, index: index));
          statusMap = null;
          break;
      }
    } catch (e) {
      emit(OfferFetchFailure(error: e.toString(), index: index));
    }
  }
}
