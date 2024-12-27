import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadro_platform/common/controller/provider/profile_data_provider.dart';
import 'package:quadro_platform/common/controller/services/auth_services.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:quadro_platform/constants/utils/textStyles.dart';
import 'package:sizer/sizer.dart';

class DriverAccountScreen extends StatefulWidget {
  DriverAccountScreen({super.key});

  @override
  State<DriverAccountScreen> createState() => _DriverAccountScreenState();
}

class _DriverAccountScreenState extends State<DriverAccountScreen> {
  final List accountButtons = [
    [CupertinoIcons.gear_alt_fill, 'الاعدادات'],
    [CupertinoIcons.person_2_fill, 'ادارة الحساب'],
    [CupertinoIcons.power, 'تسجيل الخروج'],
  ];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        context.read<ProfileDataProvider>().getProfileData();
      }
    });
  }

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
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              children: [
                Consumer<ProfileDataProvider>(
                  builder: (context, profileProvider, child) {
                    if (profileProvider.profileData == null) {
                      return Row(
                        children: [
                          SizedBox(
                            width: 70.w,
                            child: Text(
                              profileProvider.profileData!.name ??
                                  'مستخدم كوادرو',
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
                      );
                    } else {
                      return Row(
                        children: [
                          SizedBox(
                            width: 70.w,
                            child: Text(
                              profileProvider.profileData!.name ??
                                  'مستخدم كوادرو',
                              style: AppTextStyles.Mheading26Bold,
                            ),
                          ),
                          Container(
                            height: 18.w,
                            width: 18.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: black87),
                              image: DecorationImage(
                                image: NetworkImage(profileProvider
                                        .profileData!.profilePicUrl!) ??
                                    AssetImage(
                                        'assets/images/uberLogo/quadroLogo.png'),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
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
