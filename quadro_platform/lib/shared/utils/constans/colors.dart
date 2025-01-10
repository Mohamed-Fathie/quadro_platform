import 'package:flutter/material.dart';

import 'helper_functions.dart';

class Qcolors {
  static const Color primarycolor = Color(0xff0288a6);
  static const Color secondary = Color(0xFF05AB9F);
  static const Color blackFont = Color(0xff121212);
  static const Color buttonbackground = Color(0xFFE4F4F7);
  static Color getCurrentColor(BuildContext context) {
    final isDark = QhelperFucntions().isDarkMode(context);
    return isDark ? const Color(0xFF1A2A38) : const Color(0xFFE4F4F7);
  }
}
