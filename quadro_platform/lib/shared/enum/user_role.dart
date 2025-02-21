enum UserRole {
  vehicleOwner,
  workshopOwner,
  towService,
}

extension UserRoleExtension on String {
  UserRole? toUserRole() {
    if (contains('تسجيل كمستخدم عادي')) {
      return UserRole.vehicleOwner;
    } else if (contains('التسجيل كصاحب ورشة')) {
      return UserRole.workshopOwner;
    } else if (contains('التسجيل كصاحب ساحبة')) {
      return UserRole.towService;
    }
    return null; // Handle unknown cases
  }

  UserRole? toUser() {
    if (contains('مالك مركبة')) {
      return UserRole.vehicleOwner;
    } else if (contains("مالك ورشة")) {
      return UserRole.workshopOwner;
    } else if (contains('مقدم خدمة السحب')) {
      return UserRole.towService;
    }
    return null; // Handle unknown cases
  }
}

extension UserRoleStringExtension on UserRole {
  String toLabel() {
    switch (this) {
      case UserRole.vehicleOwner:
        return 'مالك مركبة';
      case UserRole.workshopOwner:
        return "مالك ورشة";
      case UserRole.towService:
        return 'مقدم خدمة السحب';
    }
  }

  String toJson() {
    switch (this) {
      case UserRole.vehicleOwner:
        return "تسجيل كمستخدم عادي";
      case UserRole.workshopOwner:
        return "التسجيل كصاحب ورشة";
      case UserRole.towService:
        return "التسجيل كصاحب ساحبة";
    }
  }
}
