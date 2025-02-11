import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:quadro_platform/features/user/model/user.dart';
import 'package:quadro_platform/features/workshop_authentication/models/firestore_exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/enum/user_role.dart';

class UserRepository {
  final FirebaseAuth _auth;
  final FirebaseDatabase _database;
  late final DatabaseReference userRef;

  UserRepository({FirebaseAuth? auth, FirebaseDatabase? database})
      : _auth = auth ?? FirebaseAuth.instance,
        _database = database ?? FirebaseDatabase.instance {
    userRef = _database.ref();
  }

  /// Adds or updates a user in the database.
  Future<void> addUser(QuadroUser user) async {
    try {
      userRef.child('User/${user.id}').set(user.toJson());
      await cacheUser(user);
    } on FirebaseException catch (e) {
      throw FirestoreReadWriteFailure.fromCode(
          e.code); // Assuming you have this class
    }
  }

  Future<void> addUserToFirebaseAuth(
      String name, String email, String? phone, String imageUrl) async {
    final user = _auth.currentUser!;

    await user.updateProfile(displayName: name, photoURL: imageUrl);
    await user.reload();
    await addUser(QuadroUser.fromFirebaseAuth(
        id: user.uid,
        name: user.displayName,
        email: user.email ?? "",
        phone: phone));
  }

// getter for user id from firebase auth
  String? get getuserId => _auth.currentUser?.uid;

  /// Gets the current user, if authenticated.
  Future<QuadroUser?> getCurrentUser() async {
    final firebaseAuthUser = _auth.currentUser;
    if (firebaseAuthUser == null) return null;

    try {
      return QuadroUser.fromFirebaseAuth(
          id: firebaseAuthUser.uid,
          name: firebaseAuthUser.displayName,
          email: firebaseAuthUser.email,
          phone: firebaseAuthUser.phoneNumber,
          pictureUrl: firebaseAuthUser.photoURL);
    } on FirebaseException catch (e) {
      throw FirestoreReadWriteFailure.fromCode(e.code);
    }
  }

  /// Retrieves a user by ID from Firestore.
  Future<QuadroUser?> getUserById(String id) async {
    try {
      final docSnapshot = await userRef.child('User/$id').get();
      // Check if the snapshot contains data
      log(docSnapshot.value.toString());
      if (docSnapshot.exists) {
        // Convert the snapshot value to a Map and then to a QuadroUser object
        return QuadroUser.fromJson(
            Map<String, dynamic>.from(docSnapshot.value as Map), id);
      } else {
        // Return null if the user doesn't exist
        return null;
      }
    } on FirebaseException catch (e) {
      throw FirestoreReadWriteFailure.fromCode(e.code);
    }
  }

//Cache User Data
  static Future<void> cacheUser(QuadroUser user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = user.toJson();
    await prefs.setString('cached_user', jsonEncode(userJson));
  }

  //Retrieve Cached User Data
  Future<QuadroUser?> getCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('cached_user');
    if (userString != null) {
      final userJson = jsonDecode(userString) as Map<String, dynamic>;
      return QuadroUser.fromJson(userJson, userJson['user_id']);
    }
    return null;
  }

  Stream<UserRole?> get user {
    return _auth.authStateChanges().asyncMap(
      (firebaseUsre) async {
        if (firebaseUsre == null) {
          return null;
        }
        try {
          final userRole = (await getUserById(firebaseUsre.uid))?.role;
          return userRole;
        } on FirebaseException catch (e) {
          throw FirestoreReadWriteFailure.fromCode(e.code);
        }
      },
    );
  }

  // Clear Cached User Data when log out or delete account
  static Future<void> clearCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_user');
    // await prefs.clear();
  }

  /// map of user by their ids : helper function  to get all users related to specific  requests
  Future<Map<String, QuadroUser>> fetchUsers(Set<String> userIds) async {
    final Map<String, QuadroUser> users = {};

    // Fetch each user individually
    for (final userId in userIds) {
      log(userId);
      final user = await getUserById(userId);
      log(user?.name ?? "user is null");
      if (user != null) {
        users[userId] = user;
      }
    }

    return users;
  }
}
