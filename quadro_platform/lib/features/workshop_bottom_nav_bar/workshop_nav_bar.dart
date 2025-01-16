import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:quadro_platform/features/user/repository/user_repository.dart';
import 'package:quadro_platform/features/workshop_bottom_nav_bar/workshop_screens.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/maintenance_requests_repo.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/offers_repository.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/repository_manager.dart';
import 'package:quadro_platform/features/workshop_profile/repository/reviews_repository.dart';
import 'package:quadro_platform/shared/utils/constans/helper_functions.dart';

import '../workshop_authentication/repository/workshop_repo.dart';

class WorkshopNavBar extends StatelessWidget {
  const WorkshopNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = QhelperFucntions().isDarkMode(context);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<WorkshopRepository>(
          create: (context) => WorkshopRepository(),
        ),
        RepositoryProvider<RepositoryManager>(
          create: (context) => RepositoryManager(
              reviewsRepository: ReviewsRepository(),
              maintenanceRequestsRepository: MaintenanceRequestsRepository(),
              offersRepository: OffersRepository(),
              userRepository: UserRepository(),
              workshopRepository: WorkshopRepository()),
        )
      ],
      child: PersistentTabView(
        screenTransitionAnimation: const ScreenTransitionAnimation(
          duration: Duration(milliseconds: 700),
          curve: Curves.ease,
        ),
        controller: WorkshopScreens().controller,
        tabs: WorkshopScreens().buildScreens(),
        navBarBuilder: (navBarConfig) => Style8BottomNavBar(
          navBarConfig: navBarConfig,
          navBarDecoration: NavBarDecoration(
            color: isDark ? Color(0xFF1F1929) : white,
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
        ),
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen on a non-scrollable screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        backgroundColor: Colors.grey.shade900,
        navBarHeight: kBottomNavigationBarHeight,
      ),
    );
  }
}
