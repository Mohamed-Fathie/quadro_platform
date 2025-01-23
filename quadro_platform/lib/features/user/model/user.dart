import 'package:quadro_platform/shared/enum/user_role.dart';

class QuadroUser {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final UserRole? role;
  final String? pictureUrl;

  const QuadroUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.role,
    this.pictureUrl,
  });

  /// Creates a QuadroUser instance from a FirebaseAuth QuadroUser object.
  factory QuadroUser.fromFirebaseAuth({
    required String id,
    required String? name,
    required String? email,
    required String? phone,
    String? pictureUrl,
  }) {
    return QuadroUser(
      id: id,
      name: name ?? "",
      email: email ?? "",
      phone: phone ?? "",
      role: null,
      pictureUrl: pictureUrl ?? "",
    );
  }

  // Factory to create an instance from JSON
  factory QuadroUser.fromJson(Map<String, dynamic> json, String id) {
    return QuadroUser(
      id: id, // Use email as ID if no user_id is provided
      name: json['name'] as String,
      email: json['email'] as String,
      phone:
          json['mobileNumber']?.toString(), // Convert to string if it's an int
      role: null, // Map userType to role
      pictureUrl:
          json['profilePicUrl'] as String?, // Map profilePicUrl to pictureUrl
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': "", // Convert enum to string
      'profile_picture': pictureUrl,
    };
  }
}
