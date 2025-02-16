enum CarModels {
  // Toyota
  toyotaCorolla,
  toyotaHilux,
  toyotaLandCruiser,
  toyotaCamry,
  toyotaPrado,

  // Ford
  fordRanger,
  fordExplorer,
  fordEdge,
  fordFocus,
  fordF150,

  // Honda
  hondaCivic,
  hondaAccord,
  hondaCRV,
  hondaCity,

  // BMW
  bmw3Series,
  bmw5Series,
  bmwX5,
  bmwX3,

  // Mercedes
  mercedesCClass,
  mercedesEClass,
  mercedesGClass,
  mercedesSClass,
  mercedesGLC,

  // Audi
  audiA4,
  audiA6,
  audiQ5,
  audiQ7,

  // Hyundai
  hyundaiElantra,
  hyundaiTucson,
  hyundaiAccent,
  hyundaiSonata,
  hyundaiSantaFe,

  // Kia
  kiaCerato,
  kiaSportage,
  kiaSorento,
  kiaOptima,
  kiaRio,

  // Nissan
  nissanAltima,
  nissanSunny,
  nissanPatrol,
  nissanXTrail,
  nissanSentra,

  // Chevrolet
  chevroletMalibu,
  chevroletTahoe,
  chevroletSilverado,
  chevroletCruze,
  chevroletAveo,
}

extension CarModelsExtension on CarModels {
  String toArabic() {
    switch (this) {
      // Toyota
      case CarModels.toyotaCorolla:
        return "كورولا";
      case CarModels.toyotaHilux:
        return "هايلوكس";
      case CarModels.toyotaLandCruiser:
        return "لاند كروزر";
      case CarModels.toyotaCamry:
        return "كامري";
      case CarModels.toyotaPrado:
        return "برادو";

      // Ford
      case CarModels.fordRanger:
        return "رينجر";
      case CarModels.fordExplorer:
        return "إكسبلورر";
      case CarModels.fordEdge:
        return "إيدج";
      case CarModels.fordFocus:
        return "فوكس";
      case CarModels.fordF150:
        return "إف 150";

      // Honda
      case CarModels.hondaCivic:
        return "سيفيك";
      case CarModels.hondaAccord:
        return "أكورد";
      case CarModels.hondaCRV:
        return "سي آر-في";
      case CarModels.hondaCity:
        return "سيتي";

      // BMW
      case CarModels.bmw3Series:
        return "الفئة الثالثة";
      case CarModels.bmw5Series:
        return "الفئة الخامسة";
      case CarModels.bmwX5:
        return "إكس 5";
      case CarModels.bmwX3:
        return "إكس 3";

      // Mercedes
      case CarModels.mercedesCClass:
        return "سي كلاس";
      case CarModels.mercedesEClass:
        return "إي كلاس";
      case CarModels.mercedesGClass:
        return "جي كلاس";
      case CarModels.mercedesSClass:
        return "إس كلاس";
      case CarModels.mercedesGLC:
        return "جي إل سي";

      // Audi
      case CarModels.audiA4:
        return "إيه 4";
      case CarModels.audiA6:
        return "إيه 6";
      case CarModels.audiQ5:
        return "كيو 5";
      case CarModels.audiQ7:
        return "كيو 7";

      // Hyundai
      case CarModels.hyundaiElantra:
        return "إلنترا";
      case CarModels.hyundaiTucson:
        return "توكسون";
      case CarModels.hyundaiAccent:
        return "أكسنت";
      case CarModels.hyundaiSonata:
        return "سوناتا";
      case CarModels.hyundaiSantaFe:
        return "سانتافي";

      // Kia
      case CarModels.kiaCerato:
        return "سيراتو";
      case CarModels.kiaSportage:
        return "سبورتاج";
      case CarModels.kiaSorento:
        return "سورينتو";
      case CarModels.kiaOptima:
        return "أوبتيما";
      case CarModels.kiaRio:
        return "ريو";

      // Nissan
      case CarModels.nissanAltima:
        return "ألتيما";
      case CarModels.nissanSunny:
        return "صني";
      case CarModels.nissanPatrol:
        return "باترول";
      case CarModels.nissanXTrail:
        return "إكس تريل";
      case CarModels.nissanSentra:
        return "سنترا";

      // Chevrolet
      case CarModels.chevroletMalibu:
        return "ماليبو";
      case CarModels.chevroletTahoe:
        return "تاهو";
      case CarModels.chevroletSilverado:
        return "سيلفرادو";
      case CarModels.chevroletCruze:
        return "كروز";
      case CarModels.chevroletAveo:
        return "أفيو";
    }
  }
}
