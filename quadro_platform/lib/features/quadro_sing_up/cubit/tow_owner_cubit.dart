// tow_service_provider_cubit.dart
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/controller/services/auth_services.dart';
import '../../../shared/enum/image_type.dart';
import '../../../shared/enum/user_role.dart';
import '../../user/repository/user_repository.dart';
import '../../workshop_authentication/repository/storage_repository.dart';
import 'tow_owner_state.dart';

class TowServiceProviderCubit extends Cubit<TowServiceProviderState> {
  final UserRepository userRepository;
  final FirebaseAuth auth;
  final StorageRepository storageRepository;

  TowServiceProviderCubit(
    this.userRepository,
    this.auth,
    this.storageRepository,
  ) : super(const TowServiceProviderState());

  // Existing controllers for common fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // New controllers for tow service provider-specific fields
  final TextEditingController towCompanyController = TextEditingController();
  final TextEditingController towModelController = TextEditingController();
  final TextEditingController towChassisController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();

  // List of vehicle types
  final List<String> vehicleTypes = [
    'اختر نوع مركبتك',
    'سيارة جر',
    'سيارة سحب',
    'نقل ثقيل'
  ];

  /// Updates the selected vehicle type in the state.
  void setSelectedVehicleType(String? type) {
    final newType = type ?? 'اختر نوع مركبتك';
    emit(state.copyWith(selectedVehicleType: newType));
  }

  @override
  Future<void> close() {
    nameController.dispose();
    phoneController.dispose();
    towCompanyController.dispose();
    towModelController.dispose();
    towChassisController.dispose();
    licenseController.dispose();
    return super.close();
  }

  /// Submit method that validates all fields and then performs the necessary actions
  Future<void> submitTowServiceProviderInfo({
    required File? image,
    required String name,
    required String phone,
    required String towCompany,
    required String towModel,
    required String vehicleType,
    required String towChassis,
    required String license,
  }) async {
    // Validate common fields.
    if (name.trim().isEmpty) {
      emit(state.copyWith(
        status: TowServiceProviderStatus.error,
        exception: 'الرجاء إدخال الاسم الكامل',
      ));
      return;
    }

    if (phone.trim().isEmpty || phone.trim().length < 8) {
      emit(state.copyWith(
        status: TowServiceProviderStatus.error,
        exception: 'رقم الجوال غير صحيح',
      ));
      return;
    }

    // Validate tow service provider fields.
    if (towCompany.trim().isEmpty) {
      emit(state.copyWith(
        status: TowServiceProviderStatus.error,
        exception: 'الرجاء إدخال نوع شركة الساحبة',
      ));
      return;
    }

    if (towModel.trim().isEmpty) {
      emit(state.copyWith(
        status: TowServiceProviderStatus.error,
        exception: 'الرجاء إدخال موديل الساحبة',
      ));
      return;
    }

    if (vehicleType == 'اختر نوع مركبتك') {
      emit(state.copyWith(
        status: TowServiceProviderStatus.error,
        exception: 'الرجاء اختيار نوع المركبة',
      ));
      return;
    }

    if (towChassis.trim().isEmpty) {
      emit(state.copyWith(
        status: TowServiceProviderStatus.error,
        exception: 'الرجاء إدخال رقم هيكل الساحبة',
      ));
      return;
    }

    if (license.trim().isEmpty) {
      emit(state.copyWith(
        status: TowServiceProviderStatus.error,
        exception: 'الرجاء إدخال رقم رخصة القيادة',
      ));
      return;
    }

    if (image == null) {
      emit(state.copyWith(
        status: TowServiceProviderStatus.error,
        exception: 'الرجاء اختيار صورة',
      ));
      return;
    }

    // All validations passed; emit a loading state.
    emit(state.copyWith(
        status: TowServiceProviderStatus.loading, exception: null));

    // Retrieve current user and upload the image.
    final user = auth.currentUser;
    final path = ImageType.profile.pathWithId(user?.uid ?? "");
    final url = await storageRepository.uploadImageWithProgress(
      path: path,
      xFile: XFile("path"),
      file: image,
      onProgressUpdate: (progress) {},
    );

    // Create or update the user in your backend.
    // Here, we assume a role for tow service providers (make sure it exists in your model).
    await AuthServices.registerTowingDriver(
      // context: context,
      drivingLicenceNumberController: license,
      emailController: user?.email ?? "",
      mobileController: phone,
      nameController: name,
      passwordController: "passwordController.text.trim()",
      profilePic: url,
      selectVehicleType: vehicleType,
      userType: UserRole.towService.toJson(),
      vehicleBrandController: towCompany,
      vehicleModelController: towModel,
      vehicleRegistrationNumberController: towChassis,
    );

    // After successful submission, emit success.
    emit(state.copyWith(status: TowServiceProviderStatus.success));
  }

  /// Update the profile image in the state.
  void updateProfileImage(File image) {
    emit(state.copyWith(imageFile: image));
  }
}
