import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/onboarding/Cubit/Onboarding_cubit.dart';
import 'package:quadro_platform/features/onboarding/view/widgets/Indicator.dart';
import 'package:quadro_platform/features/onboarding/view/widgets/next_button.dart';
import 'package:quadro_platform/features/onboarding/view/widgets/on_boarding_screen.dart';
import 'package:quadro_platform/features/onboarding/view/widgets/skip_button.dart';
import 'package:quadro_platform/shared/utils/constans/text_strings.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => OnboardingCubit(), child: const OnBoardingView());
  }
}

class OnBoardingView extends StatelessWidget {
  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // PageView
            Expanded(
              child: BlocBuilder<OnboardingCubit, int>(
                builder: (context, currentPage) {
                  return PageView(
                    controller: context.read<OnboardingCubit>().pagecontroller,
                    onPageChanged: (index) =>
                        context.read<OnboardingCubit>().updatePage(index),
                    children: const [
                      OnboardingPage(
                        imagePath: 'assets/images/on_boarding/onboarding_1.png',
                        title: Qtexts.onboardingTitle1,
                        description: Qtexts.onboardingDescription1,
                      ),
                      OnboardingPage(
                        imagePath: 'assets/images/on_boarding/onboarding_2.png',
                        title: Qtexts.onboardingTitle2,
                        description: Qtexts.onboardingDescription2,
                      ),
                      OnboardingPage(
                        imagePath: 'assets/images/on_boarding/onboarding_3.png',
                        title: Qtexts.onboardingTitle3,
                        description: Qtexts.onboardingDescription3,
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            //  Indicator
            const Indicator(),

            const SizedBox(height: 20),

            // Next Button
            const NextButton(),

            const SizedBox(height: 20),

            // Skip Button
            const SkipButton(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
