import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:quadro_platform/features/user/repository/user_repository.dart';
import 'package:quadro_platform/features/workshop_bottom_nav_bar/workshop_screens.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/maintenance_requests_repo.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/offers_repository.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/repository_manager.dart';
import 'package:quadro_platform/features/workshop_profile/repository/reviews_repository.dart';
import 'package:quadro_platform/shared/utils/constans/helper_functions.dart';

import '../workshop_authentication/repository/workshop_repo.dart';

import 'package:flutter/foundation.dart';

import 'workshop_railway.dart';
// Import your repositories, screens, and other dependencies.

class WorkshopNavBar extends StatelessWidget {
  const WorkshopNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<WorkshopRepository>(
          create: (_) => WorkshopRepository(),
        ),
        RepositoryProvider<RepositoryManager>(
          create: (_) => RepositoryManager(
            reviewsRepository: ReviewsRepository(),
            maintenanceRequestsRepository: MaintenanceRequestsRepository(),
            offersRepository: OffersRepository(),
            userRepository: UserRepository(),
            workshopRepository: WorkshopRepository(),
          ),
        ),
      ],
      // Use kIsWeb to select the appropriate widget
      child: kIsWeb ? const WorkshopNavBarWeb() : const WorkshopNavBarMobile(),
    );
  }
}

class WorkshopNavBarMobile extends StatelessWidget {
  const WorkshopNavBarMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = QhelperFucntions.isDarkMode(context);
    return PersistentTabView(
      screenTransitionAnimation: const ScreenTransitionAnimation(
        duration: Duration(milliseconds: 700),
        curve: Curves.ease,
      ),
      controller: WorkshopScreens().controller,
      tabs: WorkshopScreens().buildScreens(),
      navBarBuilder: (navBarConfig) => Style8BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(
          color: isDark ? const Color(0xFF1F1929) : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      backgroundColor: Colors.grey.shade900,
      navBarHeight: kBottomNavigationBarHeight,
    );
  }
}
