import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quadro_platform/common/view/logInLogic/log_in_logic.dart';
import 'package:quadro_platform/common/view/log_in_screen.dart';
import 'package:quadro_platform/common/view/registration_screen.dart';
import 'package:quadro_platform/features/workshop_authentication/cubit/authbloc_cubit.dart';
import 'package:quadro_platform/features/workshop_authentication/veiws/trade_license.dart';
import 'package:quadro_platform/features/workshop_authentication/veiws/workshop_authenitication_page.dart';
import 'package:quadro_platform/features/workshop_authentication/veiws/workshop_registeration_page.dart';
import 'package:quadro_platform/features/workshop_bottom_nav_bar/workshop_nav_bar.dart';
import 'package:quadro_platform/shared/routes/routes_constants.dart';
import 'package:quadro_platform/user/view/bottomNavBars/user_bottom_navbar.dart';
import 'package:quadro_platform/user/view/riderHomeScreen/rider_home_screen.dart';

import '../../features/request_details_screen/veiw/details_screen_page.dart';
import '../../features/sending_offers/veiw/sending_offer_page.dart';
import '../../features/workshop_main_screen/models/maintenance_request_data_model.dart';

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
      case RoutesConstants.requestDetails:
        final request = settings.arguments as MaintenanceRequestDomainModel;
        return PageTransition(
            child: DetailsScreenPage(
              request: request,
            ),
            type: PageTransitionType.bottomToTop);
      case RoutesConstants.sendOffer:
        final request = settings.arguments as MaintenanceRequestDomainModel;

        return PageTransition(
            child: SendingOfferPage(
              request: request,
            ),
            type: PageTransitionType.bottomToTop);
      case RoutesConstants.bottomNavBar:
        return PageTransition(
            child: UserBottomNavBar(), type: PageTransitionType.bottomToTop);
      case RoutesConstants.workshopBottomNavBar:
        return MaterialPageRoute(builder: (context) => const WorkshopNavBar());
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
