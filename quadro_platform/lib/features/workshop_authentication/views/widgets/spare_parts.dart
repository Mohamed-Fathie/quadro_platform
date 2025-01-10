import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/workshop_authentication/cubit/authbloc_cubit.dart';
import 'package:quadro_platform/shared/enum/spare_parts.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:sizer/sizer.dart';

class SpareParts extends StatelessWidget {
  const SpareParts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WorkshopAuthbloc>();

    final sparePartsMap =
        context.select((WorkshopAuthbloc cubit) => cubit.state.partsStatus);
    return Wrap(
      textDirection: TextDirection.rtl,
      spacing: 5.w,
      children: sparePartsMap.keys
          .map(
            (part) => ChoiceChip(
              avatar: Icon(part.icon),
              checkmarkColor: Qcolors.primarycolor,
              labelStyle: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.apply(color: Qcolors.primarycolor),
              label: Text(part.label),
              selected: sparePartsMap[part] ?? false,
              onSelected: (selected) => cubit.onSelected(part),
              selectedColor: Qcolors
                  .buttonbackground, // Customize the color for selected chips
              backgroundColor:
                  Qcolors.buttonbackground, // Background for unselected chips
            ),
          )
          .toList(),
    );
  }
}
