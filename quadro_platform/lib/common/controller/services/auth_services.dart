import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quadro_platform/common/controller/services/image_services.dart';
import 'package:quadro_platform/common/controller/services/profile_data_crud_service.dart';
import 'package:quadro_platform/common/controller/services/toast_services.dart';
import 'package:quadro_platform/common/model/profile_data_model.dart';
import 'package:quadro_platform/common/view/logInLogic/log_in_logic.dart';
import 'package:quadro_platform/common/view/log_in_screen.dart';
import 'package:quadro_platform/constants/constants.dart';
import 'package:quadro_platform/driver/view/driver_home_screen.dart';
import 'package:quadro_platform/features/user/repository/user_repository.dart';
import 'package:quadro_platform/features/workshop_authentication/views/id_screen.dart';
import 'package:quadro_platform/features/workshop_authentication/views/workshop_authenitication_page.dart';
import 'package:quadro_platform/shared/routes/navigation_service.dart';
import 'package:quadro_platform/shared/routes/routes_constants.dart';
import 'package:quadro_platform/user/view/bottomNavBars/user_bottom_navbar.dart';
import 'package:quadro_platform/user/view/bottomNavBars/main_bottom_navbar.dart';

import '../../../features/workshop_bottom_nav_bar/workshop_nav_bar.dart';

class AuthServices {
  // ******************* loginUser function *****************//
  static loginUser(
      {required BuildContext context,
      required TextEditingController emailController,
      required TextEditingController passwordController}) async {
    try {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        showSnackBar(context, 'الرجاء إدخال البريد الإلكتروني وكلمة المرور.');
        return;
      }
      await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      showSnackBar(context, ' تم تسجيل الدخول بنجاح');
      Navigator.push(
        context,
        PageTransition(
            child: const LogInLogic(), type: PageTransitionType.bottomToTop),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('user-not-found');
        showSnackBar(context, 'هذا الحساب غير موجود , قم بالتسجيل اولا!');
      } else if (e.code == 'wrong-password') {
        showSnackBar(context, 'كلمة مرور خاطئة!');
      } else if (e.code == 'invalid-email') {
        showSnackBar(context, 'الرجاء ادخال البريد الالكتروني بشكل صحيح');
      } else if (e.code == 'user-disabled') {
        showSnackBar(context, 'تم تعطيل حسابك مؤقتا!');
      } else if (e.code == 'invalid-credential') {
        showSnackBar(
            context, 'خطأ في كلمة المرور او ان البريد الالكتروني غير موجود');
      }
    } catch (e) {
      showSnackBar(context, 'There was an error, please try again.');
    }
  }

  // ******************* checkAuthentication function *****************//
  static bool checkAuthentication() {
    User? user = auth.currentUser;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  // ******************* checkAuthenticationAndNavigate function *****************//
  static checkAuthenticationAndNavigate({required BuildContext context}) {
    bool userAuthenticated = checkAuthentication();
    userAuthenticated
        ? checkUser(context)
        : Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
              child: const LogInScreen(),
              type: PageTransitionType.bottomToTop,
            ),
            (route) => false,
          );
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

// ******************* registerUser function *****************//
  static Future<bool> registerUser(
      {required String emailController,
      required String passwordController,
      required BuildContext context}) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: emailController, password: passwordController);
      log('create User With Email And Password is done ');
      ToastService.sendScaffoldAlert(
        msg: ' تم التسجيل بنجاح',
        toastStatus: 'SUCCESS',
        context: context,
      );

      // await Future.delayed(const Duration(seconds: 1));
      // NavigationService().goBack();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'password_does_not_meet_requirements') {
        ToastService.sendScaffoldAlert(
          msg:
              'يجب ان تكون كلمة السر مكونة من 8 احرف او اكثر مع مزيج من الارقام والرموز ',
          toastStatus: 'WARNING',
          context: context,
        );
      } else if (e.code == 'weak-password') {
        ToastService.sendScaffoldAlert(
          msg:
              'يجب ان تكون كلمة السر مكونة من 8 احرف او اكثر مع مزيج من الارقام والرموز ',
          toastStatus: 'WARNING',
          context: context,
        );
      } else if (e.code == 'email-already-in-use') {
        ToastService.sendScaffoldAlert(
          msg: 'هذا الحساب مسجل مسبقا',
          toastStatus: 'WARNING',
          context: context,
        );
      } else if (e.code == 'invalid-email') {
        ToastService.sendScaffoldAlert(
          msg: 'الرجاء ادخال البريد الالكتروني بشكل صحيح',
          toastStatus: 'WARNING',
          context: context,
        );
      }
      return false;
    } catch (e) {
      showSnackBar(context, 'There was an error, please try again.');
      return false;
    }
  }

