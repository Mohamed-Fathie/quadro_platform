import 'package:flutter/material.dart';
import 'package:quadro_platform/shared/utils/extension/date_formating.dart';
import 'package:sizer/sizer.dart';

import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/section_row.dart';
import '../../../workshop_main_screen/repository/models/offers.dart';

class OfferDetails extends StatelessWidget {
  final Offer offer;
  const OfferDetails({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 3.h,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SectionHeader(
          text: "تفاصيل العرض :",
          displayLarge: true,
        ),
        SectionRow(
            label: "مبلغ الصيانة :",
            value: "${offer.servicePrice.toString()}   LYD"),
        SectionRow(
            label: "مدة الضمان :",
            value: "${offer.guaranteePeriod.toString()}   يوم  "),
        SectionRow(
            label: "حالة القطع التي ستستخدم للصيانة :",
            value: offer.sparePartsStatus.name),
        SectionRow(label: "حالة العرض :", value: offer.status.name),
        SectionRow(
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
