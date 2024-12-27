import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadro_platform/common/controller/provider/location_provider.dart';
import 'package:quadro_platform/common/controller/provider/profile_data_provider.dart';
import 'package:quadro_platform/common/view/logInLogic/log_in_logic.dart';
import 'package:quadro_platform/driver/controller/provider/bottom_nav_bar_provider.dart';
import 'package:quadro_platform/driver/controller/provider/driver_location_provider.dart';
import 'package:quadro_platform/driver/controller/provider/driver_maps_provider.dart';
import 'package:quadro_platform/features/theme/globalthemdata.dart';
import 'package:quadro_platform/firebase_options.dart';
import 'package:quadro_platform/shared/routes/navigation_service.dart';
import 'package:quadro_platform/shared/routes/quadro_route_configuration.dart';
import 'package:quadro_platform/user/controller/BottomNavBarProvider/bottom_nav_bar_provider.dart';
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
            ChangeNotifierProvider<LocationProvider>(
              create: (_) => LocationProvider(),
            ),
            ChangeNotifierProvider<ProfileDataProvider>(
              create: (_) => ProfileDataProvider(),
            ),
            ChangeNotifierProvider<BottomNavBarDriverProvider>(
              create: (_) => BottomNavBarDriverProvider(),
            ),
            ChangeNotifierProvider<DriverMapsProvider>(
              create: (_) => DriverMapsProvider(),
            ),
            ChangeNotifierProvider<DriverLocationProvider>(
              create: (_) => DriverLocationProvider(),
            ),
          ],
          child: MaterialApp(
            navigatorKey: NavigationService().navigatorKey,
            onGenerateRoute: RouteGenerator.generateRoutes,
            debugShowCheckedModeBanner: false,
            theme: GlobalThemData.lightThemeData,
            darkTheme: GlobalThemData.darkThemeData,
            themeMode: ThemeMode.system,
            home: LogInLogic(),
          ),
        );
      },
    );
  }
}
