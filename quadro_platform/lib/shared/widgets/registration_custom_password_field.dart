import 'package:flutter/material.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:quadro_platform/constants/utils/textStyles.dart';
import 'package:sizer/sizer.dart';

class RegistrationPasswordTextField extends StatefulWidget {
  const RegistrationPasswordTextField(
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
  State<RegistrationPasswordTextField> createState() =>
      _RegistrationPasswordTextFieldState();
}

class _RegistrationPasswordTextFieldState
    extends State<RegistrationPasswordTextField> {
  bool _isObscured = true;

  _RegistrationPasswordTextFieldState();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 1.w),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              widget.title,
              style: AppTextStyles.Mbody16Bold.copyWith(color: teal),
            ),
          ),
        ), SizedBox(
          height: 1.h,),
        TextFormField(
          controller: widget.controller,
          cursorColor: black,
          style: AppTextStyles.Mbody18Bold,
          keyboardType: widget.keyBoardType,
          readOnly: widget.readOnly,
          obscureText: _isObscured,
          decoration: InputDecoration(
            filled: true,
            fillColor: txtfld,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: white),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: grey,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: teal,
              ),
            ),
            suffixIcon: IconButton(
              color: teal,
              icon: Icon(
                _isObscured ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _isObscured = !_isObscured;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
