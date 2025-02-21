import 'package:flutter/material.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:quadro_platform/constants/utils/textStyles.dart';
import 'package:sizer/sizer.dart';

class WhereTo extends StatelessWidget {
  const WhereTo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.sp), color: greyShade3),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: Colors.black87,
            size: 4.h,
          ),
          SizedBox(
            width: 10.w,
          ),
          Text(
            'حدد موقعك ووجهتك!',
            style: AppTextStyles.Mbody18Bold,
            textDirection: TextDirection.rtl,
          )
        ],
      ),
    );
  }
}
