import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:quadro_platform/features/workshop_authentication/repository/storage_repository.dart';
import 'package:quadro_platform/features/workshop_authentication/repository/workshop_repo.dart';
import 'package:quadro_platform/shared/enum/car_brands.dart';
import 'package:quadro_platform/shared/enum/image_type.dart';
import 'package:quadro_platform/shared/enum/spare_parts.dart';

part 'authbloc_state.dart';

class WorkshopAuthbloc extends Cubit<WorkshopAuthblocState> {
  WorkshopAuthbloc(this._workshopRepository, this._storageRepository)
      : super(const WorkshopAuthblocState());
  final WorkshopRepository? _workshopRepository;
  final StorageRepository _storageRepository;
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
    required String userId,
    required XFile? file,
  }) async {
    if (file == null) return;

    try {
      emit(state.copyWith(
        status: WorkshopAuthStatus.loading,
        progress: 0.0,
      ));

      // Generate the dynamic path using userId
      final path = imageType.pathWithId(userId);

      // Upload the image to the determined path
      final url = await _storageRepository.uploadImageWithProgress(
        path: path,
        xFile: file,
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

  void save() {
    print(state.toString());
  }
  // Save data to repository
  // Future<void> saveData() async {
  //   final currentUser = getCurrentUser;

  //   try {
  //     await _workshopRepository.addWorkshop(
  //       Workshop(
  //         name: currentUser.name,
  //         ownerId: currentUser.uid,
  //         description: state.description,
  //         phone: currentUser.phone,
  //         status: state.partsStatus,
  //         carBrands: state.brands,
  //         // location: location,
  //       ),
  //     );
  //     emit(state.copyWith(status: WorkshopAuthStatus.success));
  //   } catch (e) {
  //     emit(state.copyWith(
  //         exception: e as Exception, status: WorkshopAuthStatus.failure));
  //   }
  // }
}
