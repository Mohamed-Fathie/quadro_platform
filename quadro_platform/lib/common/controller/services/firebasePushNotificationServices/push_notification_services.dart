import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:googleapis_auth/auth_io.dart' as gauth;
import 'package:http/http.dart' as http;
import 'package:quadro_platform/common/controller/services/APIS&KEYS/apis.dart';
import 'package:quadro_platform/common/model/profile_data_model.dart';
import 'package:quadro_platform/common/model/rider_request_modele.dart';

import 'package:quadro_platform/constants/constants.dart';

class PushNotivicationServices {
  static String? _accessToken;
  static DateTime? _tokenExpirationTime;

  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static Future initializeFirebaseMessaging(
      ProfileDataModel profileData, BuildContext context) async {
    await firebaseMessaging.requestPermission(sound: true, alert: true);
    if (profileData.userType == 'التسجيل كصاحب ساحبة') {
      FirebaseMessaging.onBackgroundMessage(
          firebaseMessagingBackGroundHandlerFornWorkshopAndTowingDriver);

      // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //   if (message.notification != null || context.mounted) {
      //     firebaseMessagingForeGroundHandlerFornWorkshopAndTowingDrive(
      //         message, context);
      //   }
      // });
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

  static getRideRequestID(RemoteMessage message) async {
    String rideID = message.data['rideRequestID'];
    log('Riderr ID: $rideID');
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

  // static firebaseMessagingForeGroundHandlerFornWorkshopAndTowingDrive(
  //     RemoteMessage message, BuildContext context) async {
  //   String rideID = getRideRequestID(message);
  //   fetchRideRequestInfo(rideID, context);
  // }

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
        log('not null');
        RiderRequistModel riderRequestModel = RiderRequistModel.fromMap(
          jsonDecode(
            jsonEncode(
              databaseEvent.snapshot.value,
            ),
          ) as Map<String, dynamic>,
        );

        log('rider model${riderRequestModel.toMap().toString()}');
        // PushNotificationDialouge.RideRequestDilouge(
        //     rideID, riderRequestModel, context);
      }
    }).onError((error, stackTrace) {
      log('errorrr:${error.toString()}');
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

  // static Future<String> getAccessToken() async {
  //   final serviceAccountJson = {
  //     "type": "service_account",
  //     "project_id": "quadro-204be",
  //     "private_key_id": "229624c6d0e52c4e3c385df8527640f08e9dd6d8",
  //     "private_key":
  //         "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCMWOUDpGb/6PnS\nMz5wDx/FOX5yFEMLvGdOmsoFm+RSTOs9DF84tnzS0V4yi8DYkuxB6+LfoRPArqKD\nNSWoCPMARl4IWnZBnu6xmkJLC/3IyEgYdJ85YtUtgyPufHgow9vW2OOCwhto9Pxh\nu52RUvpSwc9ybjiK4TLjyDBKVvKlKFCRK4r8ud3Yw/7Y8vvUw+qcX3K4RC6Z0mVJ\n7XN8bTupBGiiDiu3B82zlz96aii7ek7tE7tGHMq7X1xBhG0SCYlpZmsGjnA/aEMQ\nKv7mJJhOHZowrMCAxs+N6ir72QfD/7zIPrVxHWTTwr/Eoe6Bt/kadiEdLTe84Nek\nKQWIaIVRAgMBAAECggEABa1W3jXZQMLQ0DLodKn39AdmWQD+0Uu2thRG1cE/lCCu\nZ1LHy0h+dhyn/c1vaJNQ4T3EeJ1QajvmMP6GXmy2P62ZAid+nxrptt9xjQ2YH3YS\njIKzKiQYUXX7jxsT1TpO+zrcwR5O84jtaJqpPgaoP469cHiK6vs/Dr27TlaEDDAs\n8lSaE8aHUjPfVVxNgqfZerls9KgcxVkJ4kjE9ry9lAP7iNplIDdVqdUixBKkk++e\nL0LXkqmtXb1/wh0ijnoVXtJScivetvoN3Lknf4pmZb1rIS294klNMaecvfnLQ1yZ\nybW5BJjpxBEcEQ8v/cWRpueIT6sABHbN+NsWvWaNjQKBgQDDyy1ylob9U/beFMsh\nPQy0miRqz6YBgdvIrntQSDMuJACqgnhY1R7i2guL9TlBzM85/xhc4qTknxqWeBUC\nDhY3rFQuIMRsHWNsQRKbKjuSNt6M245bafbuOk2AD2bPSgTY/+q8JA170XCqOXBp\nBhdEZgRqNHJbyiKd06lVic9IFwKBgQC3gP2Stq1pYXBfIFDoTyiqH7FbVbt9x4qH\n0GXyMgjF4+LbTXYm1kb8T/Tm37tRGbfp300UqK7XxzSxvP0Ef5dm5V6YyDWBr2px\niAUmu6Fgdt2g1GgqkQxhqzeeswiNiYpf13CVhBy39G1Nog4sQjZw3m7kqaQyPA4L\nfrNLIYcW1wKBgC5m/MJngl6Pg7ZmXy3ldhlnXrIhvEonKJuLHpaMRfTte2rtuO/0\nsnk5C/uDhqpdi89G8dMxs7qrKnX2x6PRCtru8JRuF58359REJ9C2VZ/1eRERB9AK\ncQdMsgljnQ4LkNKM9Gjacoehv33YVxfM5b7EHs+81k2CvmmBPGSVYJbJAoGAVvFj\nsz6gPPywrDF4hAj1YF1xv6+IDNkdFqozkyQHqhMF6hfycgY2TddoVncMnilMTR/C\nupYNeSjmG4xKaPY2+saUIllBmLdO/ImQv0BI/pZy/X+F9x0QO7pOuP9kfwL6r9w4\neG7G2JWTsCOnCWs5thJ9ghOqOy7fDK00L9Wr1rMCgYByYy6nfPOh34jFJzsXZGUj\nvtYSqI5M5vtM6c2vGoKxN2DRZ+AdkL6OnVZvmay4U/o+PadNHJiDRONIPFaZr2A0\nu4acc3XK2vIgWllsCaQt++PsSgGOcUO+4Jd5JXhYsE2yFEAdT8FTvbTroei4ii6C\nbPBkdzhgJkpXFduBLQD1DQ==\n-----END PRIVATE KEY-----\n",
  //     "client_email":
  //         "firebase-adminsdk-s4qp6@quadro-204be.iam.gserviceaccount.com",
  //     "client_id": "103198309977513048043",
  //     "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  //     "token_uri": "https://oauth2.googleapis.com/token",
  //     "auth_provider_x509_cert_url":
  //         "https://www.googleapis.com/oauth2/v1/certs",
  //     "client_x509_cert_url":
  //         "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-s4qp6%40quadro-204be.iam.gserviceaccount.com",
  //     "universe_domain": "googleapis.com"
  //   };

  //   List<String> scopes = [
  //     "https://www.googleapis.com/auth/userinfo.email",
  //     "https://www.googleapis.com/auth/firebase.database",
  //     "https://www.googleapis.com/auth/firebase.messaging"
  //   ];

  //   try {
  //     http.Client client = await gauth.clientViaServiceAccount(
  //         gauth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

  //     gauth.AccessCredentials credentials =
  //         await gauth.obtainAccessCredentialsViaServiceAccount(
  //             gauth.ServiceAccountCredentials.fromJson(serviceAccountJson),
  //             scopes,
  //             client);

  //     client.close();
  //     // log("Access Token: ${credentials.accessToken.data}"); // Print Access Token
  //     return credentials.accessToken.data;
  //   } catch (e) {
  //     log("Error getting access token: $e");
  //     return 'null';
  //   }
  // }

  static Future<String> getAccessToken() async {
    // إذا كان التوكن لا يزال صالحًا، قم بإعادته مباشرةً
    bool isAccessTokenExpired() {
      if (_tokenExpirationTime == null) return true;
      return DateTime.now().isAfter(_tokenExpirationTime!);
    }

    final serviceAccountJson = {};

    List<String> scopes = [];

    try {
      final client = await gauth.clientViaServiceAccount(
        gauth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
      );

      final credentials = await gauth.obtainAccessCredentialsViaServiceAccount(
        gauth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
        client,
      );

      client.close();

      // تخزين التوكن ووقت انتهاء الصلاحية
      _accessToken = credentials.accessToken.data;
      _tokenExpirationTime = credentials.accessToken.expiry;

      return _accessToken!;
    } catch (e) {
      log("Error getting access token: $e");
      return 'null';
    }
  }

// static sendRideRequestToNearbyDrivers(List<String> driverFCMTokens) async {
//   try {
//     final String accessToken = await getAccessToken();
//     log('Access Token: $accessToken');

//     final api = Apis.pushNotificationAPI();

//     for (String token in driverFCMTokens) {
//       final payload = {
//         "message": {
//           "token": token, // إرسال الإشعار لكل جهاز على حدة
//           "notification": {
//             "title": "طلب سحب",
//             "body": "طلب سحب مركبة"
//           },
//           "data": {
//             "rideRequestID": auth.currentUser!.uid
//           },
//           "android": {
//             "priority": "HIGH"
//           }
//         }
//       };

//       try {
//         var response = await dio.post(
//           api,
//           options: Options(
//             headers: {
//               'Authorization': 'Bearer $accessToken',
//               'Content-Type': 'application/json',
//             },
//           ),
//           data: jsonEncode(payload),
//         );
//         log('Message sent to: $token');
//       } catch (e) {
//         log('Error sending message to $token: $e');
//       }
//     }
//   } catch (e) {
//     log(e.toString());
//     throw Exception(e);
//   }
// }

// static sendRideRequestToNearbyDrivers(List<String> driverFCMTokens) async {
//   try {
//     final String accessToken = await getAccessToken();
//     log('access token: $accessToken');

//     (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
//       HttpClient client = HttpClient();
//       client.badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//       return client;
//     };

//     final api = Apis.pushNotificationAPI();
//     final payload = {
//       "message": {
//         "tokens": driverFCMTokens, // إرسال قائمة من التوكنات
//         "notification": {"title": "طلب سحب", "body": "طلب سحب مركبة"},
//         "data": {"rideRequestID": auth.currentUser!.uid},
//         "android": {"priority": "HIGH"}
//       }
//     };

//     var response = await dio
//         .post(api,
//             options: Options(
//               headers: {
//                 'Authorization': 'Bearer $accessToken',
//                 'Content-Type': 'application/json',
//               },
//             ),
//             data: jsonEncode(payload))
//         .then((onValue) {
//       log('message send');
//     }).timeout(const Duration(seconds: 550), onTimeout: () {
//       throw TimeoutException('انتهت صلاحية الجلسة');
//     }).onError(
//       (error, stackTrace) {
//         log(error.toString());
//         throw Exception(error);
//       },
//     );
//   } catch (e) {
//     log(e.toString());
//     throw Exception(e);
//   }
// }

  static sendRideRequestToNearbyDrivers(String driverFCMToken) async {
    try {
      final String accessToken = await getAccessToken();
      // log('access token: $accessToken');

      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        HttpClient client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };

      final api = Apis.pushNotificationAPI();
      final payload = {
        "message": {
          "token": driverFCMToken,
          "notification": {"title": "طلب سحب", "body": "طلب سحب مركبة"},
          "data": {"rideRequestID": auth.currentUser!.uid},
          "android": {"priority": "HIGH"}
        }
      };
      var response = await dio
          .post(api,
              options: Options(
                headers: {
                  'Authorization': 'Bearer $accessToken',
                  'Content-Type': 'application/json',
                },
              ),
              data: jsonEncode(payload))
          .then((onValue) {
        log('message send');
      }).timeout(const Duration(seconds: 550), onTimeout: () {
        throw TimeoutException('انتهت صلاحية الجلسة');
      }).onError(
        (error, stackTrace) {
          log(error.toString());
          throw Exception(error);
        },
      );
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }
}
