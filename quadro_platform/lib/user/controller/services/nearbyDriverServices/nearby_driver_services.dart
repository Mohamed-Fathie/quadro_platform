import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quadro_platform/user/controller/provider/trip_provider/ride_request_provider.dart';
import 'package:quadro_platform/user/model/nearby_drivers_model.dart';

class NearbyDriverServices {
  static getNearbyDrivers(LatLng pickupLocation, BuildContext context) {
    Geofire.initialize('OnlineDrivers');
    Geofire.queryAtLocation(
      pickupLocation.latitude,
      pickupLocation.longitude,
      20,
    )!
        .listen((event) {
      if (event != null) {
        log('Event is Not Null');
        var callback = event['callback'];
        switch (callback) {
          case Geofire.onKeyEntered:
            NearbyDriversModel model = NearbyDriversModel(
              driverID: event['key'],
              latitude: event['latitude'],
              longitude: event['longitude'],
            );
            context.read<RideRequestProvider>().addDriver(model);
            if (context.read<RideRequestProvider>().fechNearbyDrivers == true) {
              context.read<RideRequestProvider>().updateMarker();
            }
            break;
          case Geofire.onKeyExited:
            context
                .read<RideRequestProvider>()
                .removeDriver(event['key'].toString());
            context.read<RideRequestProvider>().updateMarker();
            log('driver removed ${event['key']}');
            break;

          case Geofire.onKeyMoved:
            NearbyDriversModel model = NearbyDriversModel(
              driverID: event['key'],
              latitude: event['latitude'],
              longitude: event['longitude'],
            );

            context.read<RideRequestProvider>().updateNearbyLocation(model);
            context.read<RideRequestProvider>().updateMarker();

            break;
          case Geofire.onGeoQueryReady:
            log(context
                .read<RideRequestProvider>()
                .nearbyDrivers
                .length
                .toString());
            context.read<RideRequestProvider>().updateMarker();
            break;
        }
      } else {
        log('event is null');
      }
    });
  }
}
