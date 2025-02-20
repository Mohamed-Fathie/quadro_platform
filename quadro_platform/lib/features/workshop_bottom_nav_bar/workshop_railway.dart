import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/utils/constans/colors.dart';
import '../../shared/utils/constans/helper_functions.dart';
import '../offers_screen/view/workshop_offer_page.dart';
import '../workshop_main_screen/views/main_screen_page.dart';
import '../workshop_profile/view/workshop_profile_page.dart';
import 'cubit/navigation.dart';

class WorkshopNavBarWeb extends StatelessWidget {
  const WorkshopNavBarWeb({super.key});

  // Define the screens corresponding to each navigation destination.
  final List<Widget> _screens = const [
    MainScreenPage(),
    WorkshopOfferPage(),
    WorkshopProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = QhelperFucntions.isDarkMode(context);
    return BlocProvider(
      create: (_) => NavigationCubit(),
      child: Scaffold(
        body: Row(
          children: [
            // Use BlocBuilder to rebuild the NavigationRail when the index changes.
            BlocBuilder<NavigationCubit, int>(
              builder: (context, selectedIndex) {
                return NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) =>
                      context.read<NavigationCubit>().updateIndex(index),
                  labelType: NavigationRailLabelType.all,
                  backgroundColor:
                      isDark ? const Color(0xFF1F1929) : Colors.white,
                  selectedIconTheme:
                      const IconThemeData(color: Qcolors.primarycolor),
                  selectedLabelTextStyle:
                      const TextStyle(color: Qcolors.primarycolor),
                  destinations: const [
                    NavigationRailDestination(
                      indicatorColor: Qcolors.buttonbackground,
                      icon: Icon(Icons.home_filled),
                      label: Text("الرئيسية"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.local_offer_rounded),
                      label: Text("عروض"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person),
                      label: Text("الحساب"),
                    ),
                  ],
                  indicatorColor: Qcolors.buttonbackground,
                  // Enable the indicator behind the selected destination.
                  useIndicator: true,
                );
              },
            ),
            const VerticalDivider(
              thickness: 1,
              width: 1,
              color: Qcolors.primarycolor,
            ),
            // Use BlocBuilder to update the content based on the selected index.
            Expanded(
              child: BlocBuilder<NavigationCubit, int>(
                builder: (context, selectedIndex) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 700),
                    child: _screens[selectedIndex],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
