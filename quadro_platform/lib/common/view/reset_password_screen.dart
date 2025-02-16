import 'package:flutter/material.dart';
import 'package:quadro_platform/common/controller/services/auth_services.dart';
import 'package:quadro_platform/common/controller/services/toast_services.dart';
import 'package:quadro_platform/constants/commonWidgets/custom_elevated_button.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:quadro_platform/constants/utils/textStyles.dart';
import 'package:quadro_platform/shared/routes/navigation_service.dart';
import 'package:quadro_platform/shared/routes/routes_constants.dart';
import 'package:quadro_platform/shared/widgets/registration_textField.dart';
import 'package:sizer/sizer.dart';

class ResetPassWordScreen extends StatelessWidget {
  ResetPassWordScreen({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController emailController2 = TextEditingController();
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
                'اعادة تعيين كلمة المرور',
                style: AppTextStyles.Mheading24Bold.copyWith(
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
            SizedBox(height: 2.5.h),
            RegistrationScreenTextField(
              controller: emailController2,
              keyBoardType: TextInputType.emailAddress,
              readOnly: false,
              title: 'اعد كتابة بريدك الالكتروني',
              hint: "",
            ),
            SizedBox(height: 2.5.h),
            SizedBox(height: 4.h),
            CustomElevatedButton(
              onPressed: () {
                if (emailController2.text != emailController.text) {
                  ToastService.sendScaffoldAlert(
                    msg:
                        'الرجاء تأكيد كتابة نفس البريد الالكتروني بشكل صحيح في الحقلين',
                    toastStatus: 'WARNING',
                    context: context,
                  );
                } else {
                  AuthServices.resetPassword(
                    context: context,
                    emailController: emailController.text.trim(),
                  );
                }
              },
              buttonTitle: 'اعادة التعيين',
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
