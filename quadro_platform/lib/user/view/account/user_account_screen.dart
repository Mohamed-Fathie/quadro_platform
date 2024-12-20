import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quadro_platform/common/controller/services/auth_services.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:quadro_platform/constants/utils/textStyles.dart';
import 'package:quadro_platform/shared/widgets/row_account_shape.dart';
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
        appBar: AppBar(
        title: Text(
          'الحساب',
          style: AppTextStyles.Mheading20Bold,
        ),
      ),
        body: Column(
          children: [
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
              children: const [
                RowHeader(),
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
                  return InkWell(
                    onTap: () {
                      if (index == (accountButtons.length) - 1) {
                        AuthServices.logOutUser(context);
                      }
                    },
                    child: Container(
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
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
