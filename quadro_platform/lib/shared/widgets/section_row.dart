import 'package:flutter/material.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:quadro_platform/shared/widgets/rounded_container.dart';
import 'package:sizer/sizer.dart';

class SectionRow extends StatelessWidget {
  final String label;
  final String value;
  final String? imageUrl;
  const SectionRow(
      {super.key, required this.label, required this.value, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      spacing: 5.w,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        imageUrl == null
            ? const SizedBox.shrink()
            : RoundedContainer(
                height: 50,
                width: 50,
                child: Image.network(
                  fit: BoxFit.cover,
                  imageUrl ??
                      "https://firebasestorage.googleapis.com/v0/b/quadro-204be.firebasestorage.app/o/Profile_Images%2Fdhdhdgg%40gmail.com42435c00-c43b-11ef-b85b-879b0d7d6b91?alt=media&token=ee320211-7794-4481-b66a-6d5f048f035b",
                ),
              ),
        Expanded(
          child: Text(
            textDirection: TextDirection.rtl,
            softWrap: true,
            value,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.apply(color: Qcolors.primarycolor),
          ),
        )
      ],
    );
  }
}
