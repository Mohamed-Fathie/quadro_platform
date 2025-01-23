import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:quadro_platform/user/view/bottomNavBars/main_bottom_navbar/user_main_nav_bar_screens.dart';

import '../../../../features/user/repository/user_repository.dart';
import '../../../../features/workshop_authentication/repository/workshop_repo.dart';
import '../../../../features/workshop_main_screen/repository/maintenance_requests_repo.dart';
import '../../../../features/workshop_main_screen/repository/offers_repository.dart';
import '../../../../features/workshop_main_screen/repository/repository_manager.dart';
import '../../../../features/workshop_profile/repository/reviews_repository.dart';
import '../../../../shared/utils/constans/helper_functions.dart';

class MainBottomNavbar extends StatelessWidget {
  const MainBottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = QhelperFucntions().isDarkMode(context);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>(
          create: (context) => UserRepository(),
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
        controller: UserMainNavBarScreens().controller,
        tabs: UserMainNavBarScreens().buildScreens(),
        navBarBuilder: (navBarConfig) => Style8BottomNavBar(
          navBarConfig: navBarConfig,
          navBarDecoration: NavBarDecoration(
            color: isDark ? const Color(0xFF1F1929) : Colors.white,
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

// ignore: must_be_immutable
// class MainBottomNavBar extends StatefulWidget {
//   MainBottomNavBar({super.key});

//   @override
//   State<MainBottomNavBar> createState() => _MainBottomNavBarState();
// }

// class _MainBottomNavBarState extends State<MainBottomNavBar> {
//   List<PersistentTabConfig> _navBarItems(int currentTab) {
//     return [
//       PersistentTabConfig(
//         screen: const MainUserScreen(),
//         item: ItemConfig(
//           icon: Icon(currentTab == 0
//               ? CupertinoIcons.house_fill
//               : CupertinoIcons.house),
//           title: 'الرئيسية',
//           inactiveForegroundColor: grey,
//           activeForegroundColor: teal,
//         ),
//       ),
//       // PersistentTabConfig(
//       //   icon: Icon(
//       //       currentTab == 0 ? CupertinoIcons.car_fill : CupertinoIcons.car),
//       //   title: 'Maintanence',
//       //   activeForegroundColor: green200,
//       // ),

//       PersistentTabConfig(
//         screen: UserAccountScreen(),
//         item: ItemConfig(
//           icon: Icon(currentTab == 0
//               ? CupertinoIcons.person_fill
//               : CupertinoIcons.person),
//           title: 'الحساب',
//           activeForegroundColor: teal,
//         ),
//       ),
//     ];
//   }

//   PersistentTabController controller = PersistentTabController(initialIndex: 0);

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       // ProfileDataModel profileData =
//       //     await ProfileDataCRUDServices.getProfileDataFromRealTimeDatabase(
//       //         auth.currentUser!.uid);
//       // PushNotivicationServices.initializeFirebaseMessagingForUsers(
//       //     profileData, context);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<BottomNavBarProvider>(
//       builder: (context, tabProvider, child) {
//         return PersistentTabView(
//           controller: controller,
//           tabs: _navBarItems(tabProvider.currentTab),
//           avoidBottomPadding: true,
//           //onItemSelected: ,

//           handleAndroidBackButtonPress: true,
//           resizeToAvoidBottomInset: true,
//           stateManagement: true,

//           popActionScreens: PopActionScreensType.all,

//           navBarBuilder: (navBarConfig) => Style2BottomNavBar(
//             navBarConfig: navBarConfig,
//             navBarDecoration: NavBarDecoration(
//               borderRadius: BorderRadius.circular(8.sp),
//               color: white,
//             ),
//             // itemAnimationProperties: const ItemAnimation(
//             //     duration: Duration(microseconds: 200), curve: Curves.ease),
//           ),
//         );
//       },
//     );
//   }
// }
