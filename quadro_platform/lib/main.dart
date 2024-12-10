import 'package:flutter/material.dart';
import 'package:quadro_platform/features/onboarding/view/on_boarding_page.dart';
import 'package:quadro_platform/features/theme/globalthemdata.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
