import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

extension LatLngExtensions on LatLng {
  GeoPoint toGeoPoint() {
    return GeoPoint(latitude, longitude);
  }
}

extension GeoPointExtension on GeoPoint {
  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }
}
