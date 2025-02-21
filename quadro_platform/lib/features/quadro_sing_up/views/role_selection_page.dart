import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/repository_manager.dart';
import 'package:quadro_platform/shared/enum/user_role.dart';
import 'package:quadro_platform/shared/routes/navigation_service.dart';
import 'package:quadro_platform/shared/routes/routes_constants.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:quadro_platform/shared/widgets/gradient_circular_progress.dart';
import 'package:sizer/sizer.dart';

import '../cubit/registeration_cubit.dart';
import 'widgets/role_card.dart';

class RegisterationPage extends StatelessWidget {
  const RegisterationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterationCubit(),
      child: const Directionality(
        textDirection: TextDirection.rtl,
        child: RegisterationView(),
      ),
    );
  }
}

class RegisterationView extends StatelessWidget {
  const RegisterationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<RegisterationCubit, RegisterationState>(
        listener: (context, state) {
          if (state is RoleSelectedSuccess) {
            switch (state.selectedUserRole) {
              case UserRole.vehicleOwner:
                NavigationService()
                    .clearAndNavigateTo(RoutesConstants.vehicleonwerpage);
              case UserRole.workshopOwner:
                NavigationService()
                    .clearAndNavigateTo(RoutesConstants.workshopRegistration);
              case UserRole.towService:
                NavigationService()
                    .clearAndNavigateTo(RoutesConstants.towOwnerPage);
            }
          }
        },
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10.h,
              ),
              Text(' ما الدي تبحث عنه عبر تطبيق كوادروا ؟',
                  softWrap: true,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Qcolors.primarycolor,
                      )),
              SizedBox(height: 5.w),
              Expanded(
                child: ListView(
                  children: const [
                    RoleCard(
                      title: 'مالك مركبة',
                      icon: Icons.directions_car,
                      description: "دوّر على ورش وخدمات الصيانة والسحب",
                    ),
                    SizedBox(height: 20),
                    RoleCard(
                      title: 'مالك ورشة',
                      path: "assets/images/icons/icons8-car-service-100.png",
                      description:
                          'دير ورشتك، استقبل الطلبات وقدّم عروض وصيانات للسيارات',
                    ),
                    SizedBox(height: 20),
                    RoleCard(
                      title: 'مقدم خدمة السحب',
                      path: "assets/images/icons/icons8-towing-service-78.png",
                      description: 'تسلم طلبات السحب وتجاوب معاها',
                    ),
                  ],
                ),
              ),
              BlocBuilder<RegisterationCubit, RegisterationState>(
                builder: (context, state) {
                  final isSelected = state is RoleSelected;
                  if (state is RegisterationLoading) {
                    return const GradientCircularProgress();
                  }
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isSelected ? Qcolors.secondary : Colors.grey,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: isSelected
                        ? () {
                            final role = (state as RoleSelected).selectedRole;
                            context
                                .read<RegisterationCubit>()
                                .selectedRoleConfirmed(role);
                          }
                        : null,
                    child: Text('متابعة',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
