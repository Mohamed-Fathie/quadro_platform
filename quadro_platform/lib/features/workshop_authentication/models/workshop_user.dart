class Workshop {
  final String name;
  final String owner_id;
  final String description;
  final String phone;
  final SparePartsStatus status;
  final List<String> carBrands;
}

enum SparePartsStatus {
  // ignore: constant_identifier_names
  New,
  used,
  imported,
  none;
}

extension on SparePartsStatus {
  String statustoString() {
    switch (this) {
      case SparePartsStatus.New:
        return "new";
      case SparePartsStatus.used:
        return "used";

      case SparePartsStatus.imported:
        return "imported";

      case SparePartsStatus.none:
        return "none";
    }
  }

  String toArabic() {
    switch (this) {
      case SparePartsStatus.New:
        return "";
      case SparePartsStatus.used:
        return "";

      case SparePartsStatus.imported:
        return "";

      case SparePartsStatus.none:
        return "";
    }
  }
}
