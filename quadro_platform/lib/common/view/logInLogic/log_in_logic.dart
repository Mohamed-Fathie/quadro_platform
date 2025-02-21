import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/common/view/logInLogic/login_bloc/bloc/login_bloc.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:quadro_platform/shared/widgets/gradient_circular_progress.dart';
import 'package:sizer/sizer.dart';

import '../../../driver/view/DriverBottomNavBar/driver_bottom_navbar.dart';
import '../../../features/onboarding/view/on_boarding_page.dart';
import '../../../features/workshop_bottom_nav_bar/workshop_nav_bar.dart';
import '../../../shared/enum/user_role.dart';
import '../../../user/view/bottomNavBars/main_bottom_navbar/main_bottom_navbar.dart';
import '../../controller/provider/profile_data_provider.dart';
import '../log_in_screen.dart';

class WidgetFlow extends StatelessWidget {
  const WidgetFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state is Onboarding) {
          return const OnBoardingPage();
        }
        if (state is Authenticated) {
          try {
            context.read<ProfileDataProvider>().getProfileData();
          } catch (e) {
            return const ErrorAuthWidget();
          }
          switch (state.userRole) {
            case UserRole.towService:
              return DriverBottomNavBar();
            case UserRole.vehicleOwner:
              return const MainBottomNavbar();
            case UserRole.workshopOwner:
              return const WorkshopNavBar();
          }
        } else if (state is Unauthenticated) {
          return const LogInScreen();
        } else if (state is AuthError) {
          return const ErrorAuthWidget();
        }
        return Scaffold(
          backgroundColor: white,
          body: Stack(children: [
            const Center(
              child: Image(
                image: AssetImage('assets/images/logos/Qadro2.png'),
              ),
            ),
            Positioned(
                bottom: 20.h,
                left: 50.w,
                child: const GradientCircularProgress())
          ]),
        );
      },
    );
  }
}

class ErrorAuthWidget extends StatelessWidget {
  const ErrorAuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("حدث خطا ما"),
      ),
    );
  }
}

class FlowLogin extends StatelessWidget {
  const FlowLogin({super.key});

  @override
  Widget build(BuildContext context) {
    // context.read<LoginBloc>().add(AppInitialization());
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state is Authenticated) {
          try {
            context.read<ProfileDataProvider>().getProfileData();
          } catch (e) {
            return const ErrorAuthWidget();
          }
          switch (state.userRole) {
            case UserRole.towService:
              return DriverBottomNavBar();
            case UserRole.vehicleOwner:
              return const MainBottomNavbar();
            case UserRole.workshopOwner:
              return const WorkshopNavBar();
          }
        } else if (state is Unauthenticated) {
          return const LogInScreen();
        } else if (state is AuthError) {
          return const ErrorAuthWidget();
        }
        return Scaffold(
          backgroundColor: white,
          body: Stack(children: [
            const Center(
              child: Image(
                image: AssetImage('assets/images/logos/Qadro2.png'),
              ),
            ),
            Positioned(
                bottom: 20.h,
                left: 50.w,
                child: const GradientCircularProgress())
          ]),
        );
      },
    );
  }
}
