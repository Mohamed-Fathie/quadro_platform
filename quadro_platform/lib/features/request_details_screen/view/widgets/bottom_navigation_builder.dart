import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/request_details_screen/cubit/details_cubit.dart';
import 'package:quadro_platform/features/request_details_screen/view/widgets/inprogress.dart';
import 'package:quadro_platform/features/request_details_screen/view/widgets/rateing.dart';
import 'package:quadro_platform/features/request_details_screen/view/widgets/respose_bar.dart';
import 'package:quadro_platform/features/workshop_main_screen/models/maintenance_request_data_model.dart';

import 'complete.dart';

class BottomNavigationBuilder extends StatelessWidget {
  final MaintenanceRequestDomainModel request;
  const BottomNavigationBuilder({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsCubit, RequestDetailsState>(
      builder: (context, state) {
        if (state.canRateService) {
          return buildRatingBottomBar(context, request);
        } else if (state.canMarkInProgress) {
          return buildWorkshopProgressBar(context, request);
        } else if (state.canRespond) {
          return buildOfferResponseBar(context, request);
        } else if (state.canMarkCompleted) {
          return buildWorkshopCompletBar(context, request);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
