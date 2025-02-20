import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:quadro_platform/user/view/bottomNavBars/main_bottom_navbar/red_circle.dart';

import '../../../../features/offers_screen/view/user_offer_page.dart';
import '../../../../shared/utils/constans/colors.dart';
import '../../account/user_account_screen.dart';
import '../../mainUserScreen/view/main_user_screen_page.dart';

class UserMainNavBarScreens {
  static final UserMainNavBarScreens _instance =
      UserMainNavBarScreens._internal();
  factory UserMainNavBarScreens() => _instance;

  UserMainNavBarScreens._internal();

  final PersistentTabController controller =
      PersistentTabController(initialIndex: 0);

  List<PersistentTabConfig> buildScreens() {
    return [
      PersistentTabConfig(
        screen: const MainUserScreen(),
        item: ItemConfig(
          title: "الرئيسية",
          icon: const Icon(
            Icons.home_filled,
            applyTextScaling: true,
          ),
          activeForegroundColor: Qcolors.secondary,
        ),
      ),
      // PersistentTabConfig(
      //   screen: const Center(
      //     child: Text("اشعارات"),
      //   ),
      //   item: ItemConfig(
      //     activeForegroundColor: Qcolors.secondary,
      //     icon: const Icon(Icons.notifications_rounded),
      //     title: "اشعارات",
      //   ),
      // ),
      PersistentTabConfig(
        screen: const UserOfferPage(),
        item: ItemConfig(
          title: "عروض",
          activeForegroundColor: Qcolors.secondary,
          icon: const OfferIcon(), // Using our dynamic icon here
        ),
      ),
      PersistentTabConfig(
        screen: UserAccountScreen(),
        item: ItemConfig(
          activeForegroundColor: Qcolors.secondary,
          icon: const Icon(Icons.person),
          title: "الحساب",
        ),
      ),
    ];
  }
}
