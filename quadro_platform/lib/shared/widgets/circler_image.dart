import 'package:flutter/material.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:sizer/sizer.dart';

typedef ImagePickerCallback = void Function();

class CirclerImage extends StatelessWidget {
  final String imagePath;
  final ImagePickerCallback editting;
  const CirclerImage(
      {super.key, required this.imagePath, required this.editting});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 18.w,
        width: 18.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: black87),
          image: DecorationImage(
            fit: BoxFit.contain,
            image: AssetImage(imagePath),
          ),
        ),
      ),
    );
  }
}
