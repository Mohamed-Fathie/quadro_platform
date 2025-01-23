import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/shared/enum/request_status.dart';
import 'package:sizer/sizer.dart';

import '../../../../shared/enum/maitenance_request_status.dart';
import '../../../../shared/routes/navigation_service.dart';
import '../../../../shared/routes/routes_constants.dart';
import '../../../../shared/utils/constans/colors.dart';
import '../../../../shared/widgets/requests_list.dart';
import '../../../../shared/widgets/rounded_container.dart';
import '../../bloc/main_screenbloc_bloc.dart';
import '../../../../shared/widgets/request_templet.dart';

class OffersList extends StatelessWidget {
  const OffersList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainScreenBloc, MainScreenState>(
      builder: (context, state) {
        final list = state.offers;
        final status = state.requestStatus;
        return SharedRequestsList(
          isOffer: true,
          requestType: RequestType.workshop_id,
          requests: list ?? [],
          status: status,
          noRequestsMessage: "لا يوجد طلبات حاليا",
          errorMessage: "حدث خطاء في تحميل الطلبات",
          buttonTitle: "تفاصيل",
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
