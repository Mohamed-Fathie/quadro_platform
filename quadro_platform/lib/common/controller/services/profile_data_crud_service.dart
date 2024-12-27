// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quadro_platform/common/controller/services/toast_services.dart';
import 'package:quadro_platform/common/model/profile_data_model.dart';
import 'package:quadro_platform/common/view/logInLogic/log_in_logic.dart';
import 'package:quadro_platform/constants/constants.dart';

class ProfileDataCRUDServices {
  static getProfileDataFromRealTimeDatabase(String userID) async {
    try {
      final snapshot = await realTimeDatabaseRef.child('User/$userID').get();
      if (snapshot.exists) {
        ProfileDataModel userModel = ProfileDataModel.fromMap(
            jsonDecode(jsonEncode(snapshot.value)) as Map<String, dynamic>);
        return userModel;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<bool> checkForRegisteredUser(BuildContext context) async {
    try {
      
      final snapshot = await realTimeDatabaseRef
          .child('User/${auth.currentUser!.uid}')
          .get();
      if (snapshot.exists) {
        log('User Data found');
        return true;
      }
      log('User Data not found');
      return false;
    } catch (e) {
      throw Exception(e);
    }
  }

  static registerUserToDatabase(
      {required ProfileDataModel profileData, required BuildContext context}) {
    // if (auth.currentUser == null) {
    //   Navigator.pushAndRemoveUntil(
    //       context,
    //       PageTransition(
    //           child: const LogInScreen(), type: PageTransitionType.bottomToTop),
    //       (route) => false);
    // }

    realTimeDatabaseRef
        .child('User/${auth.currentUser!.uid}')
        .set(profileData.toMap())
        .then((value) {
      ToastService.sendScaffoldAlert(
        msg: 'تم تسجيلك بنجاح',
        toastStatus: 'SUCCESS',
        context: context,
      );
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
              child: const LogInLogic(), type: PageTransitionType.bottomToTop),
          (route) => false);
    }).onError((error, stackTrace) {
      ToastService.sendScaffoldAlert(
        msg: 'Opps! Error getting Registered',
        toastStatus: 'SUCCESS',
        context: context,
      );
    });
  }

  static Future<String> userIsTowingDriver(BuildContext context) async {
    try {
      DataSnapshot snapshot = await realTimeDatabaseRef
          .child('User/${auth.currentUser!.uid}')
          .get();
      if (snapshot.exists) {
        ProfileDataModel userModel = ProfileDataModel.fromMap(
            jsonDecode(jsonEncode(snapshot.value)) as Map<String, dynamic>);
        log('User Type is ${userModel.userType}');
        if (userModel.userType == 'التسجيل كصاحب ساحبة') {
          return 'التسجيل كصاحب ساحبة';
        } else if (userModel.userType == 'التسجيل كصاحب ورشة') {
          return 'التسجيل كصاحب ورشة';
        } else {
          return 'تسجيل كمستخدم عادي';
        }
      }
    } catch (e) {
      throw Exception(e);
    }
    return 'false';
  }
}
