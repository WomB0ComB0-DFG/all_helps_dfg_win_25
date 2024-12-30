import 'package:dart_frog/dart_frog.dart';
import 'package:all_helps_dfg_win_25/services/firebase_service.dart';
import 'package:all_helps_dfg_win_25/repositories/search_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      try {
        final uri = context.request.uri;
        final queryParams = uri.queryParameters;

        // Extract search parameters
        final searchQuery = queryParams['q'];
        final category = queryParams['category'];
        final limit = int.tryParse(queryParams['limit'] ?? '10');

        // Validate required parameters
        if (searchQuery == null || searchQuery.isEmpty) {
          return Response.json(
            statusCode: 400,
            body: {'error': 'Search query is required'},
          );
        }

        // Get Firebase service from context
        final firebaseService = await context.read<Future<FirebaseService>>();
        final searchRepo = SearchRepository(firebaseService);

        // Perform search
        final results = await searchRepo.search(
          query: searchQuery,
          category: category,
          limit: limit ?? 10,
        );

        // Return results
        return Response.json(
          body: {
            'status': 'success',
            'results': results.map((r) => r.toJson()).toList(),
            'count': results.length,
          },
        );
      } catch (e) {
        return Response.json(
          statusCode: 500,
          body: {
            'status': 'error',
            'message': 'Internal server error',
            'error': e.toString(),
          },
        );
      }
    case HttpMethod.head:
      return Response.json(
        statusCode: 200,
        body: {
          'status': 'success',
          'message': 'Search index is ready',
        },
      );
    case HttpMethod.options:
      return Response.json(
        body: {
          'status': 'success',
          'message': "GET, HEAD, OPTIONS"
        }
      );
    case HttpMethod.post:
    case HttpMethod.put:
    case HttpMethod.delete:
    case HttpMethod.patch:
      return Response.json(
        statusCode: 405,
        body: {
          'status': 'error',
          'message': 'Method not allowed',
        },
      );
  }
}
