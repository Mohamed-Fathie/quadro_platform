import 'package:flutter/material.dart';
import 'package:quadro_platform/common/controller/services/auth_services.dart';
import 'package:quadro_platform/constants/utils/colors.dart';

class LogInLogic extends StatefulWidget {
  const LogInLogic({super.key});

  @override
  State<LogInLogic> createState() => _LogInLogicState();
}

class _LogInLogicState extends State<LogInLogic> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AuthServices.checkAuthenticationAndNavigate(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: const Center(
        child: Image(
          image: AssetImage('assets/images/logos/Qadro2.png'),
        ),
      ),
    );
  }
}
