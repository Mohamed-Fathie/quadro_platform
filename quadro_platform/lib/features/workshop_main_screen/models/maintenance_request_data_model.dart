import 'package:equatable/equatable.dart';
import 'package:quadro_platform/features/user/model/user.dart';
import 'package:quadro_platform/features/workshop_authentication/models/workshop_user.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/models/offers.dart';
import 'package:quadro_platform/shared/enum/car_brands.dart';
import 'package:quadro_platform/shared/enum/car_models.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';

class MaintenanceRequestDomainModel extends Equatable {
  final String id;
  final User user;
  final Workshop workshop;
  final CarBrand carCompany;
  final CarModels carModel;
  final String description;
  final String? carImageUrl;
  final MaitenanceRequestStatus requestStatus;
  final DateTime dateCreated;
  final Offer? offer;

  const MaintenanceRequestDomainModel({
    required this.id,
    required this.user,
    required this.workshop,
    required this.carCompany,
    required this.carModel,
    required this.description,
    this.carImageUrl,
    required this.requestStatus,
    required this.dateCreated,
    this.offer,
  });

  // CopyWith Method
  MaintenanceRequestDomainModel copyWith({
    String? id,
    User? user,
    Workshop? workshop,
    CarBrand? carCompany,
    CarModels? carModel,
    String? description,
    String? carImageUrl,
    MaitenanceRequestStatus? requestStatus,
    DateTime? dateCreated,
    Offer? offer,
  }) {
    return MaintenanceRequestDomainModel(
      id: id ?? this.id,
      user: user ?? this.user,
      workshop: workshop ?? this.workshop,
      carCompany: carCompany ?? this.carCompany,
      carModel: carModel ?? this.carModel,
      description: description ?? this.description,
      carImageUrl: carImageUrl ?? this.carImageUrl,
      requestStatus: requestStatus ?? this.requestStatus,
      dateCreated: dateCreated ?? this.dateCreated,
      offer: offer ?? this.offer,
    );
  }

  // toString Method
  @override
  String toString() {
    return 'MaintenanceRequestDomainModel('
        'id: $id, '
        'user: ${user.toString()}, '
        'workshop: ${workshop.toString()}, '
        'carCompany: $carCompany, '
        'carModel: $carModel, '
        'description: $description, '
        'carImageUrl: $carImageUrl, '
        'requestStatus: $requestStatus, '
        'dateCreated: $dateCreated, '
        'offer: ${offer?.toString()})';
  }

  @override
  List<Object?> get props => [
        id,
        user,
        workshop,
        carCompany,
        carModel,
        description,
        carImageUrl,
        requestStatus,
        dateCreated,
        offer,
      ];
}
