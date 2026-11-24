// Version: 0.0.0

class SearchResultItem {
  final String title;
  final String description;
  final String url;

  const SearchResultItem({
    required this.title,
    required this.description,
    required this.url,
  });
}

class SearchResults {
  final String query;
  final List<SearchResultItem> results;

  const SearchResults({
    required this.query,
    required this.results,
  });

  factory SearchResults.fromOpenSearchJson(List<dynamic> json) {
    if (json.length < 4) {
      throw const FormatException('Formato JSON OpenSearch inválido.');
    }

    final query = json[0] as String;
    final titles = List<String>.from(json[1] as List);
    final descriptions = List<String>.from(json[2] as List);
    final urls = List<String>.from(json[3] as List);

    final items = <SearchResultItem>[];
    for (var i = 0; i < titles.length; i++) {
      items.add(
        SearchResultItem(
          title: titles[i],
          description: i < descriptions.length ? descriptions[i] : '',
          url: i < urls.length ? urls[i] : '',
        ),
      );
    }

    return SearchResults(query: query, results: items);
  }
}
