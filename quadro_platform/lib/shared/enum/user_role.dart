enum UserRole {
  vehicleOwner,
  workshopOwner,
  towService,
}

extension UserRoleExtension on String {
  UserRole? toUserRole() {
    if (contains("تسجيل كمستخدم عادي")) {
      return UserRole.vehicleOwner;
    } else if (contains("التسجيل كصاحب ورشة")) {
      return UserRole.workshopOwner;
    } else if (contains("التسجيل كصاحب ساحبة")) {
      return UserRole.towService;
    }
    return null; // Handle unknown cases
  }
}
