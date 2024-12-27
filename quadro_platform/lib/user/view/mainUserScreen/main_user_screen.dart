import 'package:flutter/material.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:quadro_platform/constants/utils/textStyles.dart';
import 'package:quadro_platform/features/workshop_authentication/veiws/id_screen.dart';
import 'package:quadro_platform/shared/routes/navigation_service.dart';
import 'package:quadro_platform/shared/routes/routes_constants.dart';
import 'package:sizer/sizer.dart';

class MainUserScreen extends StatelessWidget {
  const MainUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quadro',
          style: AppTextStyles.heading20Bold,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 3.w,
          vertical: 2.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'مرحبا مؤمن',
              style: AppTextStyles.Mheading20Bold.copyWith(color: grey),
            ),
            SizedBox(
              height: 0.5.h,
            ),
            Text(
              'كيف نقدروا نخدموك؟',
              style: AppTextStyles.Mheading24Bold.copyWith(color: teal),
            ),
            SizedBox(
              height: 2.h,
            ),
            InkWell(
              onTap: () {
                NavigationService().routeTo(RoutesConstants.bottomNavBar);
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 1.h),
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 1.5.w),
                height: 18.5.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.sp),
                  gradient: LinearGradient(
                    colors: [
                      teal,
                      teal2,
                      teal3,
                    ],
                    begin: Alignment.centerRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/icons/icons8-tow-truck-50.png'),
                    SizedBox(
                      width: 3.w,
                    ),
                    Text(
                      'طلب خدمة سحب سيارة',
                      style:
                          AppTextStyles.Mheading22Bold.copyWith(color: white),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return IdScreen();
                },),);
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 1.h),
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 1.5.w),
                height: 18.5.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.sp),
                  gradient: LinearGradient(
                    colors: [
                      teal,
                      teal2,
                      teal3,
                    ],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/icons/icons8-car-50.png'),
                    SizedBox(
                      width: 3.w,
                    ),
                    Text(
                      'طلب خدمة صيانة سيارة',
                      style:
                          AppTextStyles.Mheading22Bold.copyWith(color: white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
