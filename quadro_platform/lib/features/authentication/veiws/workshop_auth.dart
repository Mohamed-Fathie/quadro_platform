import 'package:flutter/material.dart';
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
      body: const Column(
        children: [Text("قم برفع بطاقة هويتك من اجل المتابعة :")],
      ),
    );
  }
}
