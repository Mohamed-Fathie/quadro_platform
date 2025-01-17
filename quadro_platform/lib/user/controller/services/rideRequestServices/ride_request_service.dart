import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:quadro_platform/common/controller/services/toast_services.dart';
import 'package:quadro_platform/common/model/rider_request_model.dart';
import 'package:quadro_platform/constants/constants.dart';

class RideRequestService {
  static createNewRideRequest(
      RiderRequistModel rideRequestModel, BuildContext context) {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child('RideRequest/${auth.currentUser!.uid}');
    ref.set(rideRequestModel.toMap()).then((onValue) {
      if (context.mounted) {
        ToastService.sendScaffoldAlert(
            msg: 'تم تسجيل الرحلة بنجاح',
            toastStatus: 'SUCCESS',
            context: context);
      }
    }).onError((error, StackTrace) {
      if (context.mounted) {
        ToastService.sendScaffoldAlert(
            msg: 'خطأ في اضافة طلب رحلة',
            toastStatus: 'ERROR',
            context: context);
      }
    });
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

  static cancelRideRequest(BuildContext context) {
    FirebaseDatabase.instance
        .ref()
        .child('RideRequest/${auth.currentUser!.uid}')
        .remove()
        .then((onValue) {});
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
