import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/onboarding/Cubit/Onboarding_cubit.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Indicator extends StatelessWidget {
  const Indicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, int>(
      builder: (context, currentPage) {
        return AnimatedSmoothIndicator(
          activeIndex: currentPage,
          count: 3,
          effect: const ExpandingDotsEffect(
            dotWidth: 30,
            dotHeight: 12,
            activeDotColor: Qcolors.secondary,
          ),
        );
      },
    );
  }
}
