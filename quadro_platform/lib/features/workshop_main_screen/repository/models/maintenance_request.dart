import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:quadro_platform/shared/enum/car_brands.dart';
import 'package:quadro_platform/shared/enum/car_models.dart';

import '../../../../shared/enum/maitenance_request_status.dart'; // Fixed typo in filename

class MaintenanceRequest {
  // Identifiers
  final String? id;
  final String? offerId;

  // Entity references
  final String vehicleOwnerId;
  final String workshopId;

  // Vehicle information
  final CarBrand carCompany;
  final CarModels carModel;

  // Request details
  final String description;
  final MaitenanceRequestStatus status; // Fixed enum name
  final Timestamp dateCreated;

  // Media & attachments
  final String? requestImageUrl; // Fixed typo in property name

  MaintenanceRequest({
    // Identifiers
    this.id,
    this.offerId,

    // Required references
    required this.vehicleOwnerId,
    required this.workshopId,

    // Required vehicle info
    required this.carCompany,
    required this.carModel,

    // Required request details
    required this.description,
    required this.status,
    required this.dateCreated,

    // Optional media
    this.requestImageUrl,
  });

  factory MaintenanceRequest.fromJson(String id, Map<String, dynamic> json) {
    return MaintenanceRequest(
      id: id,
      vehicleOwnerId: json['vehicle_owner_id'] as String,
      workshopId: json['workshop_id'] as String,
      carCompany: CarBrand.values.byName(json['car_company']),
      carModel: CarModels.values.byName(json['car_model']),
      description: json['description'] as String,
      requestImageUrl: json['image_url'] as String?,
      status: MaitenanceRequestStatus.values.byName(json['status']),
      dateCreated: json['date_created'] as Timestamp,
      offerId: json['offer_id'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // Identifiers
      'vehicle_owner_id': vehicleOwnerId,
      'workshop_id': workshopId,

      // Vehicle info
      'car_company': carCompany.name,
      'car_model': carModel.name,

      // Request details
      'description': description,
      'status': status.name,
      'date_created': dateCreated,

      // Optional references
      'image_url': requestImageUrl,
      'offer_id': offerId,

      // Add if storing locally
      // 'image_path': imagePath, // Only include if needed in Firestore
    };
  }
}
