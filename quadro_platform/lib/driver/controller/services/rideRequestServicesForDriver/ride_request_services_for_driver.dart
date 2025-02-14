import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadro_platform/common/controller/provider/profile_data_provider.dart';
import 'package:quadro_platform/common/controller/services/auth_services.dart';
import 'package:quadro_platform/common/controller/services/profile_data_crud_service.dart';
import 'package:quadro_platform/common/controller/services/toast_services.dart';
import 'package:quadro_platform/common/model/profile_data_model.dart';
import 'package:quadro_platform/common/model/rider_request_modele.dart';
import 'package:quadro_platform/constants/constants.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:quadro_platform/driver/controller/provider/driver_ride_request_provider.dart';
import 'package:uuid/uuid.dart';

class RideRequestServicesForDriver {
  static checkRideAvailability(BuildContext context, String rideID) async {
    DatabaseReference? tripRef =
        FirebaseDatabase.instance.ref().child('RideRequest/$rideID');
    final snapshot = await tripRef.get();
    if (snapshot.exists) {
      log('snapshot is: ${snapshot.toString()}');
      Stream<DatabaseEvent> stream = tripRef.onValue;
      stream.listen((event) async {
        final checkSnapshotExist = await tripRef.get();
        if (checkSnapshotExist.exists) {
          RiderRequistModel riderRequistModel = RiderRequistModel.fromMap(
              jsonDecode(jsonEncode(snapshot.value)) as Map<String, dynamic>);
          if (riderRequistModel.driverProfile != null) {
            audioPlayer.stop();
            if (context.mounted) {
              Navigator.pop(context);
              ToastService.sendScaffoldAlert(
                  msg: 'المعذرة ، تم قبول الطلب من قبل سائق اخر',
                  toastStatus: 'ERROR',
                  context: context);
            }
          }
        } else {
          audioPlayer.stop();
          if (context.mounted) {
            Navigator.pop(context);
            ToastService.sendScaffoldAlert(
                msg: 'المعذرة ، تم رفض الطلب من قبل المستخدم',
                toastStatus: 'ERROR',
                context: context);
          }
        }
      });
    } else {
      if (context.mounted) {
        ToastService.sendScaffoldAlert(
            msg: 'المعذرة ، تم رفض الطلب حاول بعد قليل',
            toastStatus: 'ERROR',
            context: context);
        Navigator.pop(context);
      }
    }
  }

  static getRideRequestData(String rideID) async {
    DatabaseReference? tripRef =
        FirebaseDatabase.instance.ref().child('RideRequest/$rideID');
    final snapshot = await tripRef.get();
    if (snapshot.exists) {
      RiderRequistModel riderRequistModel = RiderRequistModel.fromMap(
          jsonDecode(jsonEncode(snapshot.value)) as Map<String, dynamic>);
      return riderRequistModel;
    }
  }

  static updateRideRequestStatus(String rideRequestStatus, String rideID) {
    DatabaseReference tripRef =
        FirebaseDatabase.instance.ref().child('RideRequest/$rideID/rideStatus');
    tripRef.set(rideRequestStatus);
  }

  static getRideStatus(int rideStatusNum) {
    switch (rideStatusNum) {
      case 0:
        return 'WAITING_FOR_RIDE_REQUEST';
      case 1:
        return 'WAITINI_FOR_DRIVER_TO_ARRIVE';
      case 2:
        return 'MOVING_TOWARDS_DESTINATION';
      case 3:
        return 'RIDE_COMPLETED';
    }
  }

  static updateRideRequestID(String rideID) {
    DatabaseReference tripRef = FirebaseDatabase.instance
        .ref()
        .child('User/${auth.currentUser!.uid}/activeRideRequestID');
    tripRef.set(rideID);
  }

  static acceptRideRequest(String rideID, BuildContext context) async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child('RideRequest/$rideID/driverProfile');
    ProfileDataModel profileData =
        context.read<ProfileDataProvider>().profileData!;
    ref.set(profileData.toMap()).then((value) {
      if (context.mounted) {
        ToastService.sendScaffoldAlert(
            msg: 'تم تسجيل الطلب بنجاح',
            toastStatus: 'SUCCESS',
            context: context);
      }
    }).onError(
      (error, stackTrace) {
        if (context.mounted) {
          ToastService.sendScaffoldAlert(
              msg: 'المعذرة ، خطأ في الطلب',
              toastStatus: 'ERROR',
              context: context);
        }
        log('error');
        throw Exception(error);
      },
    );
  }

  static endRide(String rideID, BuildContext context) async {
    try {
      Uuid uuid = const Uuid();
      String uniqueID = uuid.v1().toString();

      DatabaseReference rideRef = FirebaseDatabase.instance
          .ref()
          .child('RideRequest/$rideID/rideEndTime');
      DatabaseReference rideRefFechData =
          FirebaseDatabase.instance.ref().child('RideRequest/$rideID');

      DatabaseReference riderRef = FirebaseDatabase.instance
          .ref()
          .child('RiderRideHistory/$rideID/$uniqueID');

      DatabaseReference driverProfileRef = FirebaseDatabase.instance
          .ref()
          .child('User/${auth.currentUser!.uid}/activeRideRequestID');

      DatabaseReference driverRef = FirebaseDatabase.instance
          .ref()
          .child('DriverRideHistory/$rideID/$uniqueID');
      context.read<DriverRideRequestProvider>().updateUpdateMarkerStatus(false);
      await rideRef.set(DateTime.now().microsecondsSinceEpoch);

      final snapshot = await rideRefFechData.get();
      log(snapshot.value.toString());
      if (snapshot.value != null) {
        RiderRequistModel rideData = RiderRequistModel.fromMap(
            jsonDecode(jsonEncode(snapshot.value)) as Map<String, dynamic>);
        log('fare isss: ${(rideData.fare)}');
        ToastService.sendScaffoldAlert(
            msg: ' :تم انهاء الرحلة بنجاح ، حسابك هو ${(rideData.fare)}',
            toastStatus: 'SUCCESS',
            context: context);
        await RideRequestServicesForDriver.updateRideRequestStatus(
            RideRequestServicesForDriver.getRideStatus(3), rideID);
        await riderRef.set(rideData.toMap());
        await driverRef.set(rideData.toMap());
        await rideRefFechData.remove();
        await driverProfileRef.remove();
      } else {
        log('null fare');
      }
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }
}
