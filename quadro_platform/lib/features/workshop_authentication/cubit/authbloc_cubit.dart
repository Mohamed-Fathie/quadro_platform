import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quadro_platform/features/google_map/model/selected_location.dart';
import 'package:quadro_platform/features/user/repository/user_repository.dart';
import 'package:quadro_platform/features/workshop_authentication/models/firestore_exceptions.dart';
import 'package:quadro_platform/features/workshop_authentication/models/workshop_user.dart';
import 'package:quadro_platform/features/workshop_authentication/repository/storage_repository.dart';
import 'package:quadro_platform/features/workshop_authentication/repository/workshop_repo.dart';
import 'package:quadro_platform/shared/enum/car_brands.dart';
import 'package:quadro_platform/shared/enum/image_type.dart';
import 'package:quadro_platform/shared/enum/spare_parts.dart';

import '../../../shared/utils/extension/coordination_togeopoint.dart';

part 'authbloc_state.dart';

class WorkshopAuthbloc extends Cubit<WorkshopAuthblocState> {
  WorkshopAuthbloc(
      this._workshopRepository, this._storageRepository, this._user)
      : // Initialize here
        super(const WorkshopAuthblocState());
  final WorkshopRepository _workshopRepository;
  final StorageRepository _storageRepository;
  final UserRepository _user;

  final TextEditingController menuController = TextEditingController();
  final TextEditingController textareaController = TextEditingController();

  @override
  Future<void> close() {
    menuController.dispose();
    textareaController.dispose();
    return super.close();
  }

  // Add image for workshop
  Future<void> uploadImage({
    required ImageType imageType,
    required XFile? file,
  }) async {
    // final currentUser = await _user.getCachedUser();
    // if (file == null || currentUser == null) return;

    try {
      emit(state.copyWith(
        status: WorkshopAuthStatus.loading,
        progress: 0.0,
      ));

      // Generate the dynamic path using userId
      final path = imageType.pathWithId("currentUser.id");

      // Upload the image to the determined path
      final url = await _storageRepository.uploadImageWithProgress(
        path: path,
        xFile: file!,
        onProgressUpdate: (double progress) {
          emit(state.copyWith(
            progress: progress,
            status: WorkshopAuthStatus.loading,
          ));
        },
      );

      // Update state based on the enum value
      switch (imageType) {
        case ImageType.profile:
          emit(state.copyWith(
            imageProfile: file,
            profilImageUrl: url,
            status: WorkshopAuthStatus.success,
          ));
          break;
        case ImageType.idCard:
          emit(state.copyWith(
            idcardUrl: url,
            status: WorkshopAuthStatus.success,
          ));
          break;
        case ImageType.tradeLicense:
          emit(state.copyWith(
            licensUrl: url,
            status: WorkshopAuthStatus.success,
          ));
          break;
      }
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(
        exception: e.toString(),
        status: WorkshopAuthStatus.failure,
      ));
    }
  }

  // Add brands for workshop
  void addBrands(CarBrand brand) {
    final updatedBrands = state.brands.toList()..add(brand);

    emit(state.copyWith(
        brands: updatedBrands, status: WorkshopAuthStatus.success));
  }

  // Delete brand
  void deleteBrand(CarBrand brand) {
    final updatedBrands = state.brands.toList()..remove(brand);
    emit(state.copyWith(
        brands: updatedBrands, status: WorkshopAuthStatus.success));
  }

  void updateText(String text) {
    emit(state.copyWith(description: text));
  }

  // Select spare parts status
  void onSelected(SparePartsStatus status) {
    final updatedParts = Map<SparePartsStatus, bool>.from(state.partsStatus);

    updatedParts[status] = !(updatedParts[status] ?? false);

    emit(state.copyWith(
      partsStatus: updatedParts,
      status: WorkshopAuthStatus.success,
    ));
  }

  void onSelectedLocation(SelectedLocation location) {
    emit(state.copyWith(location: location));
  }

  // Save data to repository
  Future<void> saveData() async {
    final currentUser = await _user.getUserById((_user.getuserId!));

    if (currentUser == null) {
      emit(state.copyWith(
          exception: "المستخدم ليس موثق", status: WorkshopAuthStatus.failure));
      return;
    }
    if (state.location == null) {
      return;
    }

    try {
      emit(state.copyWith(status: WorkshopAuthStatus.loading));
      final workshop = Workshop(
        imagePath: currentUser.pictureUrl ?? "",
        city: state.location?.city,
        coordination: state.location!.coordinates.toGeoFirePoint(),
        street: state.location?.street,
        name: currentUser.name,
        ownerId: currentUser.id,
        description: state.description,
        phone: currentUser.phone ?? "",
        status: state.truePartsStatus,
        carBrands: state.brands,
      );
      await _workshopRepository.addWorkshop(workshop);
      log(workshop.toJsonMap().toString());
      await _workshopRepository.cacheUser(workshop);
      emit(state.copyWith(status: WorkshopAuthStatus.workshopAuthenticated));
    } on FirestoreReadWriteFailure catch (e) {
      emit(state.copyWith(
          exception: e.message, status: WorkshopAuthStatus.failure));
    }
  }
}
