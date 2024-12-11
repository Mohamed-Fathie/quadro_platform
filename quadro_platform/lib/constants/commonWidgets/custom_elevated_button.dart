import 'package:flutter/material.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:sizer/sizer.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({required this.buttonTitle, super.key, required this.fontSize, required this.fontColor});
  final String buttonTitle;
  final int fontSize;
  final Color fontColor;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(double.infinity, 57),
          backgroundColor: teal),
      child: Text(
        buttonTitle,
        style: TextStyle(
          fontFamily: 'Madhani-Arabic',
          fontWeight: FontWeight.bold,
          fontSize: fontSize.sp,
          color: fontColor,
        ),
      ),
    );
  }
}
