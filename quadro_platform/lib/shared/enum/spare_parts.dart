enum SparePartsStatus {
  New,
  used,
  imported,
  none;
}

extension SparePartsStatusExtension on SparePartsStatus {
  // Convert enum to string
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

  // Convert string to enum
  static SparePartsStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case "new":
        return SparePartsStatus.New;
      case "used":
        return SparePartsStatus.used;
      case "imported":
        return SparePartsStatus.imported;
      case "none":
        return SparePartsStatus.none;
      default:
        throw ArgumentError("Invalid status string: $status");
    }
  }
}
