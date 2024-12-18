import 'package:flutter/material.dart';

class VerticalSpacing extends StatelessWidget {
  final double height;

  const VerticalSpacing({required this.height, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}
