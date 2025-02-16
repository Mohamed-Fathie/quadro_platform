import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quadro_platform/common/controller/services/firebasePushNotificationServices/push_notification_dialouge.dart';
import 'package:quadro_platform/common/controller/services/firebasePushNotificationServices/push_notification_services.dart';
import 'package:quadro_platform/common/controller/services/location_services.dart';
import 'package:quadro_platform/common/controller/services/profile_data_crud_service.dart';
import 'package:quadro_platform/common/model/direction_model.dart';
import 'package:quadro_platform/common/model/pickup&drop_location_model.dart';
import 'package:quadro_platform/common/model/rider_request_modele.dart';

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
  bool fechNearbyDrivers = false;
  List<NearbyDriversModel> nearbyDrivers = [];
  bool placeRideRequest = false;

  updatePlaceRideRequestStatus(bool newStatus) {
    placeRideRequest = newStatus;
    notifyListeners();
  }

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
    riderMarker = Set<Marker>();
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
        // double rotation = random.nextInt(360).toDouble();
        Marker truckMarker = Marker(
          markerId: MarkerId(driver.driverID),
          // rotation: rotation,
          position: LatLng(driver.latitude, driver.longitude),
          icon: truckIconForMap!,
        );
        riderMarker.add(truckMarker);
      }
    }
    if (updateMarkerBool == true) {
      LatLng currentLocation = await LocationServices.getCurrentLocation();
      Marker truckMarker = Marker(
        markerId: MarkerId(auth.currentUser!.uid),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
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

// sendPushNotificationToNearbyDrivers() async {
//   log(nearbyDrivers.length.toString()); // طباعة العدد مرة واحدة

//  List<String> tokens = [];
// for (var driver in List.of(nearbyDrivers)) {
//   try {
//     ProfileDataModel driverProfileData =
//         await ProfileDataCRUDServices.getProfileDataFromRealTimeDatabase(
//             driver.driverID);
//     if (driverProfileData.cloudMessagingToken != null) {
//       log(driverProfileData.cloudMessagingToken.toString());
//       tokens.add(driverProfileData.cloudMessagingToken!);
//     } else {
//       log('Token is null for driver: ${driver.driverID}');
//     }
//   } catch (e) {
//     log('Error processing driver ${driver.driverID}: $e');
//   }
// }

//   if (tokens.isNotEmpty) {
//     await PushNotivicationServices.sendRideRequestToNearbyDrivers(tokens);
//   }
// }

// sendPushNotificationToNearbyDrivers() async {
//   log(nearbyDrivers.length.toString()); // طباعة العدد مرة واحدة

//   Set<String> tokens = {}; // استخدام Set لمنع التكرار

//   await Future.wait(
//     nearbyDrivers.map((driver) async {
//       try {
//         ProfileDataModel driverProfileData =
//             await ProfileDataCRUDServices.getProfileDataFromRealTimeDatabase(
//                 driver.driverID);
//         if (driverProfileData.cloudMessagingToken != null) {
//           log(driverProfileData.cloudMessagingToken!);
//           tokens.add(driverProfileData.cloudMessagingToken!); // إضافة التوكن إلى Set
//         } else {
//           log('Token is null for driver: ${driver.driverID}');
//         }
//       } catch (e) {
//         log('Error processing driver ${driver.driverID}: $e');
//       }
//     }),
//   );

//   // إرسال الإشعارات بعد جمع جميع التوكنات الفريدة
//   for (String token in tokens) {
//     await PushNotivicationServices.sendRideRequestToNearbyDrivers(token);
//   }
// }
  void listenForNewRequests(BuildContext context) {
    DatabaseReference rideRequestRef =
        FirebaseDatabase.instance.ref().child('RideRequest');

    DatabaseReference onlineDriversRef =
        FirebaseDatabase.instance.ref().child('OnlineDrivers');

    rideRequestRef.onChildAdded.listen((event) async {
      if (event.snapshot.value != null) {
        String rideID = event.snapshot.key!;
        log('طلب جديد rideID : $rideID');

        String currentUid = auth.currentUser!.uid;

        // تحقق مما إذا كان UID السائق موجودًا في onlineDrivers
        DatabaseEvent driverSnapshot =
            await onlineDriversRef.child(currentUid).once();

        if (driverSnapshot.snapshot.exists) {
          RiderRequistModel rideRequestModel = RiderRequistModel.fromMap(
            jsonDecode(jsonEncode(event.snapshot.value))
                as Map<String, dynamic>,
          );

          PushNotificationDialouge.RideRequestDilouge(
              rideID, rideRequestModel, context);
        } else {
          log('السائق غير متصل، لن يتم إرسال الطلب.');
        }
      }
    });
  }

  sendPushNotificationToNearbyDrivers() async {
    log(nearbyDrivers.length.toString()); // طباعة العدد مرة واحدة

    await Future.wait(
      nearbyDrivers.map((driver) async {
        try {
          String deviceToken = await ProfileDataCRUDServices
              .getMessagingTokenFromRealTimeDatabase(driver.driverID);
          if (deviceToken != null) {
            log(deviceToken);
            await PushNotivicationServices.sendRideRequestToNearbyDrivers(
                deviceToken);
          } else {
            log('Token is null for driver: ${driver.driverID}');
          }
        } catch (e) {
          log('Error processing driver ${driver.driverID}: $e');
        }
      }),
    );
  }

  // sendPushNotificationToNearbyDrivers() async {
  //   for (var driver in nearbyDrivers) {
  //     ProfileDataModel driverProfileData =
  //         await ProfileDataCRUDServices.getProfileDataFromRealTimeDatabase(
  //             driver.driverID);
  //     log(driverProfileData.cloudMessagingToken!);
  //     await PushNotivicationServices.sendRideRequestToNearbyDrivers(
  //         driverProfileData.cloudMessagingToken!);
  //   }
  // }

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
