import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quadro_platform/constants/commonWidgets/customTextField.dart';
import 'package:quadro_platform/constants/commonWidgets/custom_elevated_button.dart';
import 'package:quadro_platform/constants/commonWidgets/password_text_field.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:quadro_platform/constants/utils/textStyles.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({super.key});
  static String id = 'registration screen';
  File? profilePic;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 5.h),
          children: [
            InkWell(
              onTap: (){},
              child: CircleAvatar(
                radius: 8.h,
                backgroundColor: white,
                child: Builder(
                  builder: (context) {
                    if (profilePic != null) {
                      return CircleAvatar(
                        radius: 8.h - 2,
                        backgroundColor: white,
                        backgroundImage: FileImage(profilePic!),
                      );
                    } else {
                      return CircleAvatar(
                        radius: 8.h - 2,
                        backgroundColor: white,
                        backgroundImage: const AssetImage(
                            "assets/images/logos/quadroLogo.jpg"),
                      );
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Center(
              child: Text(
                "سجل الان",
                style: AppTextStyles.Mheading26Bold.copyWith(
                    color: teal, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 6.h),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "الاسم ",
                style: AppTextStyles.Mbody16Bold.copyWith(color: teal),
              ),
            ),
            SizedBox(height: 1.h),
            const CustomTextField(),
            SizedBox(height: 2.5.h),
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
            SizedBox(height: 2.h),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "رقم الهاتف ",
                style: AppTextStyles.Mbody16Bold.copyWith(color: teal),
              ),
            ),
            SizedBox(height: 1.h),
            const CustomTextField(),
            SizedBox(height: 4.h),
            CustomElevatedButton(
              buttonTitle: 'التسجيل',
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
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    "تسجيل الدخول  ",
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
                  "لديك حساب بالفعل؟  ",
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
