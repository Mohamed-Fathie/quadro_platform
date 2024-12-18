// ignore_for_file: constant_identifier_names

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

  String toArabic() {
    switch (this) {
      case CarBrand.Toyota:
        return "تويوتا";
      case CarBrand.Ford:
        return "فورد";
      case CarBrand.Honda:
        return "هوندا";
      case CarBrand.BMW:
        return "بي إم دبليو";
      case CarBrand.Mercedes:
        return "مرسيدس";
      case CarBrand.Audi:
        return "أودي";
      case CarBrand.Hyundai:
        return "هيونداي";
      case CarBrand.Kia:
        return "كيا";
      case CarBrand.Nissan:
        return "نيسان";
      case CarBrand.Chevrolet:
        return "شيفروليه";
    }
  }

  // Get an svg representing the car brand
  String get svgPath {
    switch (this) {
      case CarBrand.Toyota:
        return 'assets/images/car_brands/download (4).png';
      case CarBrand.Ford:
        return 'assets/images/car_brands/download (5).png';
      case CarBrand.Honda:
        return 'assets/images/car_brands/download (3).png';
      case CarBrand.BMW:
        return 'assets/images/car_brands/download (6).png';
      case CarBrand.Mercedes:
        return 'assets/images/car_brands/download (8).png';
      case CarBrand.Audi:
        return 'assets/images/car_brands/icons8-audi-200.png';
      case CarBrand.Hyundai:
        return 'assets/images/car_brands/download (9).png';
      case CarBrand.Kia:
        return 'assets/images/car_brands/download (1).png';
      case CarBrand.Nissan:
        return 'assets/images/car_brands/download (2).png';
      case CarBrand.Chevrolet:
        return 'assets/images/car_brands/download.png';
    }
  }
}
