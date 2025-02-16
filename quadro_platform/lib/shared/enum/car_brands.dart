// ignore_for_file: constant_identifier_names

import 'car_models.dart';

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

  /// Returns the list of models for this car brand.
  List<CarModels> get models {
    switch (this) {
      case CarBrand.Toyota:
        return [
          CarModels.toyotaCamry,
          CarModels.toyotaCorolla,
          CarModels.toyotaHilux,
          CarModels.toyotaLandCruiser,
          CarModels.toyotaPrado,
        ];
      case CarBrand.Ford:
        return [
          CarModels.fordRanger,
          CarModels.fordExplorer,
          CarModels.fordEdge,
          CarModels.fordFocus,
          CarModels.fordF150,
        ];
      case CarBrand.Honda:
        return [
          CarModels.hondaCivic,
          CarModels.hondaAccord,
          CarModels.hondaCRV,
          CarModels.hondaCity,
        ];
      case CarBrand.BMW:
        return [
          CarModels.bmw3Series,
          CarModels.bmw5Series,
          CarModels.bmwX5,
          CarModels.bmwX3,
        ];
      case CarBrand.Mercedes:
        return [
          CarModels.mercedesCClass,
          CarModels.mercedesEClass,
          CarModels.mercedesGClass,
          CarModels.mercedesSClass,
          CarModels.mercedesGLC,
        ];
      case CarBrand.Audi:
        return [
          CarModels.audiA4,
          CarModels.audiA6,
          CarModels.audiQ5,
          CarModels.audiQ7,
        ];
      case CarBrand.Hyundai:
        return [
          CarModels.hyundaiElantra,
          CarModels.hyundaiTucson,
          CarModels.hyundaiAccent,
          CarModels.hyundaiSonata,
          CarModels.hyundaiSantaFe,
        ];
      case CarBrand.Kia:
        return [
          CarModels.kiaCerato,
          CarModels.kiaSportage,
          CarModels.kiaSorento,
          CarModels.kiaOptima,
          CarModels.kiaRio,
        ];
      case CarBrand.Nissan:
        return [
          CarModels.nissanAltima,
          CarModels.nissanSunny,
          CarModels.nissanPatrol,
          CarModels.nissanXTrail,
          CarModels.nissanSentra,
        ];
      case CarBrand.Chevrolet:
        return [
          CarModels.chevroletMalibu,
          CarModels.chevroletTahoe,
          CarModels.chevroletSilverado,
          CarModels.chevroletCruze,
          CarModels.chevroletAveo,
        ];
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
