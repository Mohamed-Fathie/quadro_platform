import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quadro_platform/common/controller/services/location_services.dart';
import 'package:quadro_platform/common/modele/direction_model.dart';
import 'package:quadro_platform/common/modele/pickup&drop_location_model.dart';
import 'package:quadro_platform/common/modele/rider_request_modele.dart';
import 'package:quadro_platform/constants/constants.dart';
import 'package:quadro_platform/constants/utils/colors.dart';

class DriverRideRequestProvider extends ChangeNotifier {
  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(32.538048, 13.027049),
    zoom: 14,
  );
  Set<Marker> driverMarker = Set<Marker>();
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
  RiderRequistModel? rideRequestData;
  String? riderrID;
  bool movingFromCurrentLocationToPickupLokation = false;
  LatLng? rideAcceptLocation;

  updateTripPickupAndDropLocation(PickupAndDropLocationModel pickupData,
      PickupAndDropLocationModel dropData) {
    pickupLocation = pickupData;
    dropLocation = dropData;
    notifyListeners();
  }

  updateMovingFromCurrentLocationToPickupLocationStatus(bool newStatus) {
    movingFromCurrentLocationToPickupLokation = newStatus;
    notifyListeners();
  }

  updateUpdateMarkerStatus(bool newStatus) {
    updateMarkerBool = newStatus;
    notifyListeners();
  }

  updateRideAcceptLocation(LatLng location) {
    rideAcceptLocation = location;
    notifyListeners();
  }

  updateDirection(DirectionModel newDirection) {
    directionDetails = newDirection;

    notifyListeners();
  }

  updateRideRequestData(RiderRequistModel data, String riderID) {
    rideRequestData = data;
    riderrID = riderID;
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
    driverMarker.clear();
    Marker pickupMarker = Marker(
      markerId: const MarkerId('PickupMarker'),
      position: movingFromCurrentLocationToPickupLokation
          ? rideAcceptLocation!
          : LatLng(pickupLocation!.latitude!, pickupLocation!.longitude!),
      icon: pickupIconForMap!,
    );
    Marker destinationMarker = Marker(
      markerId: const MarkerId('destinationMarker'),
      position: movingFromCurrentLocationToPickupLokation
          ? LatLng(pickupLocation!.latitude!, pickupLocation!.longitude!)
          : LatLng(dropLocation!.latitude!, dropLocation!.longitude!),
      icon: destinationIconForMap!,
    );

    if (updateMarkerBool == true) {
      LatLng crrLocation = await LocationServices.getCurrentLocation();
      Marker truckMarker = Marker(
        markerId: MarkerId(auth.currentUser!.uid),
        position: LatLng(crrLocation.latitude, crrLocation.longitude),
        icon: truckIconForMap!,
      );
      driverMarker.add(truckMarker);
    }
    driverMarker.add(pickupMarker);
    driverMarker.add(destinationMarker);
    notifyListeners();
    if (updateMarkerBool == true) {
      await Future.delayed(const Duration(seconds: 5), () async {
        await updateMarker();
      });
    }
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
}
