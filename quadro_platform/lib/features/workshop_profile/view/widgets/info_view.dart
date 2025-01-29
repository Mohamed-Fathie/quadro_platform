import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';
import 'package:quadro_platform/shared/widgets/section_row.dart';

import '../../../../shared/utils/constans/colors.dart';
import '../../cubit/workshop_profile_cubit.dart';

class InfoView extends StatelessWidget {
  const InfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final workshop = context.select(
      (WorkshopProfileCubit value) => value.state.workshop,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 25,
      children: [
        Text(
          "معلومات عن الورشة",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Qcolors.primarycolor,
                fontWeight: FontWeight.bold,
              ),
        ),
        const Divider(
          color: Qcolors.primarycolor,
          thickness: 2,
        ),
        SectionRow(
          requestType: RequestType.workshop_id,
          label: "رقم الهاتف:",
          value: workshop!.phone,
        ),
        SectionRow(
          requestType: RequestType.workshop_id,
          label: "موقع الورشة  :",
          value:
              " ${workshop.city} , ${(workshop.street == "Unknown street" ? "" : workshop.street)} ",
        ),
      ],
    );
  }
}
