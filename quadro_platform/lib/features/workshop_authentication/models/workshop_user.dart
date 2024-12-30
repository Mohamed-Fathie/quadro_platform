import 'package:quadro_platform/shared/enum/car_brands.dart';
import 'package:quadro_platform/shared/enum/spare_parts.dart';

class Workshop {
  final String name;
  final String ownerId;
  final String description;
  final String phone;
  final List<SparePartsStatus> status;
  final List<CarBrand> carBrands;
  //final GeoPoint location;

  Workshop({
    required this.name,
    required this.ownerId,
    required this.description,
    required this.phone,
    required this.status,
    required this.carBrands,
    // required this.location,
  });

  // Convert a JSON map into a Workshop instance
  factory Workshop.fromJson(Map<String, dynamic> json) {
    return Workshop(
      name: json['name'] as String,
      ownerId: json['owner_id'] as String,
      description: json['description'] as String,
      phone: json['phone'] as String,
      status: (json['status'] as List<dynamic>)
          .map((e) => SparePartsStatusExtension.fromString(e as String))
          .toList(),
      carBrands: (json['carBrands'] as List<dynamic>)
          .map((e) => CarBrandExtension.fromString(e as String))
          .toList(),
      // location: json['location'] as GeoPoint,
    );
  }

  // Convert a Workshop instance into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'owner_id': ownerId,
      'description': description,
      'phone': phone,
      'status': status.map((e) => e.toJson()).toList(),
      'carBrands': carBrands.map((e) => e.toJson()).toList(),
      // 'location': location,
    };
  }
}