// ******************* checkUser function *****************//

  static checkUser(context) async {
    try {
      bool userIsRegistered =
          await ProfileDataCRUDServices.checkForRegisteredUser(context);
      if (userIsRegistered == true) {
        String userIsTowingDriver =
            await ProfileDataCRUDServices.userIsTowingDriver(context);
        if (userIsTowingDriver == 'التسجيل كصاحب ساحبة') {
          Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                  child: const DriverHomeScreen(),
                  type: PageTransitionType.bottomToTop),
              (route) => false);
        } else if (userIsTowingDriver == 'التسجيل كصاحب ورشة') {
          return Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                  child: const WorkshopNavBar(),
                  type: PageTransitionType.bottomToTop),
              (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                  child: MainBottomNavBar(),
                  type: PageTransitionType.bottomToTop),
              (route) => false);
        }
      } else {
        log('checkUser : No data for this user');
        Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
                child: const LogInScreen(),
                type: PageTransitionType.bottomToTop),
            (route) => false);
      }
    } catch (e, stackTrace) {
      log('userCheck error : $e');
      log('Stack Trace: $stackTrace');
      ToastService.sendScaffoldAlert(
          msg: 'حدث خطأ , حاول مجددا بعد قليل',
          toastStatus: 'WARNING',
          context: context);
    }
  }

// ******************* logOutUser function *****************//
  static logOutUser(context) {
    auth.signOut();
    NavigationService().routeTo(RoutesConstants.loginLogic);
  }

  static registerTowingDriver(
      {required String userType,
      required File? profilePic,
      required String nameController,
      required String mobileController,
      required String emailController,
      required String passwordController,
      required String vehicleBrandController,
      required String vehicleModelController,
      required String selectVehicleType,
      required String vehicleRegistrationNumberController,
      required String drivingLicenceNumberController,
      required context}) async {
    if (profilePic == null) {
      ToastService.sendScaffoldAlert(
        msg:
            'الرجاء اختيار صورة شخصية واضحة المعالم لك , لغرض الامان والموثوقية',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (nameController.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'الرجاء ادخال اسمك ',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (mobileController.isEmpty ||
        mobileController.length < 9 ||
        mobileController.length > 10) {
      ToastService.sendScaffoldAlert(
        msg: 'الرجاء ادخال رقم هاتفك بشكل صحيح',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (emailController.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'الرجاء ادخال بريدك الالكتروني',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (passwordController.isEmpty || passwordController.length < 8) {
      ToastService.sendScaffoldAlert(
        msg: 'الرجاء ادخال كلمة مرور قوية مكونة من 8 ارقام او اكثر',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (vehicleBrandController.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'ادخل نوع المركبة , مثلا "افيكو"',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (vehicleModelController.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'ادخل موديل الساحبة',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (selectVehicleType == 'اختر نوع مركبتك') {
      ToastService.sendScaffoldAlert(
        msg: 'الرجاء اختيار نوع السحب',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (vehicleRegistrationNumberController.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'الرجاء ادخال رقم هيكل السيارة',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (drivingLicenceNumberController.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'يرجى ادخال رقم رخصتك',
        toastStatus: 'WARNING',
        context: context,
      );
    } else {
      bool isRegistered = await AuthServices.registerUser(
          emailController: emailController,
          passwordController: passwordController,
          context: context);
      if (!isRegistered) return;
      String profilePicURL = await ImageServices.uploadImageToFirebaseStorage(
          image: File(profilePic.path), context: context);
      ProfileDataModel profileData = ProfileDataModel(
        profilePicUrl: profilePicURL,
        name: nameController.trim(),
        mobileNumber: mobileController.trim(),
        email: auth.currentUser!.email!,
        password: passwordController.trim(),
        userType: userType,
        vehicleBrandName: vehicleBrandController.trim(),
        vehicleModel: vehicleModelController.trim(),
        vehicleType: selectVehicleType,
        vehicleRegistrationNumber: vehicleRegistrationNumberController.trim(),
        drivingLicenseNumber: drivingLicenceNumberController.trim(),
        registeredDateTime: DateTime.now(),
      );
      await ProfileDataCRUDServices()
          .registerUserToDatabase(profileData: profileData, context: context);
    }
  }

  static registerCustomerAndWorkShopPartner(
      {required String userType,
      required File? profilePic,
      required String nameController,
      required String mobileController,
      required String emailController,
      required String passwordController,
      required context}) async {
    if (profilePic == null) {
      ToastService.sendScaffoldAlert(
        msg:
            'الرجاء اختيار صورة شخصية واضحة المعالم لك , لغرض الامان والموثوقية',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (nameController.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'الرجاء ادخال اسمك ',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (mobileController.isEmpty ||
        mobileController.length < 9 ||
        mobileController.length > 10) {
      ToastService.sendScaffoldAlert(
        msg: 'الرجاء ادخال رقم هاتفك بشكل صحيح',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (emailController.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'الرجاء ادخال بريدك الالكتروني',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (passwordController.isEmpty || passwordController.length < 8) {
      ToastService.sendScaffoldAlert(
        msg: 'الرجاء ادخال كلمة مرور قوية مكونة من 8 ارقام او اكثر',
        toastStatus: 'WARNING',
        context: context,
      );
    } else {
      bool isRegistered = await AuthServices.registerUser(
          emailController: emailController,
          passwordController: passwordController,
          context: context);

      if (!isRegistered) return;
      String profilePicURL = await ImageServices.uploadImageToFirebaseStorage(
          image: File(profilePic.path), context: context);

      ProfileDataModel profileData = ProfileDataModel(
        profilePicUrl: profilePicURL,
        name: nameController.trim(),
        mobileNumber: mobileController.trim(),
        email: auth.currentUser!.email!,
        password: passwordController.trim(),
        userType: userType,
        registeredDateTime: DateTime.now(),
      );

      await ProfileDataCRUDServices()
          .registerUserToDatabase(profileData: profileData, context: context);
    }
  }
}
