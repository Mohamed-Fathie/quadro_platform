import 'package:flutter/material.dart';

class QhelperFucntions {
  double screennWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
  double screennheight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  bool isDarkMode(BuildContext context) =>
      MediaQuery.of(context).platformBrightness == Brightness.dark;
}
