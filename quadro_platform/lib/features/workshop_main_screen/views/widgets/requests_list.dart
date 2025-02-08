import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/workshop_main_screen/bloc/main_screenbloc_bloc.dart';
import 'package:quadro_platform/features/workshop_main_screen/models/maintenance_request_data_model.dart';
import 'package:quadro_platform/shared/enum/request_status.dart';
import 'package:quadro_platform/shared/widgets/request_templet.dart';
import 'package:quadro_platform/shared/routes/navigation_service.dart';
import 'package:quadro_platform/shared/routes/routes_constants.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:quadro_platform/shared/widgets/rounded_container.dart';
import 'package:sizer/sizer.dart';

import '../../../../shared/enum/maitenance_request_status.dart';
import '../../../../shared/widgets/requests_list.dart';

class RequestsList extends StatelessWidget {
  const RequestsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainScreenBloc, MainScreenState>(
      builder: (context, state) {
        final list = state.requests;
        final status = state.requestStatus;
        return SharedRequestsList(
          withoutRejectedRequests: true,
          requestType: RequestType.workshop_id,
          requests: list,
          status: status,
          noRequestsMessage: "لا يوجد طلبات حاليا",
          errorMessage: "حدث خطاء في تحميل الطلبات",
          buttonTitle: "تقديم عرض",
          buttonColor: Qcolors.secondary,
          backgroundColor: Qcolors.getPrimeryColor(context),
          onRequestDetails: (request, requestType) {
            NavigationService().routeTo(
              RoutesConstants.requestDetails,
              arguments: {
                'request': request,
                'requestType': requestType,
              },
            );
          },
        );
      },
    );
  }
}
