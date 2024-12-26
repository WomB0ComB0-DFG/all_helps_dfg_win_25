/// A model class representing a search result item.
///
/// This class encapsulates all the data related to a single search result, including:
/// - A unique identifier
/// - Title and description of the content
/// - Optional category classification
/// - Optional metadata for additional properties
///
/// Example usage:
/// ```dart
/// final result = SearchResult(
///   id: '123',
///   title: 'Example Title',
///   description: 'Example description text',
///   category: 'articles'
/// );
///
/// // Convert to JSON
/// final json = result.toJson();
///
/// // Create from JSON
/// final fromJson = SearchResult.fromJson(json);
/// ```
class SearchResult {
  /// Creates a new [SearchResult] instance.
  ///
  /// Parameters:
  ///   - id: Unique identifier for the search result
  ///   - title: The title or heading of the content
  ///   - description: A brief description or excerpt of the content
  ///   - category: Optional category classification (e.g., 'articles', 'products')
  ///   - metadata: Optional additional data as key-value pairs
  SearchResult({
    required this.id,
    required this.title,
    required this.description,
    this.category,
    this.metadata,
  });

  /// Creates a [SearchResult] instance from a JSON map.
  ///
  /// Parameters:
  ///   - json: Map containing the search result data
  ///
  /// Returns:
  ///   A new [SearchResult] instance populated with the JSON data
  factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        category: json['category'] as String?,
        metadata: json['metadata'] != null
            ? Map<String, dynamic>.from(json['metadata'] as Map)
            : null,
      );

  /// The unique identifier of the search result
  final String id;

  /// The title or heading of the content
  final String title;

  /// A brief description or excerpt of the content
  final String description;

  /// Optional category classification (e.g., 'articles', 'products')
  final String? category;

  /// Optional additional data as key-value pairs
  final Map<String, dynamic>? metadata;

  /// Converts the [SearchResult] instance to a JSON map.
  ///
  /// Returns:
  ///   A Map containing the search result data in JSON format
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        if (category != null) 'category': category,
        if (metadata != null) 'metadata': metadata,
      };
}
