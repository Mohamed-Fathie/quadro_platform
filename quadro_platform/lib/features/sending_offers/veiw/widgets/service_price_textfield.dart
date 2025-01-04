import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/sending_offers/veiw/widgets/custom_textField.dart';

import '../../cubit/sending_offer_cubit.dart';

class ServicePriceTextfield extends StatelessWidget {
  const ServicePriceTextfield({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SendingOfferCubit>();
    final errorMessage = context.select<SendingOfferCubit, String?>(
      (SendingOfferCubit cubit) => cubit.state.priceErrorMessage,
    );
    return CustomTextfield(
      controller: cubit.priceController,
      hint: "000.00",
      onchangedCallback: cubit.onServicePriceChanged,
      prefixIcons: "LYD",
      errorMessage: errorMessage,
    );
  }
}
