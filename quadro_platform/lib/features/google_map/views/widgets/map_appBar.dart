import 'package:flutter/material.dart';

import '../../../../shared/utils/constans/colors.dart';

class MapAppBar extends StatelessWidget {
  const MapAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "خرائط قوقل",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        iconTheme: const IconThemeData(color: Qcolors.primarycolor),
      ),
    );
  }
}
