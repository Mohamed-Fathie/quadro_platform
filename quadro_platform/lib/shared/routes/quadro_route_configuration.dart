import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quadro_platform/common/view/logInLogic/log_in_logic.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quadro_platform/common/view/logInLogic/log_in_logic.dart';
import 'package:quadro_platform/common/view/log_in_screen.dart';
import 'package:quadro_platform/common/view/registration_screen.dart';
import 'package:quadro_platform/features/workshop_authentication/cubit/authbloc_cubit.dart';
import 'package:quadro_platform/features/workshop_authentication/models/workshop_user.dart';
import 'package:quadro_platform/features/workshop_authentication/views/trade_license.dart';
import 'package:quadro_platform/features/workshop_authentication/views/workshop_authenitication_page.dart';
import 'package:quadro_platform/features/workshop_authentication/views/workshop_registeration_page.dart';
import 'package:quadro_platform/features/workshop_bottom_nav_bar/workshop_nav_bar.dart';
import 'package:quadro_platform/shared/routes/routes_constants.dart';
import 'package:quadro_platform/user/view/bottomNavBars/user_bottom_navbar.dart';
import 'package:quadro_platform/user/view/riderHomeScreen/rider_home_screen.dart';

import '../../common/view/reset_password_screen.dart';
import '../../features/google_map/views/workshop_location_map.dart';
import '../../features/request_details_screen/veiw/details_screen_page.dart';
import '../../features/sending_offers/view/sending_offer_page.dart';
import '../../features/workshop_main_screen/models/maintenance_request_data_model.dart';
import '../../features/workshop_profile/view/workshop_profile_page.dart';
import '../../user/view/maintenance_request/views/maintenance_request_page.dart';
import '../../user/view/workshop_search/views/workshop_search_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RoutesConstants.login:
        return _materialRoute(const LogInScreen());
      case RoutesConstants.maintenanceRequest:
        final workshop = settings.arguments;
        if (workshop is! Workshop) return _errorRoute("invalid arg");
        return _materialRoute(MaintenanceRequestPage(
          workshop: workshop,
        ));
      case RoutesConstants.workshopBottomNavBar:
        return _materialRoute(const WorkshopNavBar());
      case RoutesConstants.workshopLocationMap:
        return _materialRoute(const WorkshopLocationMapPage());
      case RoutesConstants.workshopSearch:
        return _materialRoute(const WorkshopSearchPage());
      case RoutesConstants.workshoProfile:
        final workshop = settings.arguments;
        if (workshop is! Map<String, dynamic>) {
          return _errorRoute("Invalid arguments for ${settings.name}");
        }
        return _pageTransition(
          WorkshopProfilePage(
            workshop: workshop["workshop"],
            requestType: workshop["requestType"],
          ),
          PageTransitionType.bottomToTop,
        );
      case RoutesConstants.signUp:
        return _materialRoute(const RegistrationScreen());
      case RoutesConstants.workshopRegistration:
        return _materialRoute(const WorkshopRegisterationPage());

      case RoutesConstants.licens:
        final contextCubit = settings.arguments;
        if (contextCubit is! WorkshopAuthbloc) {
          return _errorRoute("Invalid arguments for ${settings.name}");
        }
        return _materialRoute(TradeLicensePage(licenscubit: contextCubit));

      case RoutesConstants.workshopdetails:
        final contextCubit = settings.arguments;
        if (contextCubit is! WorkshopAuthbloc) {
          return _errorRoute("Invalid arguments for ${settings.name}");
        }
        return _pageTransition(
          WorkshopDetainsPage(detailscubit: contextCubit),
          PageTransitionType.bottomToTop,
        );

      case RoutesConstants.loginLogic:
        return _pageTransition(
          const LogInLogic(),
          PageTransitionType.bottomToTop,
        );

      case RoutesConstants.requestDetails:
        final argument = settings.arguments;
        if (argument is! Map<String, dynamic>) {
          return _errorRoute("Invalid arguments for ${settings.name}");
        }

        return _pageTransition(
          DetailsScreenPage(
            argument: argument,
          ),
          PageTransitionType.bottomToTop,
        );

      case RoutesConstants.sendOffer:
        final request = settings.arguments;
        if (request is! MaintenanceRequestDomainModel) {
          return _errorRoute("Invalid arguments for ${settings.name}");
        }
        return _pageTransition(
          SendingOfferPage(request: request),
          PageTransitionType.bottomToTop,
        );

      case RoutesConstants.bottomNavBar:
        return _pageTransition(
          UserBottomNavBar(),
          PageTransitionType.bottomToTop,
        );

      case RoutesConstants.resetPassWordScreen:
        return _pageTransition(
          ResetPassWordScreen(),
          PageTransitionType.bottomToTop,
        );

      default:
        return _errorRoute("Route not found: ${settings.name}");
    }
  }

  // Helper method for MaterialPageRoute
  static MaterialPageRoute _materialRoute(Widget child) {
    return MaterialPageRoute(builder: (context) => child);
  }

  // Helper method for PageTransition
  static PageTransition _pageTransition(Widget child, PageTransitionType type) {
    return PageTransition(child: child, type: type);
  }

  // Helper method for error route
  static MaterialPageRoute _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }
}
