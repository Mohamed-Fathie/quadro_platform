import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quadro_platform/features/user/model/user.dart' as user;
import 'package:quadro_platform/features/workshop_authentication/models/firestore_exceptions.dart';
import 'package:quadro_platform/shared/utils/hleper_function/list_splitter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firebaseFirestore;
  late final CollectionReference<user.User> userRef;

  UserRepository({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firebaseFirestore = firestore ?? FirebaseFirestore.instance {
    userRef = _firebaseFirestore.collection("Users").withConverter<user.User>(
          fromFirestore: (snapshot, _) => user.User.fromJson(snapshot.data()!),
          toFirestore: (user, _) => user.toJson(),
        );
  }

  /// Adds or updates a user in the database.
  Future<void> addUser(user.User user) async {
    try {
      await userRef.doc(user.id).set(user);
      await cacheUser(user);
    } on FirebaseException catch (e) {
      throw FirestoreReadWriteFailure.fromCode(
          e.code); // Assuming you have this class
    }
  }

  /// Gets the current user, if authenticated.
  Future<user.User?> getCurrentUser() async {
    final firebaseAuthUser = _auth.currentUser;
    if (firebaseAuthUser == null) return null;

    try {
      return user.User.fromFirebaseAuth(
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
  Future<user.User> getUserById(String id) async {
    try {
      final docSnapshot = await userRef.doc(id).get();
      return docSnapshot.data()!;
      // Returns null if the document doesn't exist: means deleted account
    } on FirebaseException catch (e) {
      throw FirestoreReadWriteFailure.fromCode(e.code);
    }
  }

  /// Updates specific fields of a user in Firestore.
  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    try {
      await userRef.doc(userId).update(updates);
      // Update the cache after Firestore update
      final cachedUser = await getUserById(userId);
      await cacheUser(cachedUser);
    } on FirebaseException catch (e) {
      throw FirestoreReadWriteFailure.fromCode(e.code);
    }
  }

//Cache User Data
  Future<void> cacheUser(user.User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = user.toJson();
    await prefs.setString('cached_user', jsonEncode(userJson));
  }

  //Retrieve Cached User Data
  Future<user.User?> getCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('cached_user');
    if (userString != null) {
      final userJson = jsonDecode(userString) as Map<String, dynamic>;
      return user.User.fromJson(userJson);
    }
    return null;
  }

  // Clear Cached User Data when log out or delete account
  Future<void> clearCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_user');
  }

  /// map of user by their ids : helper function  to get all users related to specific maintenance requests
  Future<Map<String, user.User>> fetchUsers(Set<String> userIds) async {
    final List<List<String?>> chunks = splitIntoChunks(userIds.toList(), 10);

    final List<Future<Map<String, user.User>>> futures = chunks.map(
      (chunk) async {
        final snapshot =
            await userRef.where(FieldPath.documentId, whereIn: chunk).get();
        return {for (var doc in snapshot.docs) doc.id: doc.data()};
      },
    ).toList();
    final result = await Future.wait(futures);
    return result.fold<Map<String, user.User>>(
      {},
      (previousValue, element) => {...previousValue, ...element},
    );
  }
}
