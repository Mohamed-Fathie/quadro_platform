import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadro_platform/common/view/log_in_screen.dart';
import 'package:quadro_platform/common/view/registration_screen.dart';
import 'package:quadro_platform/features/onboarding/view/on_boarding_page.dart';
import 'package:quadro_platform/firebase_options.dart';
import 'package:quadro_platform/user/controller/BottomNavBarProvider/bottom_nav_bar_provider.dart';
import 'package:quadro_platform/user/view/account/user_account_screen.dart';
import 'package:quadro_platform/user/view/bottomNavBar/bottom_navbar.dart';
import 'package:quadro_platform/user/view/riderActivityScreen/rider_activity_screen.dart';
import 'package:quadro_platform/user/view/riderHomeScreen/rider_home_screen.dart';
import 'package:quadro_platform/theme/globalthemdata.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(Quadro());
}

class Quadro extends StatelessWidget {
  const Quadro({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, _, __) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<BottomNavBarProvider>(
              create: (_) => BottomNavBarProvider(),
            ),
          ],
          child: MaterialApp(
            routes: {
              LogInScreen.id: (context) => const LogInScreen(),
              RegistrationScreen.id: (context) => RegistrationScreen(),
            },
            debugShowCheckedModeBanner: false,
            theme: GlobalThemData.lightThemeData,
            darkTheme: GlobalThemData.darkThemeData,
            themeMode: ThemeMode.system,
            home: OnBoardingPage(),
          ),
        );
      },
    );
  }
}
