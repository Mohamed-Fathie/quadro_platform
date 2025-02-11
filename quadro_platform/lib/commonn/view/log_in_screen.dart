import 'package:flutter/material.dart';
import 'package:quadro_platform/commonn/controller/services/auth_services.dart';
import 'package:quadro_platform/constants/commonWidgets/custom_elevated_button.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:quadro_platform/constants/utils/textStyles.dart';
import 'package:quadro_platform/shared/routes/navigation_service.dart';
import 'package:quadro_platform/shared/routes/routes_constants.dart';
import 'package:quadro_platform/shared/widgets/registration_custom_password_field.dart';
import 'package:quadro_platform/shared/widgets/registration_textField.dart';
import 'package:sizer/sizer.dart';

import 'reset_password_screen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});
  static String id = 'login screen';
  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool loginButtonPressed = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 5.h),
          children: [
            Container(
              height: 42.w,
              width: 42.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: white),
                image: const DecorationImage(
                  image: AssetImage('assets/images/logos/quadroLogo.jpg'),
                ),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Center(
              child: Text(
                "تسجيل الدخول",
                style: AppTextStyles.Mheading26Bold.copyWith(
                    color: teal, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 6.h),
            RegistrationScreenTextField(
              controller: emailController,
              keyBoardType: TextInputType.emailAddress,
              readOnly: false,
              title: 'البريد الالكتروني',
              hint: "",
            ),
            SizedBox(height: 2.h),
            RegistrationPasswordTextField(
              controller: passwordController,
              hint: '',
              keyBoardType: TextInputType.visiblePassword,
              readOnly: false,
              title: 'كلمة المرور',
            ),
            SizedBox(height: 0.5.h),
            SizedBox(height: 1.h),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "استخدم 8 احرف او اكثر مع مزيج من الارقام والرموز",
                style: AppTextStyles.Mbody14Bold.copyWith(color: grey),
              ),
            ),
            SizedBox(height: 2.5.h),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => NavigationService()
                    .routeTo(RoutesConstants.resetPassWordScreen),
                child: Text(
                  "نسيت كلمة المرور؟",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontFamily: 'Madhani-Arabic',
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 4.h),
            CustomElevatedButton(
              onPressed: () {
                AuthServices.loginUser(
                    context: context,
                    emailController: emailController,
                    passwordController: passwordController);
              },
              buttonTitle: 'تسجيل الدخول',
              fontColor: white,
              fontSize: 16,
            ),
            SizedBox(
              height: 2.5.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    NavigationService().routeTo(RoutesConstants.signUp);
                  },
                  child: Text(
                    "انشاء حساب ",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontFamily: 'Madhani-Arabic',
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: teal,
                    ),
                  ),
                ),
                Text(
                  "لا تمتلك حساب؟",
                  style: AppTextStyles.Mbody16Bold.copyWith(color: black),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
