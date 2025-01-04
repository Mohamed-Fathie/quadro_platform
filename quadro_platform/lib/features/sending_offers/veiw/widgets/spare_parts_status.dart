import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/sending_offers/cubit/sending_offer_cubit.dart';
import 'package:quadro_platform/shared/enum/spare_parts.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:sizer/sizer.dart';

import '../../../../shared/widgets/rounded_container.dart';

class SparePartsRidosButton extends StatelessWidget {
  const SparePartsRidosButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SendingOfferCubit>();
    final currentstatus = context.select(
      (SendingOfferCubit cubit) => cubit.state.partsStatus,
    );
    return Wrap(
      textDirection: TextDirection.rtl,
      children: SparePartsStatus.values
          .map(
            (status) => RoundedContainer(
                width: 40.w,
                height: 6.h,
                child: RadioListTile<SparePartsStatus>(
                    title: Text(
                      status.label,
                      style: const TextStyle(color: Qcolors.primarycolor),
                    ),
                    value: status,
                    groupValue: currentstatus,
                    onChanged: cubit.onSparePartsStatus)),
          )
          .toList(),
    );
  }
}
