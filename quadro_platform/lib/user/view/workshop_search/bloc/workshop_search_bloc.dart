import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/workshop_authentication/models/firestore_exceptions.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/repository_manager.dart';
import 'package:quadro_platform/user/view/workshop_search/model/workshop_model.dart';

import '../../../../features/google_map/model/location_service_exception.dart';

part 'workshop_search_event.dart';
part 'workshop_search_state.dart';

class WorkshopSearchBloc
    extends Bloc<WorkshopSearchEvent, WorkshopSearchState> {
  final RepositoryManager _manager;
  WorkshopSearchBloc(this._manager) : super(WorkshopSearchInitial()) {
    on<WorkshopFetched>((event, emit) async {
      try {
        await emit.onEach(
          _manager.getNearbyWorkshops(50.0),
          onData: (list) => emit(WorkshopSearchSuccess(workshop: list)),
        );
      } on WorkshopLocationException catch (e) {
        emit(WorkshopSearchFailure(exception: e.message));
      } on FirestoreReadWriteFailure catch (e) {
        emit(WorkshopSearchFailure(exception: e.message));
      }
    });
  }
}
