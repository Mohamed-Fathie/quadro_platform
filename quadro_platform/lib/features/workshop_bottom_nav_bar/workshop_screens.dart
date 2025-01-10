import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:quadro_platform/features/workshop_main_screen/views/main_screen_page.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';

import '../workshop_profile/view/workshop_profile_page.dart';

class WorkshopScreens {
  final PersistentTabController controller =
      PersistentTabController(initialIndex: 0);
  List<PersistentTabConfig> buildScreens() {
    return [
      PersistentTabConfig(
        screen: const MainScreenPage(),
        item: ItemConfig(
          title: "الرئيسية",
          icon: const Icon(
            Icons.home_filled,
            applyTextScaling: true,
          ),
          activeForegroundColor: Qcolors.primarycolor,
        ),
      ),
      PersistentTabConfig(
          screen: const Center(
            child: Text("اشعارات"),
          ),
          item: ItemConfig(
              activeForegroundColor: Qcolors.primarycolor,
              icon: const Icon(
                Icons.notifications_rounded,
              ),
              title: "اشعارات")),
      PersistentTabConfig(
          screen: const Center(
            child: Text("profile"),
          ),
          item: ItemConfig(
              activeForegroundColor: Qcolors.primarycolor,
              icon: const Icon(Icons.local_offer_rounded),
              title: "عروض")),
      PersistentTabConfig(
          screen: const WorkshopProfilePage(),
          item: ItemConfig(
              activeForegroundColor: Qcolors.primarycolor,
              icon: const Icon(Icons.person),
              title: "الحساب")),
    ];
  }
}
