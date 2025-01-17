import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quadro_platform/common/model/direction_model.dart';
import 'package:quadro_platform/common/model/pickup&drop_location_model.dart';
import 'package:quadro_platform/constants/constants.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:quadro_platform/user/model/nearby_drivers_model.dart';

class RideRequestProvider extends ChangeNotifier {
  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(32.538048, 13.027049),
    zoom: 14,
  );
  Set<Marker> riderMarker = Set<Marker>();
  Set<Polyline> polylineSet = {};
  Polyline? polyline;
  List<LatLng> polylineCoordinatesList = [];
  DirectionModel? directionDetails;
  BitmapDescriptor? truckIconForMap;
  BitmapDescriptor? destinationIconForMap;
  BitmapDescriptor? pickupIconForMap;
  bool updateMarkerBool = false;
  PickupAndDropLocationModel? dropLocation;
  PickupAndDropLocationModel? pickupLocation;
  int quadroHookFare = 0;
  int quadroWheelLeftFare = 0;
  int quadroIntegratedTowFare = 0;

//nearby drivers list
  bool fechNearbyDrivers = false;
  List<NearbyDriversModel> nearbyDrivers = [];

  makeFareZero() {
    quadroHookFare = 0;
    quadroWheelLeftFare = 0;
    quadroIntegratedTowFare = 0;
    notifyListeners();
  }

  getFare() {
    int baseFare = 50;
    int quadroGoHookDistancePerKM = 1;
    int quadroWheelLeftDistancePerKM = 2;
    int quadroIntegratedTowDistancePerKM = 3;
    int quadroGoHookDurationPerMinute = 2;
    double quadroWheelLeftDurationPerMinute = 2.5;
    int quadroIntegratedTowDurationPerMinute = 3;

    quadroHookFare = (baseFare +
            quadroGoHookDistancePerKM *
                double.parse(
                    (directionDetails!.distanceInMeter / 1000).toString()) +
            (quadroGoHookDurationPerMinute * (directionDetails!.duration / 60)))
        .round();
    quadroWheelLeftFare = (baseFare +
            quadroWheelLeftDistancePerKM *
                double.parse(
                    (directionDetails!.distanceInMeter / 1000).toString()) +
            (quadroWheelLeftDurationPerMinute *
                (directionDetails!.duration / 60)))
        .round();
    quadroIntegratedTowFare = (baseFare +
            quadroIntegratedTowDistancePerKM *
                double.parse(
                    (directionDetails!.distanceInMeter / 1000).toString()) +
            (quadroIntegratedTowDurationPerMinute *
                (directionDetails!.duration / 60)))
        .round();
    notifyListeners();
  }

  updateRidePickupAndDropLocation(
    PickupAndDropLocationModel pickup,
    PickupAndDropLocationModel drop,
  ) {
    pickupLocation = pickup;
    dropLocation = drop;
    notifyListeners();
    log('PICKUP AND DROP LOCATION IS');
    log(pickupLocation!.toMap().toString());
    log(dropLocation!.toMap().toString());
  }

  updateDirection(DirectionModel newDirection) {
    directionDetails = newDirection;

    notifyListeners();
  }

  decodePolylineAndUpdatePolylineField() {
    if (directionDetails == null || directionDetails!.polylinePoints.isEmpty) {
      log('No direction details or polyline points found.');
      return;
    }

    PolylinePoints polylinePoints = PolylinePoints();
    polylineCoordinatesList.clear();
    polylineSet.clear();
    log('Encoded polyline: ${directionDetails!.polylinePoints}');

    List<PointLatLng> data =
        polylinePoints.decodePolyline(directionDetails!.polylinePoints);
    if (data.isNotEmpty) {
      for (var latlngPoints in data) {
        polylineCoordinatesList.add(
          LatLng(
            latlngPoints.latitude,
            latlngPoints.longitude,
          ),
        );
      }
      log('Polyline coordinates: ${polylineCoordinatesList.toString()}');
    } else {
      log('empty');
    }
    polyline = Polyline(
      polylineId: const PolylineId('TripPolyline'),
      color: teal,
      points: polylineCoordinatesList,
      jointType: JointType.round,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
    );

    polylineSet.add(polyline!);
    log('PolylineSet: ${polylineSet.toString()}');
    notifyListeners();
  }

  createIcons(BuildContext context) {
    if (pickupIconForMap == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(1, 1));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/images/icons/pickupPngSmall.png')
          .then(
        (icon) {
          pickupIconForMap = icon;
          notifyListeners();
        },
      );
    }
    if (destinationIconForMap == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(1, 1));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/images/icons/dropPngSmall.png')
          .then(
        (icon) {
          destinationIconForMap = icon;
          notifyListeners();
        },
      );
    }
    if (truckIconForMap == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(1, 1));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/images/icons/truckPng.png')
          .then(
        (icon) {
          truckIconForMap = icon;
          notifyListeners();
        },
      );
    }
  }

  updateMarker() async {
    riderMarker.clear();
    Marker pickupMarker = Marker(
      markerId: const MarkerId('PickupMarker'),
      position: LatLng(pickupLocation!.latitude!, pickupLocation!.longitude!),
      icon: pickupIconForMap!,
    );
    Marker destinationMarker = Marker(
      markerId: const MarkerId('destinationMarker'),
      position: LatLng(dropLocation!.latitude!, dropLocation!.longitude!),
      icon: destinationIconForMap!,
    );
    if (fechNearbyDrivers == true) {
      math.Random random = math.Random();
      for (var driver in nearbyDrivers) {
        double rotation = random.nextInt(360).toDouble();
        Marker truckMarker = Marker(
          markerId: MarkerId(driver.driverID),
          rotation: rotation,
          position:
              LatLng(pickupLocation!.latitude!, pickupLocation!.longitude!),
          icon: truckIconForMap!,
        );
        riderMarker.add(truckMarker);
      }
    }
    if (updateMarkerBool == true) {
      Marker truckMarker = Marker(
        markerId: MarkerId(auth.currentUser!.uid),
        position: LatLng(pickupLocation!.latitude!, pickupLocation!.longitude!),
        icon: truckIconForMap!,
      );
      riderMarker.add(truckMarker);
    }
    riderMarker.add(pickupMarker);
    riderMarker.add(destinationMarker);
    notifyListeners();
    if (updateMarkerBool == true) {
      await Future.delayed(const Duration(seconds: 5), () async {
        await updateMarker();
      });
    }
  }

// nearby drivers functions

  addDriver(NearbyDriversModel driver) {
    nearbyDrivers.add(driver);
    notifyListeners();
  }

  removeDriver(String driverID) {
    int index =
        nearbyDrivers.indexWhere((element) => element.driverID == driverID);
    nearbyDrivers.remove(index);
    notifyListeners();
  }

  updateNearbyLocation(NearbyDriversModel driver) {
    int index = nearbyDrivers
        .indexWhere((element) => element.driverID == driver.driverID);
    nearbyDrivers[index].longitude = driver.longitude;
    nearbyDrivers[index].latitude = driver.latitude;

    notifyListeners();
  }

  updateFetchedNearbyDrivers(bool newStatus) {
    fechNearbyDrivers = newStatus;
    notifyListeners();
  }

  updateupdateMarkerBool(bool newStatus) {
    updateMarkerBool = newStatus;
    notifyListeners();
  }
}
