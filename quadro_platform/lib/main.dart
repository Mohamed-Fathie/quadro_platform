import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadro_platform/features/onboarding/view/on_boarding_page.dart';
import 'package:quadro_platform/features/onboarding/view/widgets/on_boarding_screen.dart';

import 'package:quadro_platform/features/theme/globalthemdata.dart';
import 'package:quadro_platform/features/user/repository/user_repository.dart';
import 'package:quadro_platform/features/workshop_authentication/repository/workshop_repo.dart';
import 'package:quadro_platform/features/workshop_authentication/veiws/trade_license.dart';
import 'package:quadro_platform/features/workshop_authentication/veiws/workshop_authenitication_page.dart';
import 'package:quadro_platform/features/workshop_authentication/veiws/workshop_registeration_page.dart';
import 'package:quadro_platform/features/workshop_bottom_nav_bar/workshop_nav_bar.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/repository_manager.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/maintenance_requests_repo.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/offers_repository.dart';
import 'package:quadro_platform/features/workshop_main_screen/views/main_screen_page.dart';
import 'package:quadro_platform/firebase_options.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';
import 'package:quadro_platform/shared/routes/navigation_service.dart';
import 'package:quadro_platform/shared/routes/quadro_route_configuration.dart';
import 'package:quadro_platform/shared/routes/routes_constants.dart';
import 'package:quadro_platform/user/controller/BottomNavBarProvider/bottom_nav_bar_provider.dart';
import 'package:quadro_platform/user/view/account/user_account_screen.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const Quadro());
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
            navigatorKey: NavigationService().navigatorKey,
            onGenerateRoute: RouteGenerator.generateRoutes,
            debugShowCheckedModeBanner: false,
            theme: GlobalThemData.lightThemeData,
            darkTheme: GlobalThemData.darkThemeData,
            themeMode: ThemeMode.system,
            home: const OnBoardingPage(),
          ),
        );
      },
    );
  }
}
