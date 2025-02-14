import 'package:flutter/material.dart';

import '../../../../shared/utils/constans/colors.dart';

Widget buildSwipeToDeleteOverlay(BuildContext context) {
  return Positioned.fill(
    child: IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Qcolors.secondary.withOpacity(0.3),
              Colors.transparent,
            ],
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SwipeToDeleteIndicator(),
            SwipeToDeleteIndicator(),
          ],
        ),
      ),
    ),
  );
}

class SwipeToDeleteIndicator extends StatelessWidget {
  const SwipeToDeleteIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -45,
      child: Icon(
        Icons.arrow_back_ios_new_rounded,
        color: Qcolors.secondary.withOpacity(0.5),
        size: 40,
      ),
    );
  }
}
