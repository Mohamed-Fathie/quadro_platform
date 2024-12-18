import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String text;

  const SectionHeader({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        style: Theme.of(context).textTheme.headlineMedium,
        softWrap: true,
      ),
    );
  }
}
