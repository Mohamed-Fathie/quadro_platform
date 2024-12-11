import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:quadro_platform/constants/utils/textStyles.dart';
import 'package:sizer/sizer.dart';

class UserAccountScreen extends StatelessWidget {
  UserAccountScreen({super.key});
  final List accountButtons = [
    [CupertinoIcons.gear_alt_fill, 'الاعدادات'],
    [CupertinoIcons.person_2_fill, 'ادارة الحساب'],
    [CupertinoIcons.power, 'تسجيل الخروج'],
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 70.w,
                      child: Text(
                        'عبدالمؤمن حسين محمد',
                        style: AppTextStyles.Mheading26Bold,
                      ),
                    ),
                    Container(
                      height: 18.w,
                      width: 18.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: black87),
                        image: const DecorationImage(
                          image: AssetImage(
                              'assets/images/uberLogo/quadroLogo.png'),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 3.h,
            ),
            Divider(
              color: greyShade3,
              thickness: 0.3.h,
            ),
            ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: accountButtons.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    child: Row(
                      children: [
                        Icon(
                          accountButtons[index][0],
                          color: black,
                          size: 3.h,
                        ),
                        SizedBox(
                          width: 7.w,
                        ),
                        Text(
                          accountButtons[index][1],
                          style: AppTextStyles.Mbody16Bold,
                        )
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
