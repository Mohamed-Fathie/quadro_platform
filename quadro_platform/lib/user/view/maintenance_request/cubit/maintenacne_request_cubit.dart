import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quadro_platform/features/user/repository/user_repository.dart';
import 'package:quadro_platform/features/workshop_authentication/models/workshop_user.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/models/maintenance_request.dart';
import 'package:quadro_platform/shared/enum/car_brands.dart';
import 'package:quadro_platform/shared/enum/car_models.dart';
import 'package:quadro_platform/shared/enum/image_type.dart';

import '../../../../features/workshop_authentication/repository/storage_repository.dart';
import '../../../../features/workshop_main_screen/repository/maintenance_requests_repo.dart';
import '../../../../shared/enum/maitenance_request_status.dart';

part 'maintenacne_request_state.dart';

class MaintenanceRequestCubit extends Cubit<MaintenanceRequestState> {
  final MaintenanceRequestsRepository _maintenanceRequestsRepository;
  final StorageRepository storageRepository;
  final UserRepository _userRepository;
  MaintenanceRequestCubit(this._maintenanceRequestsRepository,
      this._userRepository, this.storageRepository)
      : super(const MaintenanceRequestState());

  void selectCarBrand(CarBrand brand) {
    emit(state.copyWith(selectedCarBrand: brand, selectedCarModel: null));
  }

  void selectCarModel(CarModels model) {
    emit(state.copyWith(selectedCarModel: model));
  }

  void updateDescription(String description) {
    // Ensure the description does not exceed 350 characters.
    if (description.length <= 350) {
      emit(state.copyWith(
          description: description,
          status: MaintenanceRequestCubitStatues.initial));
    }
  }

  void updateImage(File image) {
    emit(state.copyWith(image: image));
  }

  Future<void> submitRequest(Workshop workshop) async {
    // Validate form fields.
    if (state.selectedCarBrand == null ||
        state.selectedCarModel == null ||
        state.description.isEmpty) {
      return;
    }
    log(state.selectedCarBrand?.name ?? "car brand in null");
    emit(state.copyWith(status: MaintenanceRequestCubitStatues.submitting));
    final path =
        ImageType.maintenance.pathWithId(UserRepository().getuserId ?? "");
    String? url;
    try {
      if (state.image != null) {
        url = await storageRepository.uploadImageWithProgress(
          path: path,
          xFile: XFile("path"),
          file: state.image,
          onProgressUpdate: (double progress) {},
        );
      }
      log(url ?? "urel is null");
      // If submission is successful:
      await _maintenanceRequestsRepository.addMaintenanceRequest(
          MaintenanceRequest(
              requestImageUrl: url,
              vehicleOwnerId: _userRepository.getuserId ?? "",
              workshopId: workshop.ownerId,
              carCompany: state.selectedCarBrand!,
              carModel: state.selectedCarModel!,
              description: state.description,
              status: MaitenanceRequestStatus.pending,
              dateCreated: Timestamp.fromDate(DateTime.now())));

      emit(state.copyWith(status: MaintenanceRequestCubitStatues.success));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(
          status: MaintenanceRequestCubitStatues.failure,
          errorMessage: e.toString()));
    }
  }
}
