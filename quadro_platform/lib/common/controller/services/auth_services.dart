import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quadro_platform/common/controller/services/profile_data_crud_service.dart';
import 'package:quadro_platform/common/view/logInLogic/log_in_logic.dart';
import 'package:quadro_platform/common/view/log_in_screen.dart';
import 'package:quadro_platform/common/view/registration_screen.dart';
import 'package:quadro_platform/constants/constants.dart';
import 'package:quadro_platform/driver/view/driver_home_screen.dart';
import 'package:quadro_platform/features/workshop_authentication/veiws/id_screen.dart';
import 'package:quadro_platform/features/workshop_authentication/veiws/workshop_authenitication_page.dart';
import 'package:quadro_platform/shared/routes/navigation_service.dart';
import 'package:quadro_platform/user/view/bottomNavBar/bottom_navbar.dart';

class AuthServices {
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

  static bool checkAuthentication() {
    User? user = auth.currentUser;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

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

  static registerUser(
      {required TextEditingController emailController,
      required TextEditingController passwordController,
      required BuildContext context}) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      showSnackBar(context, ' تم التسجيل بنجاح');
      await Future.delayed(const Duration(seconds: 1));
      NavigationService().goBack();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context,
            'يجب ان تكون كلمة السر مكونة من 8 احرف او اكثر مع مزيج من الارقام والرموز ');
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context, 'هذا الحساب مسجل مسبقا!');
      } else if (e.code == 'invalid-email') {
        showSnackBar(context, 'الرجاء ادخال البريد الالكتروني بشكل صحيح');
      }
    } catch (e) {
      showSnackBar(context, 'There was an error, please try again.');
    }
  }

  static checkUser(context) async {
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
                child: const WorkshopRegisterationPage(),
                type: PageTransitionType.bottomToTop),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
                child: BottomNavBar(), type: PageTransitionType.bottomToTop),
            (route) => false);
      }
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
              child: RegistrationScreen(),
              type: PageTransitionType.bottomToTop),
          (route) => false);
    }
  }
}
