import 'package:quadro_platform/shared/enum/user_role.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole? role;
  final String pictureUrl;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.role,
    required this.pictureUrl,
  });

  /// Creates a User instance from a FirebaseAuth User object.
  factory User.fromFirebaseAuth({
    required String id,
    required String? name,
    required String? email,
    required String? phone,
    required String? pictureUrl,
  }) {
    return User(
      id: id,
      name: name ?? "",
      email: email ?? "",
      phone: phone ?? "",
      role: null,
      pictureUrl: pictureUrl ?? "",
    );
  }

  // Factory to create an instance from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      role: UserRole.values.byName(json['role']), // Parse enum by name
      pictureUrl: json['picture_url'] as String,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role!.name, // Convert enum to string
      'picture_url': pictureUrl,
    };
  }
}
