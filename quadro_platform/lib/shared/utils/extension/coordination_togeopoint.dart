import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart' show GeoFirePoint;
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

extension LatLngExtensions on LatLng {
  GeoPoint toGeoPoint() {
    return GeoPoint(latitude, longitude);
  }

  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }

  GeoFirePoint toGeoFirePoint() {
    return GeoFirePoint(GeoPoint(latitude, longitude));
  }
}

extension GeoPointExtension on GeoPoint {
  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }
}
