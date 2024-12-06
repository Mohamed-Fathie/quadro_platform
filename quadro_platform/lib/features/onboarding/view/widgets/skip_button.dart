import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/onboarding/Cubit/Onboarding_cubit.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return BlocBuilder<OnboardingCubit, int>(
      builder: (context, currentPage) {
        return currentPage == 0
            ? RichText(
                text: TextSpan(
                    text: 'لديك حساب بالفعل؟',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: isDarkMode ? Colors.white : Qcolors.blackFont),
                    children: const [
                    TextSpan(
                        text: "تسجيل الدخول",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Qcolors.secondary,
                        ))
                  ]))
            : currentPage < 2
                ? TextButton(
                    onPressed: () {
                      // Skip to the main app
                      //Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: const Text(
                      'تخطي',
                      style: TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                : const SizedBox.shrink();
      },
    );
  }
}
