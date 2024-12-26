import 'package:dart_frog/dart_frog.dart';

/// Health check endpoint that returns the API status
///
/// This endpoint provides a simple health check to verify the API is running
/// and responding to requests properly.
///
/// Parameters:
///   - context: The [RequestContext] containing request information
///
/// Returns:
///   A [Response] with JSON body containing:
///   - status: String indicating API status ('ok')
///   - status_code: Integer HTTP status code (200)
///
/// Example response:
/// ```json
/// {
///   "status": "ok",
///   "status_code": 200
/// }
/// ```
Future<Response> onRequest(RequestContext context) async {
  return Response.json(body: {'status': 'ok', 'status_code': 200});
}
