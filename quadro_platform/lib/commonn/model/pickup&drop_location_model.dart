import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PickupAndDropLocationModel {
  final String? name;
  final String? description;
  final String? placeID;
  final double? latitude;
  final double? longitude;

  PickupAndDropLocationModel({
    required this.name,
    this.description,
    required this.placeID,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'placeID': placeID,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory PickupAndDropLocationModel.fromMap(Map<String, dynamic> map) {
    return PickupAndDropLocationModel(
      name: map['name'] != null ? map['name'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      placeID: map['placeID'] != null ? map['placeID'] as String : null,
      latitude: map['latitude'] != null ? map['latitude'] as double : null,
      longitude: map['longitude'] != null ? map['longitude'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PickupAndDropLocationModel.fromJson(String source) =>
      PickupAndDropLocationModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
