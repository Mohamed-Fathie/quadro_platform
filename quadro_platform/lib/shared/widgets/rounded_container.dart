import 'package:flutter/material.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:sizer/sizer.dart';

class RoundedContainer extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  const RoundedContainer(
      {super.key,
      required this.child,
      required this.width,
      required this.height});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        width: width,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Qcolors.buttonbackground,
        ),
        padding: EdgeInsets.all(3.w),
        child: child,
      ),
    );
  }
}
