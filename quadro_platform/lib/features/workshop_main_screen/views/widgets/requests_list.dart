import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/workshop_main_screen/bloc/main_screenbloc_bloc.dart';
import 'package:quadro_platform/features/workshop_main_screen/models/maintenance_request_data_model.dart';
import 'package:quadro_platform/features/workshop_main_screen/views/widgets/service_templet.dart';
import 'package:quadro_platform/shared/routes/navigation_service.dart';
import 'package:quadro_platform/shared/routes/routes_constants.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:quadro_platform/shared/widgets/rounded_container.dart';
import 'package:sizer/sizer.dart';

class RequestsList extends StatelessWidget {
  const RequestsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final list = context.select((MainScreenBloc bloc) => bloc.state.requests);

    return SizedBox(
      height: 45.h,
      child: BlocSelector<MainScreenBloc, MainScreenState, MainScreenStatus>(
        selector: (state) {
          return state.status;
        },
        builder: (context, state) {
          if (state == MainScreenStatus.requestFailure) {
            return const Center(
              child: Text(
                "حدث خطاء في تحميل الطلبات",
              ),
            );
          }

          return list == null
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Qcolors.primarycolor,
                  ),
                )
              : list.isEmpty
                  ? RoundedContainer(
                      width: 80.w,
                      height: 35.h,
                      child: Center(
                        child: Text(
                          "لا يوجد طلبات حاليا",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.apply(color: Qcolors.primarycolor),
                        ),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final request = list[index];
                        return ServiceTemplet(
                          buttonTitle: "تقديم عرض",
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
