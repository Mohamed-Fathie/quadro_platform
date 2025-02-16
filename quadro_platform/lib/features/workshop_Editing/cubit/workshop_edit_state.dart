part of 'workshop_edit_cubit.dart';

enum WorkshopEditStatus { initial, loading, saving, success, failure, saved }

@immutable
final class WorkshopEditState extends Equatable {
  final Workshop? workshop;
  final XFile? imageFile;
  final String? imageUrl;
  final String description;
  final List<CarBrand> brands;
  final Map<SparePartsStatus, bool> partsStatus;
  final SelectedLocation? location;
  final WorkshopEditStatus status;
  final String? exception;
  final String name;
  final String phone;

  const WorkshopEditState({
    this.workshop,
    this.imageFile,
    this.imageUrl,
    this.description = '',
    this.name = '',
    this.phone = '',
    this.brands = const [],
    this.partsStatus = const {
      SparePartsStatus.New: false,
      SparePartsStatus.used: false,
      SparePartsStatus.imported: false,
      SparePartsStatus.none: false,
    },
    this.location,
    this.status = WorkshopEditStatus.initial,
    this.exception,
  });

  WorkshopEditState copyWith({
    Workshop? workshop,
    String? name,
    String? phone,
    XFile? imageFile,
    String? imageUrl,
    String? description,
    List<CarBrand>? brands,
    Map<SparePartsStatus, bool>? partsStatus,
    SelectedLocation? location,
    WorkshopEditStatus? status,
    String? exception,
  }) {
    return WorkshopEditState(
      workshop: workshop ?? this.workshop,
      imageFile: imageFile ?? this.imageFile,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      brands: brands ?? this.brands,
      partsStatus: partsStatus ?? this.partsStatus,
      location: location ?? this.location,
      status: status ?? this.status,
      exception: exception ?? this.exception,
      name: name ?? this.name,
      phone: phone ?? this.phone,
    );
  }

  @override
  List<Object?> get props => [
        workshop,
        imageFile,
        imageUrl,
        description,
        brands,
        partsStatus,
        location,
        status,
        exception,
        name,
        phone,
      ];
}
