import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class DriverLocationProvider extends ChangeNotifier {
  Position? position;

  updateDriverPosition(Position newPosition) {
    position = newPosition;
    notifyListeners();
  }
}
