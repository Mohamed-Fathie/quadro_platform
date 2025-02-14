import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/utils/constans/colors.dart';
import '../../../../shared/widgets/custom_elevated_button.dart';
import '../../cubit/workshop_edit_cubit.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkshopEditBloc, WorkshopEditState,
        WorkshopEditStatus>(
      selector: (state) => state.status,
      builder: (context, status) {
        return status == WorkshopEditStatus.saving
            ? const Center(
                child: CircularProgressIndicator(
                  color: Qcolors.primarycolor,
                  strokeWidth: 5,
                ),
              )
            : CustomElevatedButton(
                buttonColor: Qcolors.primarycolor,
                buttonTitle: "حفظ التعديلات",
                onPressed: () => context.read<WorkshopEditBloc>().saveChanges(),
              );
      },
    );
  }
}
