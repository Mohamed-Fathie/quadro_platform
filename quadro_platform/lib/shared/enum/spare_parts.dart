import 'package:flutter/material.dart';

enum SparePartsStatus {
  New,
  used,
  imported,
  none;
}

extension SparePartsStatusExtension on SparePartsStatus {
  // Convert enum to string
  String toJson() {
    return toString().split('.').last;
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

  IconData get icon {
    switch (this) {
      case SparePartsStatus.New:
        return Icons.new_releases; // Icon for 'New'
      case SparePartsStatus.used:
        return Icons.replay_circle_filled; // Icon for 'Used'
      case SparePartsStatus.imported:
        return Icons.import_export; // Icon for 'Imported'
      case SparePartsStatus.none:
      default:
        return Icons.help_outline; // Default icon for 'None'
    }
  }

  String get label {
    switch (this) {
      case SparePartsStatus.New:
        return "جديدة";
      case SparePartsStatus.used:
        return "مستعمل";
      case SparePartsStatus.imported:
        return "استيراد";
      case SparePartsStatus.none:
      default:
        return "لا يوجد";
    }
  }
}
