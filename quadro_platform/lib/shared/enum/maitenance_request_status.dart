// ignore_for_file: constant_identifier_names

//request => pending ,sent => offer.pending ,
enum MaitenanceRequestStatus {
  pending, //1
  offerSent, //2
  rejected,
  inProgress,
  complted,
  accepted
}

// Extension for MaitenanceRequestStatus
extension MaitenanceRequestStatusExtension on MaitenanceRequestStatus {
  String get arabicName {
    switch (this) {
      case MaitenanceRequestStatus.pending:
        return "بانتظار العرض";
      case MaitenanceRequestStatus.offerSent:
        return "تم إرسال العرض";
      case MaitenanceRequestStatus.rejected:
        return "مرفوض";
      case MaitenanceRequestStatus.inProgress:
        return "قيد العمل";
      case MaitenanceRequestStatus.complted:
        return "اكتمل";
      case MaitenanceRequestStatus.accepted:
        return "مقبول";
    }
  }
}

// request type either from vehicle owner or workshop owner
enum RequestType {
  workshop_id,
  vehicle_owner_id,
}
