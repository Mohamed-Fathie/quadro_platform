import 'dart:io';

enum VehicleOwnerStatus { initial, loading, success, error }

class VehicleOwnerState {
  final VehicleOwnerStatus status;
  final File? imageFile;
  final String? imageUrl;
  final String? exception;

  const VehicleOwnerState({
    this.status = VehicleOwnerStatus.initial,
    this.imageFile,
    this.imageUrl,
    this.exception,
  });

  VehicleOwnerState copyWith({
    VehicleOwnerStatus? status,
    File? imageFile,
    String? imageUrl,
    String? exception,
  }) {
    return VehicleOwnerState(
      status: status ?? this.status,
      imageFile: imageFile ?? this.imageFile,
      imageUrl: imageUrl ?? this.imageUrl,
      exception: exception,
    );
  }
}
