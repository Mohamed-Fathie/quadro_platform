// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/request_details_screen/veiw/widgets/offer_details.dart';
import 'package:quadro_platform/features/workshop_main_screen/models/maintenance_request_data_model.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/repository_manager.dart';
import 'package:quadro_platform/shared/enum/car_brands.dart';
import 'package:quadro_platform/shared/enum/car_models.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';
import 'package:quadro_platform/shared/enum/offer_status.dart';
import 'package:quadro_platform/shared/routes/routes_constants.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:quadro_platform/shared/utils/extension/date_formating.dart';
import 'package:quadro_platform/shared/widgets/custom_elevated_button.dart';
import 'package:quadro_platform/shared/widgets/details_appbar.dart';
import 'package:quadro_platform/shared/widgets/section_header.dart';
import 'package:quadro_platform/shared/widgets/section_row.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/routes/navigation_service.dart';
import '../cubit/details_cubit.dart';
import 'widgets/delete_fab.dart';
import 'widgets/delete_overlay.dart';
import 'widgets/inprogress.dart';
import 'widgets/overlay_indecator.dart';
import 'widgets/rateing.dart';
import 'widgets/respose_bar.dart';

class DetailsScreenPage extends StatelessWidget {
  final Map<String, dynamic> argument;
  const DetailsScreenPage({super.key, required this.argument});

  @override
  Widget build(BuildContext context) {
    final request = argument['request'] as MaintenanceRequestDomainModel;
    final requestType = argument['requestType'] as RequestType;
    final isDeletable = request.offer == null;
    final canRespond = requestType == RequestType.vehicle_owner_id &&
        !isDeletable &&
        request.offer?.status != OfferStatus.rejected &&
        request.offer?.status != OfferStatus.accepted &&
        request.offer?.status != OfferStatus.inprogress;
    return BlocProvider(
      create: (context) => DetailsCubit(
          context.read<RepositoryManager>().maintenanceRequestsRepository,
          context.read<RepositoryManager>().offersRepository,
          context.read<RepositoryManager>().reviewsRepository),
      child: DetailsView(
        canRespond: canRespond,
        isDeletable: isDeletable,
        request: request,
        requestType: requestType,
      ),
    );
  }
}

class DetailsView extends StatelessWidget {
  final bool isDeletable;
  final RequestType requestType;
  final MaintenanceRequestDomainModel request;
  final bool canRespond;
  DetailsView(
      {super.key,
      required this.isDeletable,
      required this.requestType,
      required this.request,
      required this.canRespond});
  bool get canMarkInProgress =>
      requestType == RequestType.workshop_id &&
      request.offer?.status == OfferStatus.accepted;
  bool get canRateService =>
      requestType == RequestType.vehicle_owner_id &&
      request.offer?.status == OfferStatus.inprogress &&
      request.requestStatus != MaitenanceRequestStatus.inProgress;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: canRateService
          ? buildRatingBottomBar(context, request)
          : canMarkInProgress
              ? buildWorkshopProgressBar(context, request)
              : canRespond
                  ? buildOfferResponseBar(context, request)
                  : null,
      floatingActionButton: _buildConditionalFab(context, request),
      backgroundColor: requestType == RequestType.vehicle_owner_id
          ? Qcolors.getPrimeryColor(context)
          : Qcolors.getCurrentColor(context),
      appBar: DetailsAppbar(
          isResponsable: requestType == RequestType.vehicle_owner_id
              ? canRespond == true
                  ? true
                  : null
              : null,
          isdeltable: requestType == RequestType.workshop_id
              ? isDeletable == true
                  ? true
                  : null
              : null,
          requestType: requestType,
          title: requestType == RequestType.vehicle_owner_id
              ? 'تفاصيل الطلب'
              : request.offer == null
                  ? "تقديم عرض"
                  : "تفاصيل العرض"),
      body: SafeArea(
          child: Stack(children: [
        Padding(
          padding: EdgeInsets.all(6.w),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 3.h,
                ),
                SectionHeader(
                  withIcon: Icons.description,
                  requestType: requestType,
                  text: " تفاصيل الطلب :",
                  displayLarge: true,
                ),
                SizedBox(
                  height: 3.h,
                ),
                SectionRow(
                  requestType: requestType,
                  imageUrl: requestType == RequestType.workshop_id
                      ? request.user.pictureUrl ??
                          "https://firebasestorage.googleapis.com/v0/b/quadro-204be.firebasestorage.app/o/Profile_Images%2Fdhdhdgg%40gmail.com42435c00-c43b-11ef-b85b-879b0d7d6b91?alt=media&token=ee320211-7794-4481-b66a-6d5f048f035b"
                      : request.workshop.imagePath,
                  label: requestType == RequestType.workshop_id
                      ? "اسم العميل:"
                      : "اسم الورشة",
                  value: request.workshop.name,
                ),
                SizedBox(
                  height: 1.h,
                ),
                request.offer == null
                    ? SectionRow(
                        requestType: requestType,
                        label: "حالة الطلب:",
                        value: request.requestStatus.arabicName)
                    : const SizedBox.shrink(),
                SizedBox(
                  height: 3.h,
                ),
                SectionRow(
                    requestType: requestType,
                    label: "تاريخ انشاء الطلب :",
                    value: request.dateCreated.formatInArabic()),
                SizedBox(
                  height: 3.h,
                ),
                SectionHeader(
                  requestType: requestType,
                  withIcon: Icons.directions_car,
                  text: "مواصفات المركبة :",
                  displayLarge: true,
                ),
                SizedBox(
                  height: 3.h,
                ),
                SectionRow(
                    requestType: requestType,
                    label: "تحديد شركة المركبة :",
                    value: request.carCompany.toArabic()),
                SizedBox(
                  height: 3.h,
                ),
                SectionRow(
                    requestType: requestType,
                    label: "تحديد نوع المركبة :",
                    value: request.carModel.toArabic()),
                SizedBox(
                  height: 3.h,
                ),
                SectionHeader(
                  requestType: requestType,
                  text: "وصف حالة المركبة :",
                ),
                SizedBox(
                  height: 3.h,
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
                SizedBox(
                  height: 3.h,
                ),
                SectionHeader(
                  requestType: requestType,
                  text: "صورة للمركبة :",
                ),
                SizedBox(
                  height: 3.h,
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
                SizedBox(
                  height: 3.h,
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
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              SizedBox(
                                height: 7.h,
                              ),
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomElevatedButton(
                                buttonColor: Qcolors.primarycolor,
                                buttonTitle: "تقديم عرض",
                                onPressed: () {
                                  NavigationService().routeTo(
                                      RoutesConstants.sendOffer,
                                      arguments: request);
                                },
                              ),
                              SizedBox(
                                height: 7.h,
                              ),
                            ],
                          )
                    : OfferDetails(
                        requestType: requestType, offer: request.offer!)
              ],
            ),
          ),
        ),
        requestType == RequestType.workshop_id
            ? isDeletable
                ? buildSwipeToDeleteOverlay(context)
                : const SizedBox.shrink()
            : const SizedBox.shrink(),
        requestType == RequestType.vehicle_owner_id
            ? canRespond
                ? buildSwipeActionsOverlay(context)
                : const SizedBox.shrink()
            : const SizedBox.shrink(),
      ])),
    );
  }

  Widget? _buildConditionalFab(
      BuildContext context, MaintenanceRequestDomainModel request) {
    if (requestType == RequestType.vehicle_owner_id) return null;

    return isDeletable ? buildDeleteFab(context, request) : null;
  }
}
