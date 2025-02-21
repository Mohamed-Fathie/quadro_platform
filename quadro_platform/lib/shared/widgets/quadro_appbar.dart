// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../utils/constans/colors.dart';

typedef NotificationCallBack = void Function();

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final NotificationCallBack notificationCallBack;
  const GradientAppBar({super.key, required this.notificationCallBack});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: Qcolors.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
        child: const Text(
          "QUADRO",
          style: TextStyle(
            color: Colors.white, // This ensures the gradient is visible
            fontSize: 31,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // actions: [
      //   IconButton(
      //     onPressed: notificationCallBack,
      //     icon: ShaderMask(
      //       shaderCallback: (bounds) => LinearGradient(
      //         colors: Qcolors.gradient,
      //         begin: Alignment.topLeft,
      //         end: Alignment.bottomRight,
      //       ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      //       child: const Icon(
      //         Icons.notifications,
      //         color: Colors.white, // This ensures the gradient is visible
      //       ),
      //     ),
      //   ),
      // ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
