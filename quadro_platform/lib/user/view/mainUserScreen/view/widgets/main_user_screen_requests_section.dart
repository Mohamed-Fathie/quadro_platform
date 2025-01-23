import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/workshop_main_screen/models/maintenance_request_data_model.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';
import 'package:quadro_platform/user/view/mainUserScreen/bloc/main_screen_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../shared/routes/navigation_service.dart';
import '../../../../../shared/routes/routes_constants.dart';
import '../../../../../shared/utils/constans/colors.dart';
import '../../../../../shared/widgets/request_templet.dart';
import '../../../../../shared/widgets/rounded_container.dart';

class RequestsList extends StatelessWidget {
  const RequestsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final list =
        context.select((MainUserScreenBloc bloc) => bloc.state.requests);
    return SizedBox(
      height: 45.h,
      child: BlocSelector<MainUserScreenBloc, MainUserScreenState,
          MainUserScreenStatus>(
        selector: (state) {
          return state.status;
        },
        builder: (context, state) {
          if (state == MainUserScreenStatus.requestFailure) {
            return const Center(
              child: Text(
                "حدث خطاء في تحميل الطلبات",
              ),
            );
          }
          if (state == MainUserScreenStatus.reqestloading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Qcolors.secondary,
              ),
            );
          }

          return list.isEmpty
              ? RoundedContainer(
                  width: 80.w,
                  height: 35.h,
                  child: Center(
                    child: Text(
                      "لا يوجد طلبات حاليا",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.apply(color: Qcolors.secondary),
                    ),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final request = list[index];
                    final Map<RequestType, MaintenanceRequestDomainModel>
                        argument;
                    return RequestTemplet(
                      requestType: RequestType.vehicle_owner_id,
                      buttonColore: Qcolors.secondary,
                      background: Qcolors.getPrimeryColor(context),
                      buttonTitle: "تفاصيل الطلب",
                      navigatorCall: () => NavigationService().routeTo(
                          RoutesConstants.requestDetails,
                          arguments: request),
                      carBrand: request.carCompany.name,
                      carModel: request.carModel.name,
                      dateCreated: request.dateCreated,
                      userName: request.user.name,
                    );
                  },
                );
        },
      ),
    );
  }
}
