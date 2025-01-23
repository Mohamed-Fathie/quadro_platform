import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:quadro_platform/shared/widgets/section_header.dart';
import 'package:quadro_platform/user/view/mainUserScreen/bloc/main_screen_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../shared/enum/maitenance_request_status.dart';

class MainUserScreenHeader extends StatelessWidget {
  const MainUserScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final name =
        context.select((MainUserScreenBloc bloc) => bloc.state.userName);
    return Column(
      spacing: 1.h,
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionHeader(
            requestType: RequestType.vehicle_owner_id, text: "مرحبا $name"),
        const SectionHeader(
          requestType: RequestType.vehicle_owner_id,
          text: "تحتاج اي مساعدة اليوم ؟",
          islarge: true,
          textColor: Qcolors.secondary,
        )
      ],
    );
  }
}
