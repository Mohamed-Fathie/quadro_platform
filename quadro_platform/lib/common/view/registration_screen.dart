import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quadro_platform/constants/commonWidgets/custom_elevated_button.dart';
import 'package:quadro_platform/constants/commonWidgets/registration_custom_password_field.dart';
import 'package:quadro_platform/constants/commonWidgets/registration_textField.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:quadro_platform/constants/utils/textStyles.dart';
import 'package:quadro_platform/shared/routes/navigation_service.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController mobileController = TextEditingController();

  TextEditingController vehicleModelController = TextEditingController();

  TextEditingController vehicleBrandController = TextEditingController();

  TextEditingController vehicleRegistrationNumberController =
      TextEditingController();

  TextEditingController drivingLicenceNumberController =
      TextEditingController();
  String? email;
  String? password;
  File? profilePic;

  String selectVehicleType = 'اختر نوع مركبتك';

  List<String> vehicleTypes = [
    'اختر نوع مركبتك',
    'نقل خفيف',
    'نقل متوسط',
    'نقل ثقيل'
  ];

  String userType = 'زبون';

  bool registrationButtonPressed = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    mobileController.dispose();
    vehicleModelController.dispose();
    vehicleBrandController.dispose();
    vehicleRegistrationNumberController.dispose();
    drivingLicenceNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 5.h),
          children: [
            InkWell(
              onTap: () {},
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
            RegistrationScreenTextField(
              controller: nameController,
              hint: '',
              title: 'الاسم',
              keyBoardType: TextInputType.name,
              readOnly: false,
            ),
            SizedBox(height: 2.5.h),
            RegistrationScreenTextField(
              controller: emailController,
              keyBoardType: TextInputType.emailAddress,
              readOnly: false,
              title: 'البريد الالكتروني',
              hint: "",
            ),
            SizedBox(height: 2.5.h),
            RegistrationPasswordTextField(
              controller: passwordController,
              hint: '',
              keyBoardType: TextInputType.visiblePassword,
              readOnly: false,
              title: 'كلمة المرور',
            ),
            SizedBox(height: 0.5.h),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "استخدم 8 احرف او اكثر مع مزيج من الارقام والرموز",
                style: AppTextStyles.Mbody14Bold.copyWith(color: grey),
              ),
            ),
            SizedBox(height: 2.h),
            SizedBox(height: 1.h),
            RegistrationScreenTextField(
              controller: mobileController,
              hint: '',
              keyBoardType: TextInputType.phone,
              readOnly: false,
              title: 'رقم الهاتف',
            ),
            SizedBox(height: 4.h),
            selectUserType('تسجيل كمستخدم عادي'),
            SizedBox(height: 2.h),
            selectUserType('التسجيل كصاحب ساحبة'),
            SizedBox(height: 2.h),
            selectUserType('التسجيل كصاحب ورشة'),
            SizedBox(height: 4.h),
            
            Builder(
              builder: (context) {
                if (userType == 'التسجيل كصاحب ورشة') {
                  return workShopPartner();
                } else if (userType == 'التسجيل كصاحب ساحبة') {
                  return towingDriver();
                } else {
                  return customer();
                }
              },
            ),
            SizedBox(
              height: 2.5.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => NavigationService().goBack(),
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
            ),
          ],
        ),
      ),
    );
  }

  selectUserType(String updateUserType) {
    return InkWell(
      onTap: () {
        if (registrationButtonPressed == false) {
          setState(() {
            userType = updateUserType;
          });
        }
      },
      child: Row(
        children: [
          Container(
            height: 2.5.h,
            width: 2.5.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                10.sp,
              ),
              border: Border.all(
                color: userType == updateUserType ? teal : grey,
              ),
            ),
            child: Icon(
              userType == updateUserType ? Icons.check : Icons.check,
              color: userType == updateUserType ? teal : transparent,
              size: 2.4.h,
            ),
          ),
          SizedBox(
            width: 3.w,
          ),
          Text(
            updateUserType,
            style: AppTextStyles.Mbody16Bold.copyWith(
                color: userType == updateUserType ? teal : grey),
          ),
        ],
      ),
    );
  }

  customer() {
    return Column(
      children: [
        CustomElevatedButton(
            buttonTitle: 'تسجيل كمستخدم عادي',
            fontSize: 16,
            fontColor: white,
            onPressed: authHandler,
            child: registrationButtonPressed == true
                ? CircularProgressIndicator(
                    color: teal,
                  )
                : Text(
                    'تسجيل',
                    style: AppTextStyles.Mbody14Bold.copyWith(color: white),
                  )),
      ],
    );
  }

  workShopPartner() {
    return Column(
      children: [
        CustomElevatedButton(
            buttonTitle: 'التسجيل كصاحب ورشة',
            fontSize: 16,
            fontColor: white,
            onPressed: () {},
            child: registrationButtonPressed == true
                ? CircularProgressIndicator(
                    color: teal,
                  )
                : Text(
                    'تسجيل',
                    style: AppTextStyles.Mbody14Bold.copyWith(color: white),
                  )),
      ],
    );
  }

  towingDriver() {
    return Column(
      children: [
        RegistrationScreenTextField(
          controller: vehicleBrandController,
          keyBoardType: TextInputType.name,
          readOnly: false,
          title: 'نوع شركة الساحبة',
          hint: "",
        ),
        SizedBox(height: 2.5.h),
        RegistrationScreenTextField(
          controller: vehicleModelController,
          keyBoardType: TextInputType.name,
          readOnly: false,
          title: 'موديل الساحبة',
          hint: "",
        ),
        SizedBox(height: 2.5.h),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'نوع الساحبة',
            style: AppTextStyles.Mbody16Bold.copyWith(color: teal),
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.sp),
            border: Border.all(color: grey),
          ),
          child: DropdownButton(
              isExpanded: true,
              value: selectVehicleType,
              underline: const SizedBox(),
              icon: const Icon(Icons.keyboard_arrow_down),
              items: vehicleTypes
                  .map(
                    (items) => DropdownMenuItem(
                      value: items,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          items,
                          style:
                              AppTextStyles.Mbody18Bold.copyWith(color: teal),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectVehicleType = value!;
                });
              }),
        ),
        SizedBox(height: 2.5.h),
        RegistrationScreenTextField(
          controller: vehicleRegistrationNumberController,
          keyBoardType: TextInputType.name,
          readOnly: false,
          title: 'رقم هيكل الساحبة',
          hint: "",
        ),
        SizedBox(height: 2.5.h),
        RegistrationScreenTextField(
          controller: drivingLicenceNumberController,
          keyBoardType: TextInputType.name,
          readOnly: false,
          title: 'رقم رخصة القيادة',
          hint: "",
        ),
        SizedBox(height: 2.5.h),
        CustomElevatedButton(
            buttonTitle: 'التسجيل كصاحب ساحبة',
            fontSize: 16,
            fontColor: white,
            onPressed: () {},
            child: registrationButtonPressed == true
                ? CircularProgressIndicator(
                    color: teal,
                  )
                : Text(
                    'تسجيل',
                    style: AppTextStyles.Mbody14Bold.copyWith(color: white),
                  )),
      ],
    );
  }

  Future<UserCredential> registerUser() async {
    var auth = FirebaseAuth.instance;
    UserCredential user = await auth.createUserWithEmailAndPassword(
        email: emailController.text, password: passwordController.text);
    log(passwordController.text);
    return user;
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

authHandler() async {
              try {
                UserCredential user = await registerUser();
                showSnackBar(context, ' تم التسجيل بنجاح');
                await Future.delayed(const Duration(seconds: 3));
                NavigationService().goBack();
                print(user.user!.displayName);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  showSnackBar(context,
                      'يجب ان تكون كلمة السر مكونة من 8 احرف او اكثر مع مزيج من الارقام والرموز ');
                } else if (e.code == 'email-already-in-use') {
                  showSnackBar(context, 'هذا الحساب مسجل مسبقا!');
                } else if (e.code == 'invalid-email') {
                  showSnackBar(
                      context, 'الرجاء ادخال البريد الالكتروني بشكل صحيح');
                }
              } catch (e) {
                showSnackBar(context, 'There was an error, please try again.');
              }
            }
}
