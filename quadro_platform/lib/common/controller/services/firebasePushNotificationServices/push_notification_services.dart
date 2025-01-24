import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:quadro_platform/common/controller/services/firebasePushNotificationServices/push_notification_dialouge.dart';
import 'package:quadro_platform/common/model/profile_data_model.dart';
import 'package:quadro_platform/common/model/rider_request_model.dart';
import 'package:quadro_platform/constants/constants.dart';

class PushNotivicationServices {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static Future initializeFirebaseMessaging(
      ProfileDataModel profileData, BuildContext context) async {
    await firebaseMessaging.requestPermission();
    if (profileData.userType == 'التسجيل كصاحب ساحبة') {
      FirebaseMessaging.onBackgroundMessage(
          firebaseMessagingBackGroundHandlerFornWorkshopAndTowingDriver);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          firebaseMessagingForeGroundHandlerFornWorkshopAndTowingDrive(
              message, context);
        }
      });
    } else if (profileData.userType == 'التسجيل كصاحب ورشة') {
      FirebaseMessaging.onBackgroundMessage(
          firebaseMessagingBackGroundHandlerFornWorkshopAndTowingDriver);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          firebaseMessagingForeGroundHandlerFornWorkshopAndTowingDrive(
              message, context);
        }
      });
    } else {
      FirebaseMessaging.onBackgroundMessage(
          firebaseMessagingBackGroundHandlerForUser);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          firebaseMessagingForeGroundHandlerUser(message);
        }
      });
    }
  }

  static getRideRequestID(RemoteMessage message) {
    String rideID = message.data['rideRequestID'];
    log('Rider ID: $rideID');
    return rideID;
  }

// user messages functions
  static Future<void> firebaseMessagingBackGroundHandlerForUser(
      RemoteMessage message) async {}
  static firebaseMessagingForeGroundHandlerUser(RemoteMessage message) async {}

//workshop and towing driver messages functions

  static Future<void>
      firebaseMessagingBackGroundHandlerFornWorkshopAndTowingDriver(
          RemoteMessage message) async {
    String rideID = getRideRequestID(message);
  }

  static firebaseMessagingForeGroundHandlerFornWorkshopAndTowingDrive(
      RemoteMessage message, BuildContext context) async {
    String rideID = getRideRequestID(message);
    fetchRideRequestInfo(rideID, context);
  }

// ! ********************************************************** ! //
  static Future getToken(ProfileDataModel model) async {
    String? token = await firebaseMessaging.getToken();
    log('cloud messaging token: $token');
    DatabaseReference tokenRef = FirebaseDatabase.instance
        .ref()
        .child('User/${auth.currentUser!.uid}/cloudMessagingToken');
    tokenRef.set(token);
  }

  static fetchRideRequestInfo(String rideID, BuildContext context) {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref().child('RideRequest/$rideID');
    ref.once().then((databaseEvent) {
      if (databaseEvent.snapshot.value != null) {
        RiderRequistModel riderRequestModel = RiderRequistModel.fromMap(
          jsonDecode(
            jsonEncode(
              databaseEvent.snapshot.value,
            ),
          ) as Map<String, dynamic>,
        );

        log('rider model${riderRequestModel.toMap().toString()}');
        PushNotificationDialouge.RideRequestDilouge(
            rideID, riderRequestModel, context);
      }
    }).onError((error, stackTrace) {
      log(error.toString());
      throw Exception(error);
    });
  }

  static subscribeToNotification(ProfileDataModel model) {
    if (model.userType == 'التسجيل كصاحب ساحبة') {
      firebaseMessaging.subscribeToTopic('TOWING_DRIVER');
      firebaseMessaging.subscribeToTopic('USER');
    } else {
      firebaseMessaging.subscribeToTopic('NORMAL_USER');
      firebaseMessaging.subscribeToTopic('USER');
    }
  }

  static initializeFirebaseMessagingForUsers(
      ProfileDataModel profileData, BuildContext context) {
    initializeFirebaseMessaging(profileData, context);
    getToken(profileData);
    subscribeToNotification(profileData);
  }
}
