import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quadro_platform/shared/widgets/trip_records.dart';
import 'package:quadro_platform/shared/widgets/where_to.dart';
import 'package:quadro_platform/constants/utils/textStyles.dart';
import 'package:quadro_platform/user/view/pichupAndDropLocation/pickup_drop_location_screen.dart';
import 'package:sizer/sizer.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'طلب ساحبة',
          style: AppTextStyles.Mheading20Bold,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: 3.w,
          vertical: 2.h,
        ),
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                    child: PickupAndDropLocationScreen(),
                    type: PageTransitionType.leftToRight),
              );
            },
            child: const WhereTo(),
          ),
          SizedBox(
            height: 1.h,
          ),
          const TripRecords(),
          SizedBox(
            height: 1.h,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 1.h),
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 1.5.w),
            height: 40.h,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Towing-amico (1).png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
