enum UserRole {
  vehicleOwner,
  workshopOwner,
  towService,
}

extension UserRoleExtension on String {
  UserRole? toUserRole() {
    if (contains('مالك مركبة')) {
      return UserRole.vehicleOwner;
    } else if (contains('مالك ورشة')) {
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
}
