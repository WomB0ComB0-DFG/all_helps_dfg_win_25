import 'dart:convert';

import 'package:all_helps_dfg_win_25/exceptions/firebase_exception_code.dart';
import 'package:all_helps_dfg_win_25/models/models.dart';
import 'package:all_helps_dfg_win_25/repositories/user_repository.dart';
import 'package:all_helps_dfg_win_25/services/firebase_service.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:firebase_dart/firebase_dart.dart';

/// Handles user signup requests
///
/// This endpoint supports:
/// - POST: Create a new user account
/// - GET: Health check endpoint
///
/// POST request expects a JSON body with:
/// ```json
/// {
///   "email": "user@example.com",
///   "password": "userpassword"
/// }
/// ```
///
/// Returns:
/// - 200: Successful registration with userId
/// - 405: Method not allowed
/// - 500: Internal server error
///
/// Throws:
/// - [FirebaseException] for authentication/database errors
Future<Response> onRequest(RequestContext context) async {
  try {
    final request = context.request;
    final firebaseService = await context.read<Future<FirebaseService>>();
    final userRepository = UserRepository(firebaseService);

    switch (request.method) {
      case HttpMethod.post:
        // Parse and validate request body
        final requestBody = await request.body();
        final requestData = jsonDecode(requestBody) as Map<String, dynamic>;
        final userData = AuthUser.fromJson(requestData);

        // Create Firebase authentication user
        final credential =
            await firebaseService.firebaseAuth.createUserWithEmailAndPassword(
          email: userData.email,
          password: userData.password,
        );

        // Store additional user data in Realtime Database
        final userId = await userRepository.createUser(
          userData.copyWith(id: credential.user!.uid),
        );

        return Response.json(
          body: {
            'status': 200,
            'message': 'User registered successfully',
            'userId': userId,
          },
        );

      case HttpMethod.get:
        // Health check endpoint
        return Response.json(
          body: {
            'status': 200,
            'message': 'User registered successfully',
          },
        );

      default:
        return Response.json(
          body: {
            'status': 405,
            'message': 'Method not allowed',
          },
        );
    }
  } on FirebaseException catch (e) {
    // Handle specific Firebase authentication errors
    if (e.code == FirebaseExceptionCode.emailAlreadyInUse) {
      return Response.json(
        body: {
          'status': 200,
          'message': 'This email is already registered',
          'error': e.toString(),
        },
      );
    } else if (e.code == FirebaseExceptionCode.invalidEmail) {
      return Response.json(
        body: {
          'status': 200,
          'message': 'The email is not valid', 
          'error': e.toString(),
        },
      );
    }

    // Handle any other Firebase errors
    return Response.json(
      statusCode: 500,
      body: {
        'status': 500,
        'message': 'Something went wrong. Internal server error.',
        'error': e.toString(),
      },
    );
  }
}
