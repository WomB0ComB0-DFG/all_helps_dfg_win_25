import 'package:all_helps_dfg_win_25/config/configuration.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

/// Middleware that authenticates incoming requests by validating JWT tokens.
///
/// This middleware function validates the JWT token provided in the request's
/// Authorization header. It uses HS256 signature verification with a secret key
/// defined in the application configurations.
///
/// Usage:
/// ```dart
/// // Apply middleware to a route
/// Handler middleware = authenticateRequest();
/// ```
///
/// The middleware:
/// 1. Extracts the Authorization header from the request
/// 2. Validates the JWT token signature
/// 3. Returns true if token is valid, false otherwise
///
/// Returns:
///   A [Middleware] function that provides a boolean indicating if the request
///   is authenticated (true) or not (false).
///
/// Throws:
///   No exceptions are thrown - validation failures return false
Middleware authenticateRequest() {
  return provider<bool>((context) {
    final request = context.request;
    final headers = request.headers;
    final authData = headers['Authorization'];

    try {
      final receivedToken = authData!.trim();
      verifyJwtHS256Signature(
        receivedToken,
        Configurations.secretJwt,
      );
      return true;
    } catch (e) {
      return false;
    }
  });
}
