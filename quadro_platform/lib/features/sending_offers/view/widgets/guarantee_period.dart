import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/sending_offers/cubit/sending_offer_cubit.dart';

import 'custom_textField.dart';

class GuaranteePeriod extends StatelessWidget {
  const GuaranteePeriod({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SendingOfferCubit>();
    final message = context.select<SendingOfferCubit, String?>(
      (SendingOfferCubit cubit) => cubit.state.periodErrorMessage,
    );
    return CustomTextfield(
      controller: cubit.periodController,
      hint: "01",
      onchangedCallback: cubit.onGuaranteePeriodChanged,
      prefixIcons: "يوم",
      errorMessage: message,
    );
  }
}
