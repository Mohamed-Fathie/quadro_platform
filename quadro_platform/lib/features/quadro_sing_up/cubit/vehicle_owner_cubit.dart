import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quadro_platform/features/user/model/user.dart';
import 'package:quadro_platform/features/user/repository/user_repository.dart';

import '../../../shared/enum/image_type.dart';
import '../../../shared/enum/user_role.dart';
import '../../workshop_authentication/repository/storage_repository.dart';
import 'vehicle_owner_state.dart';

class VehicleOwnerCubit extends Cubit<VehicleOwnerState> {
  final UserRepository userRepository;
  final FirebaseAuth auth;
  final StorageRepository storageRepository;
  VehicleOwnerCubit(
    this.userRepository,
    this.auth,
    this.storageRepository,
  ) : super(const VehicleOwnerState());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Future<void> close() {
    nameController.dispose();
    phoneController.dispose();
    return super.close();
  }

  Future<void> submitVehicleOwnerInfo({
    required File? image,
    required String name,
    required String phone,
  }) async {
    // Validate the name field
    if (name.trim().isEmpty) {
      emit(state.copyWith(
        status: VehicleOwnerStatus.error,
        exception: 'الرجاء إدخال الاسم الكامل',
      ));
      return;
    }

    // Validate the phone field (ensuring at least 8 digits)
    if (phone.trim().isEmpty || phone.trim().length < 8) {
      emit(state.copyWith(
        status: VehicleOwnerStatus.error,
        exception: 'رقم الجوال غير صحيح',
      ));
      return;
    }

    // Validate that an image has been selected
    if (image == null) {
      emit(state.copyWith(
        status: VehicleOwnerStatus.error,
        exception: 'الرجاء اختيار صورة',
      ));
      return;
    }

    // If all validations pass, clear any previous error and emit loading state.
    emit(state.copyWith(status: VehicleOwnerStatus.loading, exception: null));
    final user = auth.currentUser;
    final path = ImageType.profile.pathWithId(user?.uid ?? "");
    final url = await storageRepository.uploadImageWithProgress(
      path: path,
      xFile: XFile("path"),
      file: image,
      onProgressUpdate: (p0) {},
    );
    await userRepository.addUser(QuadroUser(
        id: user?.uid ?? '',
        name: name,
        email: user?.email ?? "",
        phone: phone,
        pictureUrl: url,
        role: UserRole.vehicleOwner));
    // After successful submission, emit the success state.
    emit(state.copyWith(status: VehicleOwnerStatus.success));
  }

  void updateProfileImage(File image) {
    // Update the image in the state.
    emit(state.copyWith(imageFile: image));
  }
}
