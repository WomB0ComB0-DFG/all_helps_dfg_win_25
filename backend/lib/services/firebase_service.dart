import 'package:all_helps_dfg_win_25/config/configuration.dart';
import 'package:firebase_dart/firebase_dart.dart';

/// A service class that manages Firebase initialization and provides access to Firebase services.
///
/// This class handles the initialization of Firebase core functionality and provides
/// access to commonly used Firebase services like Authentication and Realtime Database.
/// It follows a singleton pattern to ensure only one instance of Firebase is initialized.
///
/// Example usage:
/// ```dart
/// final firebaseService = FirebaseService();
/// await firebaseService.init();
/// final auth = firebaseService.firebaseAuth;
/// ```
class FirebaseService {
  /// Creates a new instance of [FirebaseService].
  ///
  /// The service must be initialized by calling [init] before using any Firebase features.
  FirebaseService();

  bool _initialized = false;
  FirebaseApp? _firebaseApp;
  FirebaseAuth? _firebaseAuth;
  FirebaseDatabase? _realtimeDatabase;

  /// Whether Firebase has been initialized.
  ///
  /// Returns true if [init] has been called successfully, false otherwise.
  bool get isInitialized => _initialized;

  /// The initialized Firebase application instance.
  ///
  /// Throws an [AssertionError] if accessed before initialization.
  FirebaseApp get firebaseApp {
    assert(_firebaseApp == null, 'FirebaseApp is not initialized');
    return _firebaseApp!;
  }

  /// The Firebase Authentication instance.
  ///
  /// Use this to access authentication related functionality like sign in/sign up.
  /// Throws an [AssertionError] if accessed before initialization.
  FirebaseAuth get firebaseAuth {
    assert(_firebaseAuth == null, 'FirebaseAuth is not initialized');
    return _firebaseAuth!;
  }

  /// The Firebase Realtime Database instance.
  ///
  /// Use this to access database operations like read/write.
  /// Throws an [AssertionError] if accessed before initialization.
  FirebaseDatabase get realtimeDatabase {
    assert(_realtimeDatabase == null, 'Realtime Database is not initialized');
    return _realtimeDatabase!;
  }

  /// Initializes Firebase and its core services.
  ///
  /// This method must be called before using any Firebase functionality.
  /// It initializes:
  /// - Firebase core
  /// - Firebase Authentication
  /// - Realtime Database
  ///
  /// If Firebase is already initialized, this method does nothing.
  ///
  /// Throws:
  ///   - [FirebaseException] if initialization fails
  Future<void> init() async {
    if (!_initialized) {
      FirebaseDart.setup();
      _firebaseApp = await Firebase.initializeApp(
        options: FirebaseOptions.fromMap(Configurations.firebaseConfig),
      );
      _firebaseAuth = FirebaseAuth.instanceFor(app: firebaseApp);
      _realtimeDatabase = FirebaseDatabase(
        app: firebaseApp,
        databaseURL: Configurations.databaseUrl,
      );
      _initialized = true;
    }
  }
}
