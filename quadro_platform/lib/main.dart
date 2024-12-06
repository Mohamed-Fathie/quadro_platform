import 'package:flutter/material.dart';
import 'package:quadro_platform/features/onboarding/view/on_boarding_page.dart';
import 'package:quadro_platform/features/theme/globalthemdata.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MaterialApp(
          theme: GlobalThemData.lightThemeData,
          darkTheme: GlobalThemData.darkThemeData,
          themeMode: ThemeMode.system,
          home: const OnBoardingPage()),
    );
  }
}
