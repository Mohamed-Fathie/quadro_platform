import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quadro_platform/features/workshop_authentication/models/workshop_user.dart';
import 'package:quadro_platform/features/workshop_main_screen/bloc/main_screenbloc_bloc.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:quadro_platform/shared/widgets/section_header.dart';
import 'package:sizer/sizer.dart';

import '../../../../shared/enum/maitenance_request_status.dart';

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
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 4.w),
            child: Column(
              spacing: 1.w,
              mainAxisSize: MainAxisSize.min,
              children: [
                SectionHeader(
                    requestType: RequestType.workshop_id,
                    text: "${workshop.name} "),
                SectionHeader(
                    requestType: RequestType.workshop_id,
                    text:
                        "${workshop.city} , ${(workshop.street == "Unknown street" ? "" : workshop.street)} "),
              ],
            ),
          )
        : const Center(
            child: CircularProgressIndicator(
              color: Qcolors.primarycolor,
            ),
          );
  }
}
