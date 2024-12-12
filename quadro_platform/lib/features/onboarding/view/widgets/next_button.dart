import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/common/view/log_in_screen.dart';
import 'package:quadro_platform/features/onboarding/Cubit/Onboarding_cubit.dart';
import 'package:quadro_platform/shared/routes/navigation_service.dart';
import 'package:quadro_platform/shared/routes/routes_constants.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';

class NextButton extends StatelessWidget {
  const NextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: BlocBuilder<OnboardingCubit, int>(
        builder: (context, currentPage) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              backgroundColor: Qcolors.secondary,
            ),
            onPressed: () {
              if (currentPage < 2) {
                // Move to the next page
                context.read<OnboardingCubit>().nextPage();
              } else {
                NavigationService().replaceRoute(RoutesConstants.login);
              }
            },
            child: Text(
              currentPage < 2 ? 'التالي' : 'ابدأ الآن',
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
