import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/user/model/user.dart';
import '../../../../features/user/repository/user_repository.dart';
import '../../../../features/workshop_authentication/models/firestore_exceptions.dart';
import '../../../../features/workshop_main_screen/models/maintenance_request_data_model.dart';
import '../../../../features/workshop_main_screen/repository/models/maintenance_request.dart';
import '../../../../features/workshop_main_screen/repository/repository_manager.dart';
import '../../../../shared/enum/maitenance_request_status.dart';

part 'main_screen_event.dart';
part 'main_screen_state.dart';

class MainUserScreenBloc extends Bloc<MainScreenEvent, MainUserScreenState> {
  final UserRepository _userRepository;
  final RepositoryManager _manager;
  QuadroUser? _user;
  Future<QuadroUser?> getuser() async {
    _user ??= await _userRepository.getCachedUser();
    _user ??=
        await _userRepository.getUserById(_userRepository.getuserId ?? "");
    return _user;
  }

  MainUserScreenBloc(this._userRepository,
      {required RepositoryManager repositoryManager})
      : _manager = repositoryManager,
        super(const MainUserScreenState(
            errorMessage: null,
            requests: null,
            status: MainUserScreenStatus.reqestloading,
            userName: null)) {
    on<MainScreenStarted>(_onMainScreenStarted);
    on<MainScreenRequestFetched>(_onMainScreenRequestFetched);
    // on<MainScreenOfferNotfiction>((event, emit) async {
    //   await emit.forEach<List<MaintenanceRequest>>(
    //     _manager.maintenanceRequestsRepository.watchOfferSentRequests(),
    //     onData: (requests) => state.copyWith(thereIsOffer: requests.isNotEmpty),
    //     onError: (_, __) => state.copyWith(thereIsOffer: false),
    //   );
    // });
  }
  Future<void> _onMainScreenStarted(
    MainScreenStarted event,
    Emitter<MainUserScreenState> emit,
  ) async {
    try {
      final user = await getuser();

      if (user == null) {
        emit(state.copyWith(
            status: MainUserScreenStatus.failure,
            errorMessage: "مستخدم غير مصرح"));
        return;
      }
      emit(state.copyWith(
          status: MainUserScreenStatus.success, userName: user.name));
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  Future<void> _onMainScreenRequestFetched(
    MainScreenRequestFetched event,
    Emitter<MainUserScreenState> emit,
  ) async {
    emit(state.copyWith(status: MainUserScreenStatus.reqestloading));
    final user = await getuser();

    if (user == null) {
      emit(state.copyWith(
          status: MainUserScreenStatus.failure,
          errorMessage: "مستخدم غير مصرح"));
      return;
    }
    try {
      await emit.forEach(
        _manager.fetchRequests(
            id: user.id,
            type: RequestType.vehicle_owner_id,
            limit: 10,
            withOffer: true),
        onData: (list) => state.copyWith(
            requests: list, status: MainUserScreenStatus.success),
        onError: (error, _) => throw error,
      );
    } on FirestoreReadWriteFailure catch (e) {
      emit(state.copyWith(
          errorMessage: e.message,
          status: MainUserScreenStatus.requestFailure));
    }
  }
}
