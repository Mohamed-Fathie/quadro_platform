import 'package:flutter/material.dart';

enum CarBrand {
  Toyota,
  Ford,
  Honda,
  BMW,
  Mercedes,
  Audi,
  Hyundai,
  Kia,
  Nissan,
  Chevrolet;
}

extension CarBrandExtension on CarBrand {
  // Convert enum to string
  String toJson() {
    return toString().split('.').last;
  }

  // Convert string to enum
  static CarBrand fromString(String value) {
    return CarBrand.values.firstWhere((e) => e.toJson() == value);
  }

  // Get an icon representing the car brand
  IconData get icon {
    switch (this) {
      case CarBrand.Toyota:
        return Icons.directions_car;
      case CarBrand.Ford:
        return Icons.local_shipping;
      case CarBrand.Honda:
        return Icons.two_wheeler;
      case CarBrand.BMW:
        return Icons.sports_bar;
      case CarBrand.Mercedes:
        return Icons.abc_outlined;
      case CarBrand.Audi:
        return Icons.drive_eta;
      case CarBrand.Hyundai:
        return Icons.electric_car;
      case CarBrand.Kia:
        return Icons.car_rental;
      case CarBrand.Nissan:
        return Icons.electric_bike;
      case CarBrand.Chevrolet:
        return Icons.car_repair;
    }
  }
}
