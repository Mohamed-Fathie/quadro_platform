import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverMapsProvider extends ChangeNotifier {
   CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(32.538048, 13.027049),
    zoom: 14.4746,
  );
  final Completer<GoogleMapController> driverMapController = Completer();
  LatLng? currentLocation;

  updateCurrentLocation(LatLng newLocation) {
    currentLocation = newLocation;
    notifyListeners();
  }
}
