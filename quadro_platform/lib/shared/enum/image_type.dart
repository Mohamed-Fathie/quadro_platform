enum ImageType {
  profile,
  idCard,
  tradeLicense,
  maintenance,
}

extension ImageTypePath on ImageType {
  String pathWithId(String userId) {
    switch (this) {
      case ImageType.profile:
        return 'User/$userId/profile_image.jpg';
      case ImageType.idCard:
        return 'workshop/$userId/id_card.jpg';
      case ImageType.tradeLicense:
        return 'workshop/$userId/trade_license.jpg';

      case ImageType.maintenance:
        return "MaintenanceRequests/$userId/uploaded_image.jpg";
    }
  }
}
