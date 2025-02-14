import 'package:flutter/material.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';
import 'package:quadro_platform/shared/enum/offer_status.dart';
import 'package:quadro_platform/shared/enum/spare_parts.dart';
import 'package:quadro_platform/shared/utils/extension/date_formating.dart';
import 'package:sizer/sizer.dart';

import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/section_row.dart';
import '../../../workshop_main_screen/repository/models/offers.dart';

class OfferDetails extends StatelessWidget {
  final RequestType requestType;
  final Offer offer;
  const OfferDetails(
      {super.key, required this.offer, required this.requestType});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 3.h,
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionHeader(
          withIcon: Icons.attach_money,
          requestType: requestType,
          text: "تفاصيل العرض :",
          displayLarge: true,
        ),
        SectionRow(
            requestType: requestType,
            label: "مبلغ الصيانة :",
            value: "${offer.servicePrice.toString()}   LYD"),
        SectionRow(
            requestType: requestType,
            label: "مدة الضمان :",
            value: "${offer.guaranteePeriod.toString()}   يوم  "),
        SectionRow(
            requestType: requestType,
            label: "حالة القطع التي ستستخدم للصيانة :",
            value: offer.sparePartsStatus.label),
        SectionRow(
            requestType: requestType,
            label: "حالة العرض :",
            value: offer.status.arabicName),
        SectionRow(
            requestType: requestType,
            label: "تاريخ انشاء العرض :",
            value: offer.dateCreated.toDate().formatInArabic()),
        SizedBox(
          height: 10.h,
        )
      ],
    );
  }
}
// final String? id; // Auto-generated Document ID
//   final String workshopId; // Reference to Workshops/{UID}
//   final String requestId; // Reference to MaintenanceRequests/{UID}
//   final double servicePrice; // Service price as a number
//   final int guaranteePeriod; // Guarantee period as a string
//   final SparePartsStatus sparePartsStatus; // Enum for spare parts status
//   final OfferStatus status; // Enum for offer status
//   final Timestamp dateCreated;
