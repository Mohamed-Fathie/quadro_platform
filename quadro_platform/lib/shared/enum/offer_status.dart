enum OfferStatus {
  pending, //3
  inprogress, //4
  accepted,
  completed,
  rejected,
}

// Extension for OfferStatus
extension OfferStatusExtension on OfferStatus {
  String get arabicName {
    switch (this) {
      case OfferStatus.pending:
        return "بانتظار موافقة العميل";
      case OfferStatus.inprogress:
        return "قيد التنفيذ";
      case OfferStatus.accepted:
        return "مقبول";
      case OfferStatus.completed:
        return "مكتمل";
      case OfferStatus.rejected:
        return "مرفوض";
    }
  }
}
