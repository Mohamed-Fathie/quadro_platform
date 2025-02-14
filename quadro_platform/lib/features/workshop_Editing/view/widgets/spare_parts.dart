import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/shared/enum/spare_parts.dart';
import 'package:sizer/sizer.dart';

import '../../../../shared/utils/constans/colors.dart';
import '../../cubit/workshop_edit_cubit.dart';

class SpareParts extends StatelessWidget {
  const SpareParts({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<WorkshopEditBloc>();
    final partsStatus = context.select(
      (WorkshopEditBloc bloc) => bloc.state.partsStatus,
    );

    return Wrap(
      textDirection: TextDirection.rtl,
      spacing: 5.w,
      children: partsStatus.keys
          .map((part) => ChoiceChip(
                avatar: Icon(part.icon),
                checkmarkColor: Qcolors.primarycolor,
                labelStyle: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.apply(color: Qcolors.primarycolor),
                label: Text(part.label),
                selected: partsStatus[part] ?? false,
                onSelected: (_) => bloc.updatePartsStatus(part),
                selectedColor: Qcolors.buttonbackground,
                backgroundColor: Qcolors.buttonbackground,
              ))
          .toList(),
    );
  }
}
