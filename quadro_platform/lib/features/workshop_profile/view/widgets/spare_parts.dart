import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../shared/enum/spare_parts.dart';
import '../../../../shared/widgets/rounded_container.dart';

class SpareParts extends StatelessWidget {
  final List<SparePartsStatus> partsList;
  const SpareParts({super.key, required this.partsList});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      textDirection: TextDirection.rtl,
      children: partsList
          .map(
            (status) => RoundedContainer(
                width: 40.w,
                height: 6.h,
                child: Center(
                    child: Text(
                  status.label,
                  style: Theme.of(context).textTheme.headlineMedium,
                ))),
          )
          .toList(),
    );
  }
}
