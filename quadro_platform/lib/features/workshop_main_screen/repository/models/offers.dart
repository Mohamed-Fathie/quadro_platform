import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quadro_platform/shared/enum/offer_status.dart';
import 'package:quadro_platform/shared/enum/spare_parts.dart';

class Offer {
  final String id; // Auto-generated Document ID
  final String workshopId; // Reference to Workshops/{UID}
  final String requestId; // Reference to MaintenanceRequests/{UID}
  final double servicePrice; // Service price as a number
  final int guaranteePeriod; // Guarantee period as a string
  final SparePartsStatus sparePartsStatus; // Enum for spare parts status
  final OfferStatus status; // Enum for offer status
  final Timestamp dateCreated; // Timestamp for creation

  Offer({
    required this.id,
    required this.workshopId,
    required this.requestId,
    required this.servicePrice,
    required this.guaranteePeriod,
    required this.sparePartsStatus,
    required this.status,
    required this.dateCreated,
  });

  // Factory to create an instance from JSON
  factory Offer.fromJson(String id, Map<String, dynamic> json) {
    return Offer(
      id: id,
      workshopId: json['workshop_id'] as String,
      requestId: json['request_id'] as String,
      servicePrice: (json['service_price'] as num).toDouble(),
      guaranteePeriod: json['guarantee_period'] as int,
      sparePartsStatus: SparePartsStatus.values
          .byName(json['spare_parts_status']), // Parse enum by name
      status: OfferStatus.values.byName(json['status']), // Parse enum by name
      dateCreated: json['date_created'] as Timestamp,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'workshop_id': workshopId,
      'request_id': requestId,
      'service_price': servicePrice,
      'guarantee_period': guaranteePeriod,
      'spare_parts_status': sparePartsStatus.name, // Convert enum to string
      'status': status.name, // Convert enum to string
      'date_created': dateCreated,
    };
  }
}
