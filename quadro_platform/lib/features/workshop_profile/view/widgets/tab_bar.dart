import 'package:flutter/material.dart';

import '../../../../shared/utils/constans/colors.dart';

class WorkshopTabBar extends StatelessWidget implements PreferredSizeWidget {
  const WorkshopTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicatorColor: Qcolors.primarycolor,
      indicatorWeight: 8,
      dividerColor: Qcolors.primarycolor,
      indicatorSize: TabBarIndicatorSize.label,
      tabs: [
        Tab(
            child: Text(
          "حول",
          style: Theme.of(context).textTheme.headlineMedium,
        )),
        Tab(
            child: Text(
          "معلومات",
          style: Theme.of(context).textTheme.headlineMedium,
        )),
        Tab(
            child: Text(
          "المراجعات",
          style: Theme.of(context).textTheme.headlineMedium,
        )),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48.0);
}
