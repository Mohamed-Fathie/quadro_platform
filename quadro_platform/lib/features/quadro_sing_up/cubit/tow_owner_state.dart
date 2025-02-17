// tow_service_provider_status.dart
import 'dart:io';

enum TowServiceProviderStatus { initial, loading, success, error }

// tow_service_provider_state.dart
class TowServiceProviderState {
  final TowServiceProviderStatus status;
  final File? imageFile;
  final String? imageUrl;
  final String? exception;
  final String selectedVehicleType;

  const TowServiceProviderState({
    this.status = TowServiceProviderStatus.initial,
    this.imageFile,
    this.imageUrl,
    this.exception,
    this.selectedVehicleType = 'اختر نوع مركبتك',
  });

  TowServiceProviderState copyWith({
    TowServiceProviderStatus? status,
    File? imageFile,
    String? exception,
    String? imageUrl,
    String? selectedVehicleType,
  }) {
    return TowServiceProviderState(
      status: status ?? this.status,
      imageFile: imageFile ?? this.imageFile,
      exception: exception,
      imageUrl: imageUrl ?? this.imageUrl,
      selectedVehicleType: selectedVehicleType ?? this.selectedVehicleType,
    );
  }
}
