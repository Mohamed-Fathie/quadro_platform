import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/user/repository/user_repository.dart';

import '../../../shared/enum/user_role.dart';

part 'registeration_state.dart';

class RegisterationCubit extends Cubit<RegisterationState> {
  // final FirebaseAuth userRepository;
  // final UserRepository database;
  RegisterationCubit() : super(RegisterationInitial());

  void selectRole(UserRole role) => emit(RoleSelected(role));
  void unselectRole() => emit(RegisterationInitial());
  void selectedRoleConfirmed(UserRole role) async {
    emit(RegisterationLoading());

    switch (role) {
      case UserRole.vehicleOwner:
        emit(RoleSelectedSuccess(selectedUserRole: role));
      case UserRole.workshopOwner:
        emit(RoleSelectedSuccess(selectedUserRole: role));
      // if (user != null) {
      //   await database.addUser(QuadroUser(
      //       id: user.uid, name: null, email: user.email ?? "", role: role));
      // }

      case UserRole.towService:
        log(role.toLabel());
        emit(RoleSelectedSuccess(selectedUserRole: role));
      // if (user != null) {
      //   await database.addUser(QuadroUser(
      //       id: user.uid, name: null, email: user.email ?? "", role: role));
      // }
    }
  }
}
