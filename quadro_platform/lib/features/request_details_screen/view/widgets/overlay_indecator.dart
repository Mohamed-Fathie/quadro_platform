import 'package:flutter/material.dart';

import '../../../../shared/utils/constans/colors.dart';

Widget buildSwipeActionsOverlay(BuildContext context) {
  return Positioned.fill(
    child: IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Qcolors.warning.withOpacity(0.1),
              Qcolors.success.withOpacity(0.1),
            ],
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SwipeActionIndicator(
              icon: Icons.close_rounded,
              color: Qcolors.warning,
            ),
            SwipeActionIndicator(
              icon: Icons.check_rounded,
              color: Qcolors.success,
            ),
          ],
        ),
      ),
    ),
  );
}

class SwipeActionIndicator extends StatelessWidget {
  final IconData icon;
  final Color color;

  const SwipeActionIndicator(
      {super.key, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -45,
      child: Icon(
        icon,
        color: color.withOpacity(0.3),
        size: 40,
      ),
    );
  }
}
