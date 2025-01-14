import 'package:flutter/material.dart';
import 'package:quadro_platform/features/workshop_main_screen/models/maintenance_request_data_model.dart';
import 'package:quadro_platform/shared/widgets/request_templet.dart';
import 'package:sizer/sizer.dart';

import '../../../../shared/routes/navigation_service.dart';
import '../../../../shared/routes/routes_constants.dart';
import '../../../../shared/utils/constans/colors.dart';

class ListOfOffers extends StatelessWidget {
  final List<MaintenanceRequestDomainModel> offers;
  const ListOfOffers({super.key, required this.offers});

  @override
  Widget build(BuildContext context) {
    if (offers.isEmpty) {
      return SizedBox(
        height: 50.h,
        child: Center(
          child: Text(
            "لا يوجد عروض حاليا",
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.apply(color: Qcolors.primarycolor),
          ),
        ),
      );
    }
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: offers.map(
        (request) {
          if (request.offer == null) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 5.w),
              child: RequestTemplet(
                buttonTitle: "تقديم عرض",
                navigatorCall: () => NavigationService().routeTo(
                    RoutesConstants.requestDetails,
                    arguments: request),
                carBrand: request.carCompany.name,
                carModel: request.carModel.name,
                dateCreated: request.dateCreated,
                userName: request.user.name,
              ),
            );
          }
          return Padding(
              padding: EdgeInsets.symmetric(vertical: 5.w),
              child: RequestTemplet(
                isOffer: true,
                buttonTitle: "تفاصيل",
                offerStatus: request.offer!.status.name,
                servicePrice: request.offer!.servicePrice.toString(),
                navigatorCall: () => NavigationService().routeTo(
                    RoutesConstants.requestDetails,
                    arguments: request),
                carBrand: request.carCompany.name,
                carModel: request.carModel.name,
                dateCreated: request.offer!.dateCreated.toDate(),
                userName: request.user.name,
              ));
        },
      ).toList(),
    );
  }
}
