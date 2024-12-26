import 'dart:io';

/// {@template configurations}
/// A utility class that provides access to application configuration values.
/// 
/// This class manages environment-based configuration for:
/// - JWT authentication secrets
/// - Firebase connection settings and credentials
/// 
/// Values are read from environment variables with fallbacks to default values.
/// {@endtemplate}
class Configurations {
  /// Gets the secret key used for JWT token signing/verification.
  ///
  /// Reads from JWT_SECRET environment variable.
  /// Falls back to 'secret' if not set.
  static String get secretJwt => Platform.environment['JWT_SECRET'] ?? 'secret';

  /// Gets the Firebase Realtime Database URL.
  ///
  /// Reads from FIREBASE_DATABASE_URL environment variable.
  /// Falls back to empty string if not set.
  static String get databaseUrl =>
      Platform.environment['FIREBASE_DATABASE_URL'] ?? '';

  /// Gets the complete Firebase configuration settings as a map.
  ///
  /// Returns a map containing all required Firebase config values:
  /// - apiKey: Firebase API key
  /// - authDomain: Firebase Auth domain
  /// - databaseURL: Realtime Database URL
  /// - projectId: Firebase project ID
  /// - storageBucket: Firebase Storage bucket
  /// - messagingSenderId: Firebase Cloud Messaging sender ID
  ///
  /// All values are read from corresponding environment variables.
  /// Falls back to empty strings if variables are not set.
  static Map<String, String> get firebaseConfig => {
        'apiKey': Platform.environment['FIREBASE_API_KEY'] ?? '',
        'authDomain': Platform.environment['FIREBASE_AUTH_DOMAIN'] ?? '',
        'databaseURL': Platform.environment['FIREBASE_DATABASE_URL'] ?? '',
        'projectId': Platform.environment['FIREBASE_PROJECT_ID'] ?? '',
        'storageBucket': Platform.environment['FIREBASE_STORAGE_BUCKET'] ?? '',
        'messagingSenderId':
            Platform.environment['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
      };
}
