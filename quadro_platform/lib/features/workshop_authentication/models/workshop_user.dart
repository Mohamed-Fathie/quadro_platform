import 'package:cloud_firestore/cloud_firestore.dart' show GeoPoint;
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:quadro_platform/shared/enum/car_brands.dart';
import 'package:quadro_platform/shared/enum/spare_parts.dart';
import 'package:quadro_platform/shared/utils/extension/coordination_togeopoint.dart';

class Workshop {
  final String name;
  final String imagePath;
  final String ownerId;
  final String description;
  final String phone;
  final String? street;
  final String? city;
  final List<SparePartsStatus> status;
  final List<CarBrand> carBrands;
  final LatLng? coordination;

  Workshop({
    required this.street,
    required this.imagePath,
    required this.city,
    required this.name,
    required this.ownerId,
    required this.description,
    required this.phone,
    required this.status,
    required this.carBrands,
    required this.coordination,
  });

  // Convert a JSON map into a Workshop instance
  factory Workshop.fromJson(Map<String, dynamic> json) {
    final dynamic coordinationData = json['coordination'];

    return Workshop(
      name: json['name'] as String,
      imagePath: json['imagePath'] as String,
      ownerId: json['owner_id'] as String,
      description: json['description'] as String,
      phone: json['phone'] as String,
      status: (json['status'] as List<dynamic>?)
              ?.map((e) => SparePartsStatusExtension.fromString(
                  e.toString().split('.').last))
              .toList() ??
          [],
      carBrands: (json['carBrands'] as List<dynamic>?)
              ?.map((e) =>
                  CarBrandExtension.fromString(e.toString().split('.').last))
              .toList() ??
          [],
      coordination: (coordinationData is GeoPoint)
          ? coordinationData.toLatLng() // Use the extension method
          : LatLng(
              (coordinationData['latitude'] as num).toDouble(),
              (coordinationData['longitude'] as num).toDouble(),
            ),
      street: json['street'] as String?,
      city: json['city'] as String?,
    );
  }

  // Convert a Workshop instance into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'imagePath': imagePath,
      'name': name,
      'owner_id': ownerId,
      'description': description,
      'phone': phone,
      'status': status.map((e) => e.toJson()).toList(),
      'carBrands': carBrands.map((e) => e.toString()).toList(),
      'coordination': coordination?.toGeoPoint(),
      'street': street,
      'city': city,
    };
  }

  // Convert a Workshop instance into a JSON map
  Map<String, dynamic> toJsonMap() {
    return {
      'name': name,
      'imagePath': imagePath,
      'owner_id': ownerId,
      'description': description,
      'phone': phone,
      'status': status.map((e) => e.toJson()).toList(),
      'carBrands': carBrands.map((e) => e.toString()).toList(),
      'coordination': {
        'latitude': coordination?.latitude,
        'longitude': coordination?.longitude,
      },
      'street': street,
      'city': city,
    };
  }
}
