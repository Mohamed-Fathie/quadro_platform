import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/workshop_main_screen/models/maintenance_request_data_model.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';
import 'package:quadro_platform/shared/enum/offer_status.dart';
import 'package:quadro_platform/shared/widgets/request_templet.dart';
import 'package:sizer/sizer.dart';

import '../../../../shared/routes/navigation_service.dart';
import '../../../../shared/routes/routes_constants.dart';
import '../../../../shared/utils/constans/colors.dart';
import '../../cubit/offers_cubit.dart';

class ListOfOffers extends StatelessWidget {
  final List<MaintenanceRequestDomainModel> offers;
  final RequestType requestType;
  const ListOfOffers(
      {super.key, required this.offers, required this.requestType});

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
                ?.apply(color: Qcolors.getColorForRequestType(requestType)),
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
                requestStatus: request.requestStatus.arabicName,
                city: request.workshop.city,
                street: request.workshop.street,
                requestType: requestType,
                buttonTitle: requestType == RequestType.vehicle_owner_id
                    ? "تفاصيل الطلب"
                    : "تقديم عرض",
                navigatorCall: () {
                  NavigationService().routeTo(
                    RoutesConstants.requestDetails,
                    arguments: {
                      'request': request,
                      'requestType': requestType,
                    },
                  );
                },
                carBrand: request.carCompany.name,
                carModel: request.carModel.name,
                dateCreated: request.dateCreated,
                userName: request.user.name ?? "null user",
              ),
            );
          }
          return Padding(
              padding: EdgeInsets.symmetric(vertical: 5.w),
              child: RequestTemplet(
                requestStatus: request.requestStatus.arabicName,
                city: request.workshop.city,
                street: request.workshop.street,
                requestType: requestType,
                isOffer: true,
                buttonTitle: "تفاصيل",
                offerStatus: request.offer!.status.arabicName,
                servicePrice: request.offer!.servicePrice.toString(),
                navigatorCall: () async {
                  final result = await NavigationService().routeTo(
                    RoutesConstants.requestDetails,
                    arguments: {
                      'request': request,
                      'requestType': requestType,
                    },
                  );

                  // Refresh if result indicates a change
                  if (result == true) {
                    final currentState = context.read<OffersCubit>().state;
                    final currentIndex = currentState.index;
                    context
                        .read<OffersCubit>()
                        .handleOfferFilterChange(currentIndex, requestType);
                  }
                },
                carBrand: request.carCompany.name,
                carModel: request.carModel.name,
                dateCreated: request.offer!.dateCreated.toDate(),
                userName: request.user.name ?? "null user",
              ));
        },
      ).toList(),
    );
  }
}
