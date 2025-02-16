import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GradientCard extends StatelessWidget {
  final String text;
  final String? imagePath;
  final VoidCallback onTap;

  const GradientCard({
    super.key,
    required this.text,
    this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1.h),
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 1.5.w),
        height: 18.5.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.sp),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF0078A3),
              Color(0xFF03AABF),
              Color(0xFF0EDED2),
            ],
            begin: Alignment.centerRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            if (imagePath != null) ...[
              Image.asset(
                imagePath!,
                height: 10.h,
              ),
              SizedBox(width: 5.w),
            ],
          ],
        ),
      ),
    );
  }
}
