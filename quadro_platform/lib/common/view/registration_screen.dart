// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quadro_platform/common/controller/services/auth_services.dart';
import 'package:quadro_platform/common/controller/services/image_services.dart';
import 'package:quadro_platform/common/controller/services/profile_data_crud_service.dart';
import 'package:quadro_platform/common/controller/services/toast_services.dart';
import 'package:quadro_platform/common/model/profile_data_model.dart';
import 'package:quadro_platform/constants/commonWidgets/custom_elevated_button.dart';
import 'package:quadro_platform/constants/constants.dart';
import 'package:quadro_platform/shared/widgets/registration_custom_password_field.dart';
import 'package:quadro_platform/shared/widgets/registration_textField.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:quadro_platform/constants/utils/textStyles.dart';
import 'package:quadro_platform/shared/routes/navigation_service.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

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
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController.text = auth.currentUser!.email!;
  }

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

  registerTowingDriver() async {
    if (profilePic == null) {
      ToastService.sendScaffoldAlert(
        msg: 'Select a Profile Pic',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (nameController.text.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'Enter your Name',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (mobileController.text.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'Enter your Mobile number',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (emailController.text.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'Enter your Email',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (vehicleBrandController.text.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'Enter the Vehicle Brand Name',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (vehicleModelController.text.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'Enter the vehicle model name',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (selectVehicleType == 'اختر نوع مركبتك') {
      ToastService.sendScaffoldAlert(
        msg: 'Select a vehicle type',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (vehicleRegistrationNumberController.text.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'Enter vehicle registration number',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (drivingLicenceNumberController.text.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'Enter your Driving license number',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (passwordController.text.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'Enter your Email',
        toastStatus: 'WARNING',
        context: context,
      );
    } else {
      AuthServices.registerUser(
          emailController: emailController,
          passwordController: passwordController,
          context: context);
      String profilePicURL = await ImageServices.uploadImageToFirebaseStorage(
          image: File(profilePic!.path), context: context);
      ProfileDataModel profileData = ProfileDataModel(
        profilePicUrl: profilePicURL,
        name: nameController.text.trim(),
        mobileNumber: mobileController.text.trim(),
        email: auth.currentUser!.email!,
        password: passwordController.text.trim(),
        userType: 'التسجيل كصاحب ساحبة',
        vehicleBrandName: vehicleBrandController.text.trim(),
        vehicleModel: vehicleModelController.text.trim(),
        vehicleType: selectVehicleType,
        vehicleRegistrationNumber:
            vehicleRegistrationNumberController.text.trim(),
        drivingLicenseNumber: drivingLicenceNumberController.text.trim(),
        registeredDateTime: DateTime.now(),
      );
      await ProfileDataCRUDServices.registerUserToDatabase(
          profileData: profileData, context: context);
    }
  }

  registerCustomer() async {
    if (profilePic == null) {
      ToastService.sendScaffoldAlert(
        msg: 'الرجاء اختيار صورة شخصية , عن طريق الضغط على الايقونة في الاعلى',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (nameController.text.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'Enter your Name',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (mobileController.text.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'Enter your Mobile number',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (emailController.text.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'Enter your Email',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (passwordController.text.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'Enter your Email',
        toastStatus: 'WARNING',
        context: context,
      );
    } else {
      AuthServices.registerUser(
          emailController: emailController,
          passwordController: passwordController,
          context: context);
      String profilePicURL = await ImageServices.uploadImageToFirebaseStorage(
          image: File(profilePic!.path), context: context);
      ProfileDataModel profileData = ProfileDataModel(
        profilePicUrl: profilePicURL,
        name: nameController.text.trim(),
        mobileNumber: mobileController.text.trim(),
        email: auth.currentUser!.email!,
        password: passwordController.text.trim(),
        userType: 'تسجيل كمستخدم عادي',
        registeredDateTime: DateTime.now(),
      );
      await ProfileDataCRUDServices.registerUserToDatabase(
          profileData: profileData, context: context);
    }
  }

  registerWorkShopPartner() async {
    if (profilePic == null) {
      ToastService.sendScaffoldAlert(
        msg: 'Select a Profile Pic',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (nameController.text.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'Enter your Name',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (mobileController.text.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'Enter your Mobile number',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (emailController.text.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'Enter your Email',
        toastStatus: 'WARNING',
        context: context,
      );
    } else if (passwordController.text.isEmpty) {
      ToastService.sendScaffoldAlert(
        msg: 'Enter your Email',
        toastStatus: 'WARNING',
        context: context,
      );
    } else {
      AuthServices.registerUser(
          emailController: emailController,
          passwordController: passwordController,
          context: context);
      String profilePicURL = await ImageServices.uploadImageToFirebaseStorage(
          image: File(profilePic!.path), context: context);
      ProfileDataModel profileData = ProfileDataModel(
        profilePicUrl: profilePicURL,
        name: nameController.text.trim(),
        mobileNumber: mobileController.text.trim(),
        email: auth.currentUser!.email!,
        password: passwordController.text.trim(),
        userType: 'التسجيل كصاحب ورشة',
        registeredDateTime: DateTime.now(),
      );
      await ProfileDataCRUDServices.registerUserToDatabase(
          profileData: profileData, context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 5.h),
          children: [
            InkWell(
              onTap: () async {
                final image =
                    await ImageServices.getImageFromGallery(context: context);
                if (image != null) {
                  setState(() {
                    profilePic = File(image.path);
                  });
                }
              },
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
                InkWell(
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
            onPressed: () async {
              setState(() {
                registrationButtonPressed = true;
              });
              await registerCustomer();
            },
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
            onPressed: () async {
              setState(() {
                registrationButtonPressed = true;
              });
              await registerWorkShopPartner();
            },
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
          onPressed: () async {
            setState(() {
              registrationButtonPressed = true;
            });
            await registerTowingDriver();
          },
          child: registrationButtonPressed == true
              ? CircularProgressIndicator(
                  color: teal,
                )
              : Text(
                  'تسجيل',
                  style: AppTextStyles.Mbody14Bold.copyWith(color: white),
                ),
        ),
      ],
    );
  }
}
