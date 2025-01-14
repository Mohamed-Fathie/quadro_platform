import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/workshop_authentication/repository/workshop_repo.dart';
import 'package:quadro_platform/features/workshop_main_screen/models/maintenance_request_data_model.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/repository_manager.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';
import 'package:quadro_platform/shared/enum/offers_filter.dart';

part 'workshop_offers_state.dart';

// use     id: "RQcyfgqN9ld9GeaOhlgKC2LK5ih2"  for testing purposes

class WorkshopOffersCubit extends Cubit<WorkshopOffersState> {
  Map<OffersFilter, List<MaintenanceRequestDomainModel>>? statusMap;
  final RepositoryManager _manager;
  final WorkshopRepository _workshopRepository;
  WorkshopOffersCubit(this._manager, this._workshopRepository)
      : super(const WorkshopOfferFetchloading(index: 0));

  Future<Map<OffersFilter, List<MaintenanceRequestDomainModel>>?> fetchOffers({
    required String id,
    required RequestType type,
  }) async {
    if (statusMap != null) return statusMap!;
    return statusMap = await _manager.getoffers(id: id, type: type);
  }

  Future<void> handleOfferFilterChange(int index, RequestType type) async {
    final status = OffersFilter.values[index];
    emit(WorkshopOfferFetchloading(index: index));

    try {
      final id = await _workshopRepository.getCachedUser();

      final map = await fetchOffers(id: id.ownerId, type: type);
      switch (status) {
        case OffersFilter.all:
          emit(WorkshopOfferFetchAllSuccess(
              allOffers: map![OffersFilter.all]!, index: index));
          break;
        case OffersFilter.inprogress:
          emit(WorkshopOfferFetchInprogressSuccess(
              inprogressOffers: map![OffersFilter.inprogress]!, index: index));
          break;
        case OffersFilter.pending:
          emit(WorkshopOfferFetchPendingSuccess(
              pendingOffers: map![OffersFilter.pending]!, index: index));
          break;
        case OffersFilter.requests:
          final requests =
              await _manager.getRequestslist(id: id.ownerId, type: type);
          emit(WorkshopRequestSuccess(requests: requests, index: index));
          statusMap = null;
          break;
      }
    } catch (e) {
      emit(WorkshopOfferFetchFailure(error: e.toString(), index: index));
    }
  }
}
