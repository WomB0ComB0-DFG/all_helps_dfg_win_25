/// A model class representing an authenticated user in the system.
///
/// This class contains user authentication and profile information including:
/// - Unique identifier (optional)
/// - Display name (optional) 
/// - Email address (required)
/// - Password (required)
///
/// Example usage:
/// ```dart
/// final user = AuthUser(
///   email: 'user@example.com',
///   password: 'password123',
///   name: 'John Doe'
/// );
/// ```
class AuthUser {
  /// Creates a new [AuthUser] instance.
  ///
  /// Parameters:
  ///   - email: The user's email address (required)
  ///   - password: The user's password (required)
  ///   - id: Optional unique identifier
  ///   - name: Optional display name
  AuthUser({
    required this.email,
    required this.password,
    this.id,
    this.name,
  });

  /// Creates an [AuthUser] instance from a JSON map.
  ///
  /// Parameters:
  ///   - json: Map containing user data with keys matching field names
  ///
  /// The JSON map must contain 'email' and 'password' keys with string values.
  /// Optional keys are 'id' and 'name'.
  AuthUser.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        name = json['name'] as String?,
        email = json['email'] as String,
        password = json['password'] as String;

  /// Converts this user instance to a JSON map.
  ///
  /// Returns a Map with keys matching the field names and their current values.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'email': email,
        'password': password,
      };

  /// Optional unique identifier for the user
  final String? id;

  /// Optional display name for the user
  final String? name;

  /// The user's email address
  final String email;

  /// The user's password
  final String password;

  /// Creates a copy of this user with optionally updated fields.
  ///
  /// Parameters:
  ///   - id: New ID value (optional)
  ///   - name: New name value (optional)
  ///   - email: New email value (optional)
  ///   - password: New password value (optional)
  ///
  /// Returns a new [AuthUser] instance with updated fields, keeping existing
  /// values for any parameter that is null.
  AuthUser copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
  }) =>
      AuthUser(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
      );
}
