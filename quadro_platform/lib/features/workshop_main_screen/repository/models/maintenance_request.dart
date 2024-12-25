import 'package:quadro_platform/shared/enum/car_brands.dart';
import 'package:quadro_platform/shared/enum/car_models.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class MaintenanceRequest {
  final String id; // Document ID
  final String vehicleOwnerId; // Reference to Users/{UID}
  final String workshopId; // Reference to Workshops/{UID}, nullable
  final CarBrand carCompany; // Car company name
  final CarModels carModel; // Car model name
  final String description; // Description of the issue
  final String? requesImageUrl; // Firestore Storage URL
  final MaitenanceRequestStatus status; // pending, under_maintenance, completed
  final Timestamp dateCreated; // Timestamp of creation
  final String? offerId; // Reference to Offers/{UID}, nullable

  MaintenanceRequest({
    required this.id,
    required this.vehicleOwnerId,
    required this.workshopId,
    required this.carCompany,
    required this.carModel,
    required this.description,
    this.requesImageUrl,
    required this.status,
    required this.dateCreated,
    this.offerId,
  });

  // Factory method to create an instance from a Firestore document snapshot
  factory MaintenanceRequest.fromJson(String id, Map<String, dynamic> json) {
    return MaintenanceRequest(
      id: id,
      vehicleOwnerId: json['vehicle_owner_id'] as String,
      workshopId: json['workshop_id'] as String,
      carCompany: CarBrand.values.byName(json['car_company']),
      carModel: CarModels.values.byName(json['car_model']),
      description: json['description'] as String,
      requesImageUrl: json['image_url'] as String?,
      status:
          MaitenanceRequestStatus.values.byName(json['status']), // Enum parsing
      dateCreated: json['date_created'] as Timestamp,
      offerId: json['offer_id'] as String?,
    );
  }

  // Method to convert an instance into a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'vehicle_owner_id': vehicleOwnerId,
      'workshop_id': workshopId,
      'car_company': carCompany,
      'car_model': carModel,
      'description': description,
      'image_url': requesImageUrl,
      'status': status.name,
      'date_created': dateCreated,
      'offer_id': offerId,
    };
  }
}
