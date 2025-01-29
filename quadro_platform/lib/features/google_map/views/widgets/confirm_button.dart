import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/google_map/model/selected_location.dart';
import 'package:quadro_platform/shared/routes/navigation_service.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:quadro_platform/shared/widgets/custom_elevated_button.dart';
import 'package:sizer/sizer.dart';

import '../../bloc/workshop_location_map_bloc.dart';

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkshopLocationMapBloc, WorkshopLocationState>(
      listener: (context, state) {
        if (state is WorkshopLocationConfirmSuccess) {
          NavigationService().goBack(
              result: SelectedLocation(
                  coordinates: state.coordination,
                  city: state.city,
                  street: state.street));
        }
      },
      builder: (context, state) {
        return Positioned(
          bottom: 5.w,
          left: 15.w,
          right: 15.w,
          child: state is! WorkshopLocationinitial
              ? const SizedBox.shrink()
              : CustomElevatedButton(
                  buttonColor: Qcolors.primarycolor,
                  buttonTitle: 'تأكيد الموقع',
                  onPressed: () => context
                      .read<WorkshopLocationMapBloc>()
                      .add(WorkshopLocationConfirmed()),
                ),
        );
      },
    );
  }
}
