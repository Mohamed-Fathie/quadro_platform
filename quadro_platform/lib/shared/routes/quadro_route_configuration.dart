import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quadro_platform/common/view/logInLogic/log_in_logic.dart';
import 'package:quadro_platform/common/view/log_in_screen.dart';
import 'package:quadro_platform/common/view/registration_screen.dart';
import 'package:quadro_platform/shared/routes/routes_constants.dart';

class RouteGenerator {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RoutesConstants.login:
        return MaterialPageRoute(builder: (context) => const LogInScreen());
      case RoutesConstants.signUp:
        return MaterialPageRoute(builder: (context) => RegistrationScreen());
      case RoutesConstants.loginLogic:
       return PageTransition(
            child: const LogInLogic(), type: PageTransitionType.bottomToTop);

      default:
        return MaterialPageRoute(
            builder: (context) => Scaffold(
                  body: Center(
                    child: Text("Not found ${settings.name}"),
                  ),
                ));
    }
  }
}
