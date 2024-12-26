import 'dart:io';

/// Firebase API key required for authentication and API access
///
/// This constant retrieves the API key from environment variables.
/// The API key must be set in the environment as 'API_KEY'.
///
/// Throws:
///   - [Exception] if API_KEY environment variable is not set
String apiKey = Platform.environment['API_KEY'] ??
    (() {
      throw Exception('API_KEY is not set');
    })();