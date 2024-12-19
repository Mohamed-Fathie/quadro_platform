import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quadro_platform/common/view/logInLogic/log_in_logic.dart';
import 'package:quadro_platform/common/view/log_in_screen.dart';
import 'package:quadro_platform/common/view/registration_screen.dart';
import 'package:quadro_platform/features/workshop_authentication/cubit/authbloc_cubit.dart';
import 'package:quadro_platform/features/workshop_authentication/veiws/trade_license.dart';
import 'package:quadro_platform/features/workshop_authentication/veiws/workshop_authenitication_page.dart';
import 'package:quadro_platform/features/workshop_authentication/veiws/workshop_registeration_page.dart';
import 'package:quadro_platform/shared/routes/routes_constants.dart';

class RouteGenerator {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RoutesConstants.login:
        return MaterialPageRoute(builder: (context) => const LogInScreen());
      case RoutesConstants.signUp:
        return MaterialPageRoute(
            builder: (context) => const RegistrationScreen());
      case RoutesConstants.licens:
        final contextcubit = settings.arguments as WorkshopAuthbloc;
        return MaterialPageRoute(
            builder: (context) => TradeLicensePage(
                  licenscubit: contextcubit,
                ));
      case RoutesConstants.workshopdetails:
        final contextcubit = settings.arguments as WorkshopAuthbloc;
        return PageTransition(
            child: WorkshopDetainsPage(
              detailscubit: contextcubit,
            ),
            type: PageTransitionType.bottomToTop);

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
