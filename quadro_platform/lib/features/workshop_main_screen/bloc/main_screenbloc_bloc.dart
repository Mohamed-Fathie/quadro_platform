import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/workshop_authentication/models/firestore_exceptions.dart';
import 'package:quadro_platform/features/workshop_authentication/models/workshop_user.dart';
import 'package:quadro_platform/features/workshop_authentication/repository/workshop_repo.dart';
import 'package:quadro_platform/features/workshop_main_screen/models/maintenance_request_data_model.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/repository_manager.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';
part 'main_screenbloc_event.dart';
part 'main_screenbloc_state.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  final RepositoryManager _manager;
  final WorkshopRepository _workshopRepository;
  Workshop? _workshop;
  Future<Workshop?> getWorkshop() async {
    if (_workshop == null) {
      log("we are here in the workshop main screeen");
      _workshop = await _workshopRepository.getCachedUser();
      log(_workshop?.toJson().toString() ?? "workshop is null");
      return _workshop;
    }
    return _workshop;
  }

  MainScreenBloc(this._workshopRepository,
      {required RepositoryManager repositoryManager})
      : _manager = repositoryManager,
        super(const MainScreenState()) {
    // defualt consturctor
    on<MainScreenStarted>(_onMainScreenStarted);
    on<MainScreenRequestFetched>(_onMainScreenRequestFetched);
    on<MainScreenOffersFetched>(_onMainScreenOffersFetched);
  }

  Future<void> _onMainScreenStarted(
    MainScreenStarted event,
    Emitter<MainScreenState> emit,
  ) async {
    try {
      final workshop = _workshop ?? await getWorkshop();
      emit(state.copyWith(
          workshop: workshop!, status: MainScreenStatus.success));
    } on FirestoreReadWriteFailure catch (e) {
      emit(state.copyWith(
          errorMessage: e.message, status: MainScreenStatus.failure));
    }
  }

  Future<void> _onMainScreenRequestFetched(
    MainScreenRequestFetched event,
    Emitter<MainScreenState> emit,
  ) async {
    emit(state.copyWith(status: MainScreenStatus.reqestloading));
// "1SByKZ4gSPNpwaO9g2AgQ9HKrvj2" for testing
    // Listen to requests stream
    final workshop = _workshop ?? await getWorkshop();

    try {
      await emit.forEach(
        _manager.fetchRequests(
            id: workshop!.ownerId,
            type: RequestType.workshop_id,
            limit: 10,
            withOffer: true),
        onData: (list) =>
            state.copyWith(requests: list, status: MainScreenStatus.success),
        onError: (error, _) => throw error,
      );
    } on FirestoreReadWriteFailure catch (e) {
      emit(state.copyWith(
          errorMessage: e.message, status: MainScreenStatus.requestFailure));
    }
  }

  Future<void> _onMainScreenOffersFetched(
    MainScreenOffersFetched event,
    Emitter<MainScreenState> emit,
  ) async {
    emit(state.copyWith(status: MainScreenStatus.offerloading));
    // Listen to offers stream
    final workshop = _workshop ?? await getWorkshop();

    try {
      await emit.forEach(
        _manager.fetchRequests(
            id: workshop!.ownerId,
            type: RequestType.workshop_id,
            limit: 10,
            withOffer: false),
        onData: (list) =>
            state.copyWith(offers: list, status: MainScreenStatus.success),
        onError: (error, _) => throw error,
      );
    } on FirestoreReadWriteFailure catch (e) {
      emit(state.copyWith(
          errorMessage: e.message, status: MainScreenStatus.offerFailure));
    }
  }
}
