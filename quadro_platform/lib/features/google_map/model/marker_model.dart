import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerModel {
  final LatLng location; // The geographical coordinates
  final String name; // Name or label for the marker
  final String description; // Description or details
  final String? id;

  MarkerModel(
      {required this.location,
      required this.name,
      required this.description,
      required this.id});
}

extension MarkerExtension on Marker {
  MarkerModel toMarkerModel() {
    return MarkerModel(
      location: position,
      name: infoWindow.title ?? '',
      description: infoWindow.snippet ?? '',
      id: markerId.value,
    );
  }
}
