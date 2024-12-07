import 'package:flutter/material.dart';
import 'package:quadro_platform/constants/commonWidgets/trip_records.dart';
import 'package:quadro_platform/constants/commonWidgets/where_to.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:quadro_platform/constants/utils/textStyles.dart';
import 'package:sizer/sizer.dart';

class RiderHomeScreen extends StatelessWidget {
  const RiderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quadro',
          style: AppTextStyles.heading20Bold,
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
          InkWell(onTap: () {}, child: const WhereTo()),
          SizedBox(
            height: 1.h,
          ),
          const TripRecords(),
          SizedBox(
            height: 6.h,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 1.h),
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 1.5.w),
            height: 40.h,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Towing-amico.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
