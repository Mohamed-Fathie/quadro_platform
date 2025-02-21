import 'package:flutter/material.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';

class GradientCircularProgress extends StatelessWidget {
  const GradientCircularProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            colors: Qcolors.gradient,
            tileMode: TileMode.mirror,
          ).createShader(bounds);
        },
        child: const CircularProgressIndicator(
          strokeWidth: 6.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
