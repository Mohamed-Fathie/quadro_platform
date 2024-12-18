import 'package:flutter/material.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:quadro_platform/constants/utils/textStyles.dart';
import 'package:sizer/sizer.dart';

class TripRecords extends StatelessWidget {
  const TripRecords({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 0.5.h),
          padding: EdgeInsets.symmetric(
            vertical: 0.5.h,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 3.h,
                backgroundColor: greyShade3,
                child: Icon(
                  Icons.location_on,
                  color: black,
                ),
              ),
              SizedBox(width: 5.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'تحديد الموقع',
                      style: AppTextStyles.Mbody16Bold,
                    ),
                    Text(
                      'اضغط هنا لتحديد الموقع',
                      style:
                          AppTextStyles.Msmall12Bold.copyWith(color: black38),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 3.w,
              ),
              Icon(
                Icons.arrow_forward_ios_sharp,
                color: grey,
                size: 15.sp,
              ),
            ],
          ),
        );
      },
    );
  }
}
