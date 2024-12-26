import 'dart:async';

import 'package:all_helps_dfg_win_25/services/authenticate_request_middleware.dart';
import 'package:all_helps_dfg_win_25/services/firebase_service.dart';
import 'package:dart_frog/dart_frog.dart';

/// Global Firebase service instance used across the application
final firebaseService = FirebaseService();

/// Main middleware configuration function for the application
Handler middleware(Handler handler) {
  return handler.use(
    provider<Future<FirebaseService>>(
      (context) async {
        await firebaseService.init();
        return firebaseService;
      },
    ),
  ).use(authenticateRequest());
}
