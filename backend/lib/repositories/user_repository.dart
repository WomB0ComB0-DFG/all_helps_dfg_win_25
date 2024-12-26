import 'package:all_helps_dfg_win_25/models/models.dart';
import 'package:all_helps_dfg_win_25/services/firebase_service.dart';
import 'package:firebase_dart/firebase_dart.dart';

/// Repository class that handles user data operations with Firebase Realtime Database.
///
/// This class provides methods to perform CRUD operations on user data, including:
/// - Creating new users
/// - Reading user data by ID or email
/// - Updating existing user data
/// - Deleting users
/// - Searching and listing users
///
/// Example usage:
/// ```dart
/// final userRepo = UserRepository(firebaseService);
/// final user = await userRepo.getUserById('123');
/// ```
class UserRepository {
  /// Creates a new [UserRepository] instance.
  ///
  /// Requires a [FirebaseService] instance to interact with Firebase.
  UserRepository(this._firebaseService);

  final FirebaseService _firebaseService;

  /// Gets a reference to the Users node in Firebase Realtime Database.
  DatabaseReference get _usersRef =>
      _firebaseService.realtimeDatabase.reference().child('Users');

  /// Retrieves a user by their unique ID.
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user to retrieve
  ///
  /// Returns:
  ///   - [AuthUser] if found
  ///   - null if no user exists with the given ID
  ///
  /// Throws:
  ///   - Any Firebase exceptions that occur during the operation
  Future<AuthUser?> getUserById(String userId) async {
    try {
      final snapshot = await _usersRef.child(userId).get();
      if (snapshot.value != null) {
        return AuthUser.fromJson(
          Map<String, dynamic>.from(snapshot.value as Map),
        );
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Retrieves a user by their email address.
  ///
  /// Parameters:
  ///   - email: The email address to search for
  ///
  /// Returns:
  ///   - [AuthUser] if found
  ///   - null if no user exists with the given email
  ///
  /// Throws:
  ///   - Any Firebase exceptions that occur during the operation
  Future<AuthUser?> getUserByEmail(String email) async {
    try {
      final snapshot = await _usersRef
          .orderByChild('email')
          .equalTo(email)
          .limitToFirst(1)
          .get();

      if (snapshot.value != null) {
        final userMap = Map<String, dynamic>.from(
          (snapshot.value as Map).values.first as Map,
        );
        return AuthUser.fromJson(userMap);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Creates a new user in the database.
  ///
  /// Parameters:
  ///   - user: The [AuthUser] object containing the user data to store
  ///
  /// Returns:
  ///   The unique ID assigned to the new user
  ///
  /// Throws:
  ///   - Any Firebase exceptions that occur during the operation
  Future<String> createUser(AuthUser user) async {
    try {
      final newUserRef = _usersRef.push();
      await newUserRef.set(user.toJson());
      return newUserRef.key!;
    } catch (e) {
      rethrow;
    }
  }

  /// Updates an existing user's data.
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user to update
  ///   - user: The [AuthUser] object containing the updated user data
  ///
  /// Throws:
  ///   - Any Firebase exceptions that occur during the operation
  Future<void> updateUser(String userId, AuthUser user) async {
    try {
      await _usersRef.child(userId).update(user.toJson());
    } catch (e) {
      rethrow;
    }
  }

  /// Deletes a user from the database.
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user to delete
  ///
  /// Throws:
  ///   - Any Firebase exceptions that occur during the operation
  Future<void> deleteUser(String userId) async {
    try {
      await _usersRef.child(userId).remove();
    } catch (e) {
      rethrow;
    }
  }

  /// Retrieves all users from the database.
  ///
  /// Returns:
  ///   A list of [AuthUser] objects representing all users in the database.
  ///   Returns an empty list if no users exist.
  ///
  /// Throws:
  ///   - Any Firebase exceptions that occur during the operation
  Future<List<AuthUser>> getAllUsers() async {
    try {
      final snapshot = await _usersRef.get();
      if (snapshot.value != null) {
        final usersMap = Map<String, dynamic>.from(snapshot.value as Map);
        return usersMap.values
            .map(
              (userData) => AuthUser.fromJson(
                Map<String, dynamic>.from(userData as Map),
              ),
            )
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// Searches for users by name.
  ///
  /// Performs a case-sensitive prefix search on user names.
  ///
  /// Parameters:
  ///   - name: The name prefix to search for
  ///
  /// Returns:
  ///   A list of [AuthUser] objects whose names start with the given prefix.
  ///   Returns an empty list if no matches are found.
  ///
  /// Throws:
  ///   - Any Firebase exceptions that occur during the operation
  Future<List<AuthUser>> searchUsersByName(String name) async {
    try {
      final snapshot = await _usersRef
          .orderByChild('name')
          .startAt(name)
          .endAt('$name\uf8ff')
          .get();

      if (snapshot.value != null) {
        final usersMap = Map<String, dynamic>.from(snapshot.value as Map);
        return usersMap.values
            .map(
              (userData) => AuthUser.fromJson(
                Map<String, dynamic>.from(userData as Map),
              ),
            )
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }
}
