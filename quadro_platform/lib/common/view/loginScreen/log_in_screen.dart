import 'package:flutter/material.dart';
import 'package:quadro_platform/common/view/registrationScreen/registration_screen.dart';
import 'package:quadro_platform/constants/commonWidgets/customTextField.dart';
import 'package:quadro_platform/constants/commonWidgets/custom_elevated_button.dart';
import 'package:quadro_platform/constants/commonWidgets/password_text_field.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:quadro_platform/constants/utils/textStyles.dart';
import 'package:sizer/sizer.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});
  static String id = 'login screen';
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
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "البريد الالكتروني",
                style: AppTextStyles.Mbody16Bold.copyWith(color: teal),
              ),
            ),
            SizedBox(height: 1.h),
            const CustomTextField(),
            SizedBox(height: 2.h),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "كلمة المرور",
                style: AppTextStyles.Mbody16Bold.copyWith(color: teal),
              ),
            ),
            SizedBox(height: 1.h),
            const PasswordTextField(),
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
            SizedBox(height: 4.h),
            CustomElevatedButton(
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
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed((context), RegistrationScreen.id);
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
