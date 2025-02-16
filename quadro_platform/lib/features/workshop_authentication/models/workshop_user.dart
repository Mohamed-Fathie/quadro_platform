import 'package:cloud_firestore/cloud_firestore.dart' show GeoPoint;
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart' show GeoFirePoint;
import 'package:quadro_platform/shared/enum/car_brands.dart';
import 'package:quadro_platform/shared/enum/spare_parts.dart';

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
  final GeoFirePoint? coordination;

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
  factory Workshop.fromfirestor(Map<String, dynamic> json) {
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
      coordination: json['coordination'] != null
          ? GeoFirePoint(json['coordination']["geopoint"])
          : null,
      street: json['street'] as String?,
      city: json['city'] as String?,
    );
  }
// Add copyWith method
  Workshop copyWith({
    String? name,
    String? imagePath,
    String? ownerId,
    String? description,
    String? phone,
    String? street,
    String? city,
    List<SparePartsStatus>? status,
    List<CarBrand>? carBrands,
    GeoFirePoint? coordination,
  }) {
    return Workshop(
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      ownerId: ownerId ?? this.ownerId,
      description: description ?? this.description,
      phone: phone ?? this.phone,
      street: street ?? this.street,
      city: city ?? this.city,
      status: status ?? this.status,
      carBrands: carBrands ?? this.carBrands,
      coordination: coordination ?? this.coordination,
    );
  }

  // Convert a JSON map into a Workshop instance
  factory Workshop.fromJson(Map<String, dynamic> json) {
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
      coordination: json['coordination'] != null
          ? GeoFirePoint(
              GeoPoint(
                json['coordination']['latitude'],
                json['coordination']['longitude'],
              ),
            )
          : null,
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
      'coordination': coordination!.data,
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
