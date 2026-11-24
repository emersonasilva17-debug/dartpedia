// Version: 0.0.0

class SearchResultItem {
  final String title;
  final int pageId;
  final String snippet;

  const SearchResultItem({
    required this.title,
    required this.pageId,
    required this.snippet,
  });

  factory SearchResultItem.fromJson(Map<String, Object?> json) {
    if (json
        case {
          'title': final String title,
          'pageid': final int pageId,
          'snippet': final String snippet,
        }) {
      return SearchResultItem(
        title: title,
        pageId: pageId,
        snippet: snippet.replaceAll(RegExp(r'<[^>]*>'), ''),
      );
    }
    throw const FormatException('JSON inválido para SearchResultItem.');
  }
}

class SearchResults {
  final String query;
  final List<SearchResultItem> results;

  const SearchResults({
    required this.query,
    required this.results,
  });

  factory SearchResults.fromJson(String query, Map<String, Object?> json) {
    if (json case {'query': {'search': final List<Object?> items}}) {
      final parsed = items
          .whereType>()
          .map(SearchResultItem.fromJson)
          .toList();
      return SearchResults(query: query, results: parsed);
    }
    throw const FormatException('JSON inválido para SearchResults.');
  }
}
