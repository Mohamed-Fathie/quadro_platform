enum OffersFilter {
  all,
  requests,

  inprogress,
  pending,
}

extension Filter on OffersFilter {
  String get label {
    switch (this) {
      case OffersFilter.all:
        return "الكل";
      case OffersFilter.inprogress:
        return "قيد التنفيد";
      case OffersFilter.pending:
        return "بانتظار الموافقة";
      case OffersFilter.requests:
        return "الطلبات";
    }
  }
}
