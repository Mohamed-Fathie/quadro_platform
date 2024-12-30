import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quadro_platform/features/workshop_authentication/models/workshop_user.dart';
import 'package:quadro_platform/features/workshop_main_screen/bloc/main_screenbloc_bloc.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:quadro_platform/shared/widgets/section_header.dart';

class WorkshopName extends StatelessWidget {
  const WorkshopName({super.key});

  @override
  Widget build(BuildContext context) {
    final workshop = context.select<MainScreenBloc, Workshop?>(
      (MainScreenBloc value) {
        return value.state.workshop;
      },
    );
    return workshop != null
        ? SectionHeader(text: "${workshop.name} ${workshop.phone}")
        : const Center(
            child: CircularProgressIndicator(
              color: Qcolors.primarycolor,
            ),
          );
  }
}
