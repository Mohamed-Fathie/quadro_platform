import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:quadro_platform/constants/utils/textStyles.dart';
import 'package:sizer/sizer.dart';

class ActiviytRecords extends StatelessWidget {
  const ActiviytRecords({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      
        itemCount: 10,
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 1.7.h),
            decoration: BoxDecoration(
              border: Border(
                bottom:
                    BorderSide(color: index == 9 ? transparent : greyShade3),
              ),
            ),
            height: 17.6.h,
            width: 94.w,
            child: Row(
              children: [
                Container(
                  
                  padding:
                      EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.w),
                  height: 8.h,
                  width: 8.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.sp),
                    color: white,
                    image: const DecorationImage(
                      image: AssetImage(
                        'assets/images/vehicle/towingTruck.png',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'zawiah Street rd',
                        style: AppTextStyles.Mbody16Bold,
                        maxLines: 2,
                      ),
                      Text(
                        DateFormat('dd MMM, kk:mm a').format(
                          DateTime.now(),
                        ),style: AppTextStyles.Mbody14Bold.copyWith(color: black87) ,
                      ),
                      Text('150:00',style:AppTextStyles.Mbody14Bold.copyWith(color: black87) ,)
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
  }
}