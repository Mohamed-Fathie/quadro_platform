import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/user/repository/user_repository.dart';
import 'package:quadro_platform/shared/cache/shared_preference.dart';

import '../../../../../shared/enum/user_role.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userRepository;

  LoginBloc(this._userRepository) : super(LoginInitial()) {
    on<AppInitialization>((event, emit) async {
      try {
        // await Future.delayed(const Duration(seconds: 3));
        // Check if onboarding is needed.
        if (await isFirstTimeRegistration()) {
          emit(Onboarding());
          return;
        }

        // Listen to authentication state changes.

        await emit.onEach(
          _userRepository.user,
          onData: (user) {
            log(user?.name ?? "nulle");
            log("the bloc listern");
            if (user == null) {
              emit(Unauthenticated());
            } else {
              log('emit the authenticated');
              emit(Authenticated(userRole: user));
            }
          },
          onError: (error, stackTrace) {
            addError(error, stackTrace);
          },
        );
      } catch (e) {
        emit(AuthError(error: e.toString()));
      }
    });
  }

  Future<bool> isFirstTimeRegistration() async {
    await CacheHelper().init();
    if (await CacheHelper().containsKey(key: "firstTime")) {
      log("the cache is not emity ");
      return false;
    } else {
      await CacheHelper().put(key: "firstTime", value: true);
      log("the cache is  emity ");

      return true;
    }
  }
}
