import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quadro_platform/shared/utils/extension/coordination_togeopoint.dart';

import '../../../shared/enum/car_brands.dart';
import '../../../shared/enum/image_type.dart';
import '../../../shared/enum/spare_parts.dart';
import '../../google_map/model/selected_location.dart';
import '../../user/repository/user_repository.dart';
import '../../workshop_authentication/models/workshop_user.dart';
import '../../workshop_authentication/repository/storage_repository.dart';
import '../../workshop_authentication/repository/workshop_repo.dart';

part 'workshop_edit_state.dart';

class WorkshopEditBloc extends Cubit<WorkshopEditState> {
  WorkshopEditBloc(
    this._workshopRepository,
    this._storageRepository,
    this._userRepository,
  ) : super(const WorkshopEditState());

  final WorkshopRepository _workshopRepository;
  final StorageRepository _storageRepository;
  final UserRepository _userRepository;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Future<void> close() {
    descriptionController.dispose();
    return super.close();
  }

  // Initialize with existing workshop data
  void initializeData() async {
    emit(state.copyWith(status: WorkshopEditStatus.initial));
    // await Future.delayed(const Duration(seconds: 3));

    Workshop? workshop = await _workshopRepository.getCachedUser();
    workshop ??= await _workshopRepository.getWorkshopById(
        id: (_userRepository.getuserId!));
    descriptionController.text = workshop.description;
    nameController.text = workshop.name;
    phoneController.text = workshop.phone;
    emit(state.copyWith(
        name: workshop.name,
        phone: workshop.phone,
        workshop: workshop,
        description: workshop.description,
        brands: workshop.carBrands,
        partsStatus: _mapPartsStatus(workshop.status),
        location: SelectedLocation(
          city: workshop.city,
          street: workshop.street,
          coordinates:
              (workshop.coordination?.data["geopoint"] as GeoPoint).toLatLng(),
        ),
        imageUrl: workshop.imagePath,
        status: WorkshopEditStatus.success));
  }

  Map<SparePartsStatus, bool> _mapPartsStatus(List<SparePartsStatus> statuses) {
    return Map.fromIterables(
      SparePartsStatus.values,
      SparePartsStatus.values.map((s) => statuses.contains(s)),
    );
  }

// Add update methods
  void updateName(String value) {
    nameController.text = value;
    emit(state.copyWith(name: value));
  }

  void updatePhone(String value) {
    phoneController.text = value;
    emit(state.copyWith(phone: value));
  }

  // Image handling
  Future<void> updateProfileImage(XFile? file) async {
    if (file == null) return;

    try {
      emit(state.copyWith(status: WorkshopEditStatus.loading));

      final path = ImageType.profile.pathWithId(_userRepository.getuserId!);
      final url = await _storageRepository.uploadImageWithProgress(
        path: path,
        xFile: file,
        onProgressUpdate: (p0) {},
      );

      emit(state.copyWith(
        status: WorkshopEditStatus.success,
        imageFile: file,
        imageUrl: url,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: WorkshopEditStatus.failure,
        exception: 'Failed to update image: ${e.toString()}',
      ));
    }
  }

  // Brand management
  void updateBrands(CarBrand brand, bool isAdding) {
    final updatedBrands = List<CarBrand>.from(state.brands);
    isAdding ? updatedBrands.add(brand) : updatedBrands.remove(brand);

    emit(state.copyWith(brands: updatedBrands));
  }

  // Form field updates
  void updateDescription(String text) {
    descriptionController.text = text;
    emit(state.copyWith(description: text));
  }

  void updatePartsStatus(SparePartsStatus status) {
    final updatedStatus = Map<SparePartsStatus, bool>.from(state.partsStatus);
    updatedStatus[status] = !updatedStatus[status]!;
    emit(state.copyWith(partsStatus: updatedStatus));
  }

  void updateLocation(SelectedLocation location) {
    emit(state.copyWith(location: location));
  }

  // Save updated data
  Future<void> saveChanges() async {
    try {
      if (state.name.isEmpty) {
        emit(state.copyWith(
          status: WorkshopEditStatus.failure,
          exception: 'يرجى إدخال اسم الورشة',
        ));
        return;
      }

      if (state.phone.isEmpty ||
          !RegExp(r'^[0-9]{10}$').hasMatch(state.phone)) {
        emit(state.copyWith(
          status: WorkshopEditStatus.failure,
          exception: 'رقم الهاتف غير صحيح',
        ));
        return;
      }
      emit(state.copyWith(status: WorkshopEditStatus.saving));

      final updatedWorkshop = state.workshop!.copyWith(
        description: state.description,
        carBrands: state.brands,
        status: _getSelectedPartsStatus(),
        city: state.location?.city,
        street: state.location?.street,
        coordination: state.location?.coordinates.toGeoFirePoint(),
        imagePath: state.imageUrl,
        name: state.name,
        phone: state.phone,
      );

      await _workshopRepository.addWorkshop(updatedWorkshop);
      await _workshopRepository.cacheUser(updatedWorkshop);

      emit(state.copyWith(status: WorkshopEditStatus.saved));
    } catch (e) {
      emit(state.copyWith(
        status: WorkshopEditStatus.failure,
        exception: 'Failed to save changes: ${e.toString()}',
      ));
    }
  }

  List<SparePartsStatus> _getSelectedPartsStatus() {
    return state.partsStatus.entries
        .where((entry) => entry.value)
        .map((e) => e.key)
        .toList();
  }
}
