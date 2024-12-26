import 'package:all_helps_dfg_win_25/models/models.dart';
import 'package:all_helps_dfg_win_25/services/firebase_service.dart';
import 'package:firebase_dart/firebase_dart.dart';

/// A utility class that handles search functionality against Firebase Realtime Database.
///
/// This class provides methods to search through indexed content in Firebase, with support for:
/// - Text-based searching across titles and descriptions
/// - Optional category filtering
/// - Configurable result limits
/// 
/// Example usage:
/// ```dart
/// final searchValidator = SearchValidator(firebaseService);
/// final results = await searchValidator.search(
///   query: 'example',
///   category: 'articles',
///   limit: 5
/// );
/// ```
class SearchValidator {
  /// Creates a new [SearchValidator] instance.
  ///
  /// Parameters:
  ///   - firebaseService: The [FirebaseService] instance used to interact with Firebase
  SearchValidator(this._firebaseService);

  final FirebaseService _firebaseService;

  /// Gets a reference to the SearchIndex node in Firebase Realtime Database.
  DatabaseReference get _searchRef =>
      _firebaseService.realtimeDatabase.reference().child('SearchIndex');

  /// Performs a search operation against the search index.
  ///
  /// Parameters:
  ///   - query: The search text to match against titles and descriptions
  ///   - category: Optional category to filter results (if null, searches all categories)
  ///   - limit: Maximum number of results to return (defaults to 10)
  ///
  /// Returns:
  ///   A List of [SearchResult] objects matching the search criteria
  ///
  /// Throws:
  ///   Any Firebase exceptions that occur during the operation
  Future<List<SearchResult>> search({
    required String query,
    String? category,
    int limit = 10,
  }) async {
    try {
      Query searchQuery = _searchRef;

      // If category is provided, filter by it
      if (category != null) {
        searchQuery = searchQuery.orderByChild('category').equalTo(category);
      }

      // Get the snapshot
      final snapshot = await searchQuery.get();

      if (snapshot.value == null) {
        return [];
      }

      // Convert to List<SearchResult>
      final results = <SearchResult>[];
      final data = Map<String, dynamic>.from(snapshot.value as Map);

      for (final item in data.values) {
        final searchResult = SearchResult.fromJson(
          Map<String, dynamic>.from(item as Map),
        );

        // Apply text search filter
        if (_matchesSearch(searchResult, query)) {
          results.add(searchResult);
        }

        // Apply limit
        if (results.length >= limit) {
          break;
        }
      }

      return results;
    } catch (e) {
      rethrow;
    }
  }

  /// Checks if a search result matches the search query.
  ///
  /// Parameters:
  ///   - result: The [SearchResult] to check
  ///   - query: The search query to match against
  ///
  /// Returns:
  ///   true if the result matches the query, false otherwise
  bool _matchesSearch(SearchResult result, String query) {
    final searchLower = query.toLowerCase();
    return result.title.toLowerCase().contains(searchLower) ||
        result.description.toLowerCase().contains(searchLower);
  }
}
