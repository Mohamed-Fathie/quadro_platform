import 'package:equatable/equatable.dart';
import 'package:quadro_platform/features/workshop_authentication/models/workshop_user.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/models/maintenance_request.dart';
import 'package:quadro_platform/shared/enum/offer_status.dart';
import 'package:quadro_platform/shared/enum/spare_parts.dart';

class OffersDomainModel extends Equatable {
  final Workshop workshop;
  final MaintenanceRequest request;
  final double servicePrice;
  final int guaranteePeriod;
  final SparePartsStatus partsStatus;
  final OfferStatus offerStatus;
  final DateTime dateCreated;

  const OffersDomainModel({
    required this.workshop,
    required this.request,
    required this.servicePrice,
    required this.guaranteePeriod,
    required this.partsStatus,
    required this.offerStatus,
    required this.dateCreated,
  });

  // CopyWith Method
  OffersDomainModel copyWith({
    Workshop? workshop,
    MaintenanceRequest? request,
    double? servicePrice,
    int? guaranteePeriod,
    SparePartsStatus? partsStatus,
    OfferStatus? offerStatus,
    DateTime? dateCreated,
  }) {
    return OffersDomainModel(
      workshop: workshop ?? this.workshop,
      request: request ?? this.request,
      servicePrice: servicePrice ?? this.servicePrice,
      guaranteePeriod: guaranteePeriod ?? this.guaranteePeriod,
      partsStatus: partsStatus ?? this.partsStatus,
      offerStatus: offerStatus ?? this.offerStatus,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  // toString Method
  @override
  String toString() {
    return 'OffersDomainModel('
        'workshop: ${workshop.toString()}, '
        'request: ${request.toString()}, '
        'servicePrice: $servicePrice, '
        'guaranteePeriod: $guaranteePeriod, '
        'partsStatus: $partsStatus, '
        'offerStatus: $offerStatus, '
        'dateCreated: $dateCreated)';
  }

  // Equatable Props
  @override
  List<Object?> get props => [
        workshop,
        request,
        servicePrice,
        guaranteePeriod,
        partsStatus,
        offerStatus,
        dateCreated,
      ];
}
