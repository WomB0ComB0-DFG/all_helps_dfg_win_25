import 'dart:convert';

import 'package:all_helps_dfg_win_25/config/configuration.dart';
import 'package:all_helps_dfg_win_25/exceptions/firebase_exception_code.dart';
import 'package:all_helps_dfg_win_25/models/user/user_model.dart';
import 'package:all_helps_dfg_win_25/services/firebase_service.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:firebase_dart/firebase_dart.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

/// Handles HTTP requests for user login functionality.
///
/// This endpoint accepts POST requests with user credentials and returns a JWT token
/// upon successful authentication.
///
/// Parameters:
///   - context: The [RequestContext] containing request information and dependencies
///
/// Returns:
///   - A [Response] object containing the result of the login attempt:
///     - On success: 200 status with JWT token
///     - On invalid credentials: 200 status with error message
///     - On other errors: 500 status with error details
///     - On invalid HTTP method: 404 status
///
/// Throws:
///   - [FirebaseException] for authentication-related errors
Future<Response> onRequest(RequestContext context) async {
  try {
    final request = context.request;
    final firebaseService = await context.read<Future<FirebaseService>>();

    switch (request.method) {
      case HttpMethod.post:
        final requestBody = await request.body();
        final requestData = jsonDecode(requestBody) as Map<String, dynamic>;
        final userData = AuthUser.fromJson(requestData);
        final credential = 
            await firebaseService.firebaseAuth.signInWithEmailAndPassword(
          email: userData.email,
          password: userData.password,
        );
        // Generate JWT token for authenticated user
        final token = issueJWTToken(credential.user!.uid);
        return Response.json(
          body: {
            'status': 200,
            'message': 'User logged in successfully',
            'token': token,
          },
        );
      default:
        return Response.json(
          statusCode: 404,
          body: {
            'status': 404,
            'message': 'invalid request',
          },
        );
    }
  } on FirebaseException catch (e) {
    if (e.code == FirebaseExceptionCode.userNotFound) {
      return Response.json(
        body: {
          'status': 200,
          'message': 'No user found for this email',
          'error': e.message,
        },
      );
    } else if (e.code == FirebaseExceptionCode.wrongPassword) {
      return Response.json(
        body: {
          'status': 200,
          'message': 'Password is not correct',
          'error': e.message,
        },
      );
    }

    return Response.json(
      statusCode: 500,
      body: {
        'status': 500,
        'message': 'Something went wrong. Internal server error.',
        'error': e.message,
      },
    );
  }
}

/// Generates a JWT token for an authenticated user.
///
/// Creates a signed JWT token containing user claims and configuration settings.
///
/// Parameters:
///   - usedId: The unique identifier of the authenticated user
///
/// Returns:
///   - A String containing the signed JWT token
///
/// The token includes:
///   - Subject claim: User ID
///   - Issuer claim: 'kennedykaroko'
///   - Type claim: 'authnresponse'
///   - Expiration: 24 hours from issuance
String issueJWTToken(String usedId) {
  final claimSet = JwtClaim(
    subject: usedId,
    issuer: 'kennedykaroko',
    otherClaims: <String, dynamic>{
      'typ': 'authnresponse',
    },
    maxAge: const Duration(hours: 24),
  );
  final token = issueJwtHS256(claimSet, Configurations.secretJwt);
  return token;
}
