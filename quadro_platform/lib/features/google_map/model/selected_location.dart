import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class SelectedLocation {
  final LatLng coordinates;
  final String? street;
  final String? city;

  SelectedLocation({
    required this.coordinates,
    this.street,
    this.city,
  });

  // Convert a Firestore GeoPoint into SelectedLocation
  factory SelectedLocation.fromGeoPoint(Map<String, dynamic> geoPoint) {
    return SelectedLocation(
      coordinates: LatLng(geoPoint['latitude'], geoPoint['longitude']),
      street: geoPoint['street'] as String?,
      city: geoPoint['city'] as String?,
    );
  }

  // Convert SelectedLocation to a Firestore GeoPoint-like map
  Map<String, dynamic> toGeoPoint() {
    return {
      'latitude': coordinates.latitude,
      'longitude': coordinates.longitude,
      'street': street,
      'city': city,
    };
  }
}
