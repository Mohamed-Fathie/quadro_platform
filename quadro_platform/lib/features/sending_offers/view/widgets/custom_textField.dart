import 'package:flutter/material.dart';

import '../../../../shared/utils/constans/colors.dart';

typedef OnchangedCallback = void Function(String? va);

class CustomTextfield extends StatelessWidget {
  final String? errorMessage;
  final String prefixIcons;
  final String hint;
  final TextEditingController controller;
  final OnchangedCallback onchangedCallback;
  const CustomTextfield(
      {super.key,
      this.errorMessage,
      required this.prefixIcons,
      required this.hint,
      required this.controller,
      required this.onchangedCallback});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onchangedCallback,
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(),
      textDirection: TextDirection.rtl,
      decoration: InputDecoration(
        errorText: errorMessage,
        errorStyle: const TextStyle(fontSize: 15),
        suffixIcon: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            prefixIcons,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.apply(color: Qcolors.primarycolor),
          ),
        ),
        hintTextDirection: TextDirection.rtl,
        hintText: hint,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Qcolors.primarycolor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Qcolors.primarycolor,
          ),
        ),
      ),
    );
  }
}
