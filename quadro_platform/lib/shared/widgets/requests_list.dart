import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quadro_platform/shared/enum/car_brands.dart';
import 'package:quadro_platform/shared/enum/car_models.dart';
import 'package:quadro_platform/shared/enum/offer_status.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:sizer/sizer.dart';

import '../../features/workshop_main_screen/models/maintenance_request_data_model.dart';
import '../enum/maitenance_request_status.dart';
import '../enum/request_status.dart';
import 'gradient_circular_progress.dart';
import 'request_templet.dart';
import 'rounded_container.dart';

class SharedRequestsList extends StatelessWidget {
  final List<MaintenanceRequestDomainModel>? requests;
  final bool? withoutRejectedRequests;
  final RequestStatus status;
  final String noRequestsMessage;
  final String? city;
  final String? street;
  final String errorMessage;
  final String buttonTitle;
  final Color buttonColor;
  final Color backgroundColor;
  final RequestType requestType;
  final bool? isOffer;
  final void Function(
    MaintenanceRequestDomainModel request,
    RequestType requestType,
  ) onRequestDetails;

  const SharedRequestsList({
    super.key,
    required this.requests,
    required this.status,
    this.noRequestsMessage = "لا يوجد طلبات حاليا",
    this.errorMessage = "حدث خطاء في تحميل الطلبات",
    this.buttonTitle = "تفاصيل الطلب",
    this.buttonColor = Colors.blue,
    required this.backgroundColor,
    required this.onRequestDetails,
    required this.requestType,
    this.isOffer,
    this.city,
    this.street,
    this.withoutRejectedRequests,
  });

  @override
  Widget build(BuildContext context) {
    bool hasNonRejectedRequest = requests?.any(
          (element) =>
              element.requestStatus != MaitenanceRequestStatus.rejected,
        ) ??
        false;
    return SizedBox(
      height: 45.h,
      child: Builder(
        builder: (context) {
          if (status == RequestStatus.failure) {
            return Center(
              child: Text(
                errorMessage,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: Colors.red),
              ),
            );
          }

          // Check for loading specific to the list type (offers vs. requests)
          if (status ==
              (isOffer == true
                  ? RequestStatus.offerloading
                  : RequestStatus.requestloading)) {
            return const GradientCircularProgress();
          }
          if (status == RequestStatus.loading) {
            return const GradientCircularProgress();
          }
          return requests == null
              ? const GradientCircularProgress()
              : requests!.isEmpty
                  ? RoundedContainer(
                      width: 80.w,
                      height: 35.h,
                      child: Center(
                        child: Text(
                          noRequestsMessage,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.apply(
                                  color: Qcolors.getColorForRequestType(
                                      requestType)),
                        ),
                      ),
                    )
                  : isOffer != null
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: requests!.length,
                          itemBuilder: (context, index) {
                            final offer = requests![index];
                            return RequestTemplet(
                              imageUrl:
                                  requestType == RequestType.vehicle_owner_id
                                      ? offer.workshop.imagePath
                                      : offer.user.pictureUrl,
                              city: offer.workshop.city,
                              street: offer.workshop.street,
                              requestType: RequestType.workshop_id,
                              isOffer: true,
                              buttonTitle: "تفاصيل",
                              offerStatus: offer.offer!.status.arabicName,
                              servicePrice:
                                  offer.offer!.servicePrice.toString(),
                              navigatorCall: () => onRequestDetails(
                                offer,
                                requestType,
                              ),
                              carBrand: offer.carCompany.toArabic(),
                              carModel: offer.carModel.toArabic(),
                              dateCreated: offer.offer!.dateCreated.toDate(),
                              userName:
                                  requestType == RequestType.vehicle_owner_id
                                      ? offer.workshop.name
                                      : offer.user.name ?? "",
                            );
                          },
                        )
                      : withoutRejectedRequests == null
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: requests!.length,
                              itemBuilder: (context, index) {
                                final request = requests![index];
                                return RequestTemplet(
                                  imageUrl: requestType ==
                                          RequestType.vehicle_owner_id
                                      ? request.workshop.imagePath
                                      : request.user.pictureUrl,
                                  requestStatus:
                                      request.requestStatus.arabicName,
                                  street: request.workshop.street,
                                  city: request.workshop.city,
                                  requestType: requestType,
                                  buttonColore: buttonColor,
                                  background: backgroundColor,
                                  buttonTitle: buttonTitle,
                                  navigatorCall: () =>
                                      onRequestDetails(request, requestType),
                                  carBrand: request.carCompany.toArabic(),
                                  carModel: request.carModel.toArabic(),
                                  dateCreated: request.dateCreated,
                                  userName: requestType ==
                                          RequestType.vehicle_owner_id
                                      ? request.workshop.name
                                      : request.user.name ?? "",
                                );
                              },
                            )
                          : !hasNonRejectedRequest
                              ? RoundedContainer(
                                  width: 80.w,
                                  height: 35.h,
                                  child: Center(
                                    child: Text(
                                      noRequestsMessage,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.apply(
                                            color:
                                                Qcolors.getColorForRequestType(
                                                    requestType),
                                          ),
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: requests!.length,
                                  itemBuilder: (context, index) {
                                    final request = requests![index];

                                    if (requestType ==
                                            RequestType.workshop_id &&
                                        withoutRejectedRequests != null &&
                                        request.requestStatus ==
                                            MaitenanceRequestStatus.rejected) {
                                      return const SizedBox
                                          .shrink(); // Skip rejected requests
                                    }

                                    return RequestTemplet(
                                        imageUrl: requestType ==
                                                RequestType.vehicle_owner_id
                                            ? request.workshop.imagePath
                                            : request.user.pictureUrl,
                                        requestStatus:
                                            request.requestStatus.arabicName,
                                        street: request.workshop.street,
                                        city: request.workshop.city,
                                        requestType: requestType,
                                        buttonColore: buttonColor,
                                        background: backgroundColor,
                                        buttonTitle: buttonTitle,
                                        navigatorCall: () => onRequestDetails(
                                            request, requestType),
                                        carBrand: request.carCompany.toArabic(),
                                        carModel: request.carModel.toArabic(),
                                        dateCreated: request.dateCreated,
                                        userName: requestType ==
                                                RequestType.vehicle_owner_id
                                            ? request.workshop.name
                                            : request.user.name ?? "");
                                  },
                                );
        },
      ),
    );
  }
}
// RequestTemplet(
//                           type: RequestType.workshop_id,
//                           isOffer: true,
//                           buttonTitle: "تفاصيل",
//                           offerStatus: offer.offer!.status.name,
//                           servicePrice: offer.offer!.servicePrice.toString(),
//                           navigatorCall: () => NavigationService().routeTo(
//                               RoutesConstants.requestDetails,
//                               arguments: offer),
//                           carBrand: offer.carCompany.name,
//                           carModel: offer.carModel.name,
//                           dateCreated: offer.offer!.dateCreated.toDate(),
//                           userName: offer.user.name,
//                         );
