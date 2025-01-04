import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quadro_platform/features/workshop_authentication/cubit/authbloc_cubit.dart';
import 'package:quadro_platform/shared/routes/navigation_service.dart';
import 'package:quadro_platform/shared/routes/routes_constants.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:quadro_platform/shared/widgets/custom_elevated_button.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkshopAuthbloc, WorkshopAuthblocState,
        WorkshopAuthStatus>(
      selector: (state) {
        return state.status;
      },
      builder: (context, state) {
        return state == WorkshopAuthStatus.loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Qcolors.primarycolor,
                  strokeWidth: 5,
                ),
              )
            : CustomElevatedButton(
                buttonColor: Qcolors.primarycolor,
                buttonTitle: "حفظ اعدادات الحساب",
                onPressed: () async {
                  await context.read<WorkshopAuthbloc>().saveData();
                },
              );
      },
    );
  }
}
