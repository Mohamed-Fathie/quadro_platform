import 'package:flutter/material.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:quadro_platform/shared/widgets/rounded_container.dart';
import 'package:sizer/sizer.dart';

class SectionRow extends StatelessWidget {
  final String label;
  final String value;
  final String? imageUrl;

  const SectionRow({
    super.key,
    required this.label,
    required this.value,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Label and Value
        Expanded(
          child: RichText(
            textAlign: TextAlign.right,
            text: TextSpan(
              text: label,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              children: [
                TextSpan(
                  text: " $value",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Qcolors.primarycolor,
                      ),
                ),
              ],
            ),
          ),
        ),
        if (imageUrl != null)
          Container(
            height: 40,
            width: 40,
            margin: EdgeInsets.only(left: 8.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Qcolors.primarycolor, width: 2),
              image: DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              ),
            ),
          ),
      ],
    );
  }
}
