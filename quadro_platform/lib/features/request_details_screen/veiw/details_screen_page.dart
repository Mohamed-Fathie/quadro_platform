import 'package:flutter/material.dart';
import 'package:quadro_platform/features/request_details_screen/veiw/widgets/offer_details.dart';
import 'package:quadro_platform/features/workshop_main_screen/models/maintenance_request_data_model.dart';
import 'package:quadro_platform/shared/enum/car_brands.dart';
import 'package:quadro_platform/shared/enum/car_models.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';
import 'package:quadro_platform/shared/routes/routes_constants.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:quadro_platform/shared/utils/constans/helper_functions.dart';
import 'package:quadro_platform/shared/utils/extension/date_formating.dart';
import 'package:quadro_platform/shared/widgets/custom_elevated_button.dart';
import 'package:quadro_platform/shared/widgets/section_header.dart';
import 'package:quadro_platform/shared/widgets/section_row.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/routes/navigation_service.dart';

class DetailsScreenPage extends StatelessWidget {
  final Map<String, dynamic> argument;
  const DetailsScreenPage({super.key, required this.argument});

  @override
  Widget build(BuildContext context) {
    final request = argument['request'] as MaintenanceRequestDomainModel;
    final requestType = argument['requestType'] as RequestType;
    return Scaffold(
      backgroundColor: requestType == RequestType.vehicle_owner_id
          ? Qcolors.getPrimeryColor(context)
          : Qcolors.getCurrentColor(context),
      appBar: AppBar(
        backgroundColor: requestType == RequestType.vehicle_owner_id
            ? Qcolors.getPrimeryColor(context)
            : Qcolors.getCurrentColor(context),
        centerTitle: true,
        title: requestType == RequestType.vehicle_owner_id
            ? Text(
                'تفاصيل الطلب',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.apply(color: Qcolors.secondary),
              )
            : Text(
                request.offer == null ? "تقديم عرض" : "تفاصيل العرض",
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.apply(color: Qcolors.primarycolor),
              ),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(6.w),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            spacing: 3.h,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox.shrink(),
              SectionHeader(
                withIcon: Icons.description,
                requestType: requestType,
                text: " تفاصيل الطلب :",
                displayLarge: true,
              ),
              SectionRow(
                requestType: requestType,
                imageUrl:
                    // request.user.pictureUrl ??
                    "https://firebasestorage.googleapis.com/v0/b/quadro-204be.firebasestorage.app/o/Profile_Images%2Fdhdhdgg%40gmail.com42435c00-c43b-11ef-b85b-879b0d7d6b91?alt=media&token=ee320211-7794-4481-b66a-6d5f048f035b",
                label: "اسم العميل:",
                value: request.user.name,
              ),
              SectionRow(
                  requestType: requestType,
                  label: "حالة الطلب:",
                  value: request.requestStatus.name),
              SectionRow(
                  requestType: requestType,
                  label: "تاريخ انشاء الطلب :",
                  value: request.dateCreated.formatInArabic()),
              SectionHeader(
                requestType: requestType,
                withIcon: Icons.directions_car,
                text: "مواصفات المركبة :",
                displayLarge: true,
              ),
              SectionRow(
                  requestType: requestType,
                  label: "تحديد شركة المركبة :",
                  value: request.carCompany.toArabic()),
              SectionRow(
                  requestType: requestType,
                  label: "تحديد نوع المركبة :",
                  value: request.carModel.toArabic()),
              SectionHeader(
                requestType: requestType,
                text: "وصف حالة المركبة :",
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  textDirection: TextDirection.rtl,
                  request.description,
                  softWrap: true,
                  style: Theme.of(context).textTheme.headlineMedium?.apply(
                      color: Qcolors.getColorForRequestType(requestType)),
                ),
              ),
              SectionHeader(
                requestType: requestType,
                text: "صورة للمركبة :",
              ),
              request.carImageUrl != null
                  ? Image.network(
                      width: 85.w,
                      height: 30.h,
                      fit: BoxFit.contain,
                      request.carImageUrl!)
                  : Text(
                      " لا يوجد صورة",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
              request.offer == null
                  ? requestType == RequestType.vehicle_owner_id
                      ? Column(
                          spacing: 3.h,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SectionHeader(
                                withIcon: Icons.attach_money,
                                text: "تفاصيل العرض :",
                                requestType: requestType),
                            Text(
                              "لا يوجد عرض الى الان",
                              style: Theme.of(context).textTheme.headlineMedium,
                            )
                          ],
                        )
                      : CustomElevatedButton(
                          buttonColor: Qcolors.primarycolor,
                          buttonTitle: "تقديم عرض",
                          onPressed: () {
                            NavigationService().routeTo(
                                RoutesConstants.sendOffer,
                                arguments: request);
                          },
                        )
                  : OfferDetails(
                      requestType: requestType, offer: request.offer!)
            ],
          ),
        ),
      )),
    );
  }
}

// final String id;
//   final QuadroUser user;
//   final Workshop workshop;
//   final CarBrand carCompany;
//   final CarModels carModel;
//   final String description;
//   final String? carImageUrl;
//   final MaitenanceRequestStatus requestStatus;
//   final DateTime dateCreated;
//   final Offer? offer;
