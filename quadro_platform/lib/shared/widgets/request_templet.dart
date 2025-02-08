import 'package:flutter/material.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:quadro_platform/shared/utils/extension/date_formating.dart';
import 'package:quadro_platform/shared/widgets/custom_elevated_button.dart';
import 'package:quadro_platform/shared/widgets/rounded_container.dart';
import 'package:sizer/sizer.dart';

typedef CallbackNavigator = void Function();

class RequestTemplet<T> extends StatelessWidget {
  final String? imageUrl;
  final String? street;
  final String? requestStatus;
  final String? city;
  final String userName;
  final String carBrand;
  final String carModel;
  final String? servicePrice;
  final DateTime dateCreated;
  final String buttonTitle;
  final CallbackNavigator navigatorCall;
  final String? offerStatus;
  final bool? isOffer;
  final double? width;
  final RequestType requestType;
  final Color? buttonColore;
  final Color? background;
//
  const RequestTemplet(
      {super.key,
      this.imageUrl,
      this.city,
      this.street,
      required this.userName,
      required this.carBrand,
      required this.carModel,
      this.servicePrice,
      required this.dateCreated,
      required this.buttonTitle,
      required this.navigatorCall,
      this.offerStatus,
      this.isOffer,
      this.width,
      this.requestStatus,
      required this.requestType,
      this.buttonColore,
      this.background});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RoundedContainer(
          width: width ?? 80.w,
          height: 35.h,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              spacing: 20,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      requestType == RequestType.workshop_id
                          ? "العميل :"
                          : "ورشة :",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    RoundedContainer(
                      height: 50,
                      width: 50,
                      child: Image.network(
                        fit: BoxFit.cover,
                        imageUrl ??
                            "https://firebasestorage.googleapis.com/v0/b/quadro-204be.firebasestorage.app/o/Profile_Images%2Fdhdhdgg%40gmail.com42435c00-c43b-11ef-b85b-879b0d7d6b91?alt=media&token=ee320211-7794-4481-b66a-6d5f048f035b",
                      ),
                    ),
                    Expanded(
                      child: Text(userName,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.apply(
                                  color: Qcolors.getColorForRequestType(
                                      requestType))),
                    ),
                  ],
                ),
                if (requestType == RequestType.vehicle_owner_id)
                  Expanded(
                    child: Row(
                      spacing: 8,
                      children: [
                        Text(
                          "الموقع :",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                            "$city , ${(street == "Unknown street" ? "" : street)} ",
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.apply(
                                    color: Qcolors.getColorForRequestType(
                                        requestType))),
                      ],
                    ),
                  ),
                // if (requestType == RequestType.vehicle_owner_id)
                //   Expanded(
                //     child: Row(
                //       spacing: 8,
                //       children: [
                //         Text(
                //           "تاريخ الطلب :",
                //           style: Theme.of(context).textTheme.headlineMedium,
                //         ),
                //         Text(dateCreated.formatInArabic(),
                //             softWrap: true,
                //             style: Theme.of(context)
                //                 .textTheme
                //                 .headlineMedium
                //                 ?.apply(
                //                     color: Qcolors.getColorForRequestType(
                //                         requestType))),
                //       ],
                //     ),
                //   ),
                if (requestType == RequestType.vehicle_owner_id)
                  Expanded(
                    child: Row(
                      spacing: 8,
                      children: [
                        Text(
                          "حالة الطلب :",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(requestStatus ?? "unKnown status",
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.apply(
                                    color: Qcolors.getColorForRequestType(
                                        requestType))),
                      ],
                    ),
                  ),
                if (requestType != RequestType.vehicle_owner_id)
                  Expanded(
                    child: Row(
                      spacing: 8,
                      children: [
                        Text(
                          "نوع المركبة :",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(carBrand,
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.apply(
                                    color: Qcolors.getColorForRequestType(
                                        requestType))),
                      ],
                    ),
                  ),
                if (requestType != RequestType.vehicle_owner_id)
                  Expanded(
                    child: Row(
                      spacing: 8,
                      children: [
                        Text(
                          "موديل السيارة :",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(carModel,
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.apply(
                                    color: Qcolors.getColorForRequestType(
                                        requestType))),
                      ],
                    ),
                  ),
                servicePrice != null
                    ? Expanded(
                        child: Row(
                          spacing: 8,
                          textDirection: TextDirection.rtl,
                          children: [
                            Text(
                              "مبلغ الخدمة :",
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            Text("$servicePrice LYD",
                                softWrap: true,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.apply(
                                        color: Qcolors.getColorForRequestType(
                                            requestType))),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                offerStatus != null
                    ? Expanded(
                        flex: 2,
                        child: Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            Expanded(
                              child: Text(
                                offerStatus!,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.apply(color: Colors.blueAccent),
                              ),
                            ),
                            Expanded(
                              child: CustomElevatedButton(
                                buttonColor:
                                    Qcolors.getColorForRequestType(requestType),
                                buttonTitle: buttonTitle,
                                onPressed: navigatorCall,
                              ),
                            ),
                          ],
                        ))
                    : Expanded(
                        flex: 2,
                        child: CustomElevatedButton(
                          buttonColor:
                              Qcolors.getColorForRequestType(requestType),
                          buttonTitle: buttonTitle,
                          onPressed: navigatorCall,
                        ),
                      )
              ],
            ),
          ),
        ),
        requestType == RequestType.vehicle_owner_id
            ? const SizedBox.shrink()
            : Text(
                " تم ارسال ${isOffer != null ? "العرض" : "الطلب"} ${dateCreated.formatInArabic()}",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.apply(color: Qcolors.primarycolor),
              )
      ],
    );
  }
}
