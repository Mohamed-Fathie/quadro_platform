import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadro_platform/common/controller/provider/location_provider.dart';
import 'package:quadro_platform/common/controller/provider/profile_data_provider.dart';
import 'package:quadro_platform/common/view/logInLogic/log_in_logic.dart';
import 'package:quadro_platform/driver/controller/provider/bottom_nav_bar_provider.dart';
import 'package:quadro_platform/driver/controller/provider/driver_location_provider.dart';
import 'package:quadro_platform/driver/controller/provider/driver_maps_provider.dart';
import 'package:quadro_platform/driver/controller/provider/driver_ride_request_provider.dart';
import 'package:quadro_platform/features/theme/globalthemdata.dart';
import 'package:quadro_platform/features/user/repository/user_repository.dart';
import 'package:quadro_platform/features/workshop_authentication/repository/workshop_repo.dart';
import 'package:quadro_platform/features/workshop_authentication/views/trade_license.dart';
import 'package:quadro_platform/features/workshop_authentication/views/workshop_authenitication_page.dart';
import 'package:quadro_platform/features/workshop_authentication/views/workshop_registeration_page.dart';
import 'package:quadro_platform/features/workshop_bottom_nav_bar/workshop_nav_bar.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/repository_manager.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/maintenance_requests_repo.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/offers_repository.dart';
import 'package:quadro_platform/features/workshop_main_screen/views/main_screen_page.dart';
import 'package:quadro_platform/features/workshop_profile/view/workshop_profile_page.dart';
import 'package:quadro_platform/firebase_options.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';
import 'package:quadro_platform/shared/routes/navigation_service.dart';
import 'package:quadro_platform/shared/routes/quadro_route_configuration.dart';
import 'package:quadro_platform/user/controller/provider/BottomNavBarProvider/bottom_nav_bar_provider.dart';
import 'package:quadro_platform/user/controller/provider/trip_provider/ride_request_provider.dart';
import 'package:sizer/sizer.dart';

import 'features/google_map/views/workshop_location_map.dart';
import 'features/workshop_profile/repository/reviews_repository.dart';

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
            // ChangeNotifierProvider<BottomNavBarProvider>(
            //   create: (_) => BottomNavBarProvider(),
            // ),
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
            ChangeNotifierProvider<RideRequestProvider>(
              create: (_) => RideRequestProvider(),
            ),
            ChangeNotifierProvider<DriverRideRequestProvider>(
              create: (_) => DriverRideRequestProvider(),
            ),
          ],
          child: RepositoryProvider(
            create: (context) => RepositoryManager(
                reviewsRepository: ReviewsRepository(),
                maintenanceRequestsRepository: MaintenanceRequestsRepository(),
                offersRepository: OffersRepository(),
                userRepository: UserRepository(),
                workshopRepository: WorkshopRepository()),
            child: MaterialApp(
              locale: const Locale('ar'),
              supportedLocales: const [Locale('ar')],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate, // For Cupertino widgets
              ],
              navigatorKey: NavigationService().navigatorKey,
              onGenerateRoute: RouteGenerator.generateRoutes,
              debugShowCheckedModeBanner: false,
              theme: GlobalThemData.lightThemeData,
              darkTheme: GlobalThemData.darkThemeData,
              themeMode: ThemeMode.system,
              home: const LogInLogic(),
            ),
          ),
        );
      },
    );
  }
}
