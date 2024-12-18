// ignore_for_file: avoid_init_to_null

part of 'authbloc_cubit.dart';

enum WorkshopAuthStatus { initial, loading, success, failure }

@immutable
class WorkshopAuthblocState extends Equatable {
  final XFile? imageProfile;

  final String? profilImageUrl;
  final String? idcardUrl;
  final String? licensUrl;
  final double? progress;
  final String? exception;
  final String description;
  final List<CarBrand> brands;
  final Map<SparePartsStatus, bool> partsStatus;
  final WorkshopAuthStatus status;

  const WorkshopAuthblocState({
    this.progress = null,
    this.exception = null,
    this.imageProfile = null,
    this.profilImageUrl = null,
    this.idcardUrl = null,
    this.licensUrl = null,
    this.status = WorkshopAuthStatus.initial,
    this.description = "",
    this.brands = const <CarBrand>[],
    this.partsStatus = const <SparePartsStatus, bool>{
      SparePartsStatus.New: false,
      SparePartsStatus.used: false,
      SparePartsStatus.imported: false,
      SparePartsStatus.none: false
    },
  });

  WorkshopAuthblocState copyWith({
    double? progress,
    XFile? imageProfile,
    String? profilImageUrl,
    String? licensUrl,
    String? idcardUrl,
    String? exception,
    String? description,
    List<CarBrand>? brands,
    Map<SparePartsStatus, bool>? partsStatus,
    WorkshopAuthStatus? status,
  }) {
    return WorkshopAuthblocState(
        progress: progress ?? this.progress,
        imageProfile: imageProfile ?? this.imageProfile,
        idcardUrl: idcardUrl ?? this.idcardUrl,
        licensUrl: licensUrl ?? this.licensUrl,
        profilImageUrl: profilImageUrl ?? this.profilImageUrl,
        exception: exception ?? this.exception,
        description: description ?? this.description,
        brands: brands ?? this.brands,
        partsStatus: partsStatus ?? this.partsStatus,
        status: status ?? this.status);
  }

  @override
  List<Object?> get props => [
        licensUrl,
        idcardUrl,
        profilImageUrl,
        progress,
        imageProfile,
        exception,
        description,
        brands,
        partsStatus,
        status,
      ];

  /// Filters and returns only the `true` keys from `partsStatus`
  List<SparePartsStatus> get truePartsStatus => partsStatus.entries
      .where((entry) => entry.value)
      .map((e) => e.key)
      .toList();

  /// String representation of the state
  @override
  String toString() {
    return 'WorkshopAuthblocState('
        'profilImageUrl: $profilImageUrl, '
        'idcardUrl: $idcardUrl, '
        'licensUrl: $licensUrl, '
        'description: $description, '
        'brands: ${brands.map((brand) => brand.toJson()).join(', ')}, '
        'truePartsStatus: ${truePartsStatus.map((e) => e.toJson()).join(', ')}, '
        ')';
  }
}
