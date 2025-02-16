import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quadro_platform/common/controller/services/location_services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:quadro_platform/constants/constants.dart';
import 'package:quadro_platform/driver/controller/provider/driver_location_provider.dart';

class GeoFireServices {
  static DatabaseReference databaseRef = FirebaseDatabase.instance
      .ref()
      .child('User/${auth.currentUser!.uid}/driverStatus');

  static goOnline() async {
    LatLng currentPosition = await LocationServices.getCurrentLocation();
    Geofire.initialize('OnlineDrivers');
    Geofire.setLocation(
      auth.currentUser!.uid,
      currentPosition.latitude,
      currentPosition.longitude,
    );
    databaseRef.set('Online');
    databaseRef.onValue.listen((event) {});
  }

  static goOffline(BuildContext context) {
    Geofire.removeLocation(auth.currentUser!.uid);
    databaseRef.set('Offline');
    databaseRef.onDisconnect();
  }

  static updateLocationRealTime(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 10,
    );
    StreamSubscription<Position> driverPositionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (event) {
        context.read<DriverLocationProvider>().updateDriverPosition(event);
        Geofire.setLocation(
          auth.currentUser!.uid,
          event.latitude,
          event.longitude,
        );
      },
    );
  }
}
