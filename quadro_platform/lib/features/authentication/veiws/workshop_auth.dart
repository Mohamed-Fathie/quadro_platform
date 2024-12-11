import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';

class IdentityAuth extends StatelessWidget {
  const IdentityAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "توثيق الحساب",
          style: Theme.of(context).textTheme.headlineMedium?.apply(
                color: Qcolors.primarycolor,
              ),
        ),
      ),
    );
  }
}
