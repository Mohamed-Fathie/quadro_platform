import 'package:flutter/material.dart';

import 'about_view.dart';
import 'info_view.dart';
import 'reviews_view.dart';

class TabsViews extends StatelessWidget {
  const TabsViews({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBarView(
      physics: BouncingScrollPhysics(),
      children: [
        // Content for each tab
        AboutView(),
        InfoView(),
        ReviewsView(),
      ],
    );
  }
}
