import 'package:flutter/material.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:quadro_platform/constants/utils/textStyles.dart';
import 'package:sizer/sizer.dart';

class RegistrationScreenTextField extends StatelessWidget {
  const RegistrationScreenTextField(
      {super.key,
      required this.controller,
      required this.title,
      required this.hint,
      required this.readOnly,
      required this.keyBoardType});
  final TextEditingController controller;
  final String title;
  final String hint;
  final bool readOnly;
  final TextInputType keyBoardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 1.w),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              title,
              style: AppTextStyles.Mbody16Bold.copyWith(color: teal),
            ),
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        TextFormField(
          controller: controller,
          cursorColor: black,
          style: AppTextStyles.Mbody18Bold,
          keyboardType: keyBoardType,
          readOnly: readOnly,
          decoration: InputDecoration(
              filled: true,
              fillColor: txtfld,
              hintText: hint,
              hintStyle: AppTextStyles.textFieldTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: teal,
                ),
              ),
              // focusedBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(12),
              //   borderSide: BorderSide(
              //     color: teal,
              //   ),
              // ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: grey,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: white,
                ),
              )),
        ),
      ],
    );
  }
}
