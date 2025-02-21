part of 'maintenacne_request_cubit.dart';

enum MaintenanceRequestCubitStatues {
  initial,
  submitting,
  confirmation,
  success,
  failure
}

@immutable
class MaintenanceRequestState extends Equatable {
  final CarBrand? selectedCarBrand;
  final CarModels? selectedCarModel;
  final String description;
  final File? image;
  final MaintenanceRequestCubitStatues status;
  final String? errorMessage;

  const MaintenanceRequestState({
    this.selectedCarBrand,
    this.selectedCarModel,
    this.description = '',
    this.image,
    this.status = MaintenanceRequestCubitStatues.initial,
    this.errorMessage,
  });

  MaintenanceRequestState copyWith({
    CarBrand? selectedCarBrand,
    CarModels? selectedCarModel,
    String? description,
    File? image,
    MaintenanceRequestCubitStatues? status,
    String? errorMessage,
  }) {
    return MaintenanceRequestState(
      selectedCarBrand: selectedCarBrand ?? this.selectedCarBrand,
      selectedCarModel: selectedCarModel ?? this.selectedCarModel,
      description: description ?? this.description,
      image: image ?? this.image,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        selectedCarBrand,
        status,
        errorMessage,
        image,
        description,
        selectedCarModel
      ];
}
