// Version: 0.0.0
import 'dart:convert';
import 'package:test/test.dart';
import 'package:wikipedia/wikipedia.dart';

void main() {
  group('Desserialização JSON dos modelos da Wikipédia', () {
    test('Summary.fromJson converte JSON válido em objeto Summary', () {
      const sampleJson = '''
      {
        "title": "Dart",
        "titles": {
          "normalized": "Dart (programming language)"
        },
        "pageid": 12345,
        "description": "Programming language developed by Google",
        "extract": "Dart is a client-optimized language for fast apps on any platform."
      }
      ''';

      final map = jsonDecode(sampleJson) as Map<String, dynamic>;
      final summary = Summary.fromJson(map);

      expect(summary.title, equals('Dart (programming language)'));
      expect(summary.pageId, equals(12345));
      expect(summary.description, equals('Programming language developed by Google'));
      expect(summary.extract, contains('client-optimized language'));
    });

    test('Article.fromJson e toJson funcionam corretamente', () {
      const sampleJson = '{"title": "Flutter", "extract": "UI toolkit by Google."}';
      final article = Article.fromJson(jsonDecode(sampleJson) as Map<String, dynamic>);

      expect(article.title, equals('Flutter'));
      expect(article.extract, equals('UI toolkit by Google.'));
      expect(article.toJson(), equals({'title': 'Flutter', 'extract': 'UI toolkit by Google.'}));
    });

    test('SearchResults.fromOpenSearchJson converte lista OpenSearch corretamente', () {
      const openSearchJson = '''
      [
        "Dart",
        ["Dart", "Dartmouth College"],
        ["Programming language", "University in New Hampshire"],
        ["https://en.wikipedia.org/wiki/Dart", "https://en.wikipedia.org/wiki/Dartmouth_College"]
      ]
      ''';

      final results = SearchResults.fromOpenSearchJson(jsonDecode(openSearchJson) as List<dynamic>);

      expect(results.query, equals('Dart'));
      expect(results.results, hasLength(2));
      expect(results.results.first.title, equals('Dart'));
      expect(results.results.first.url, contains('wikipedia.org/wiki/Dart'));
    });

    test('SearchResults.fromOpenSearchJson lança FormatException para JSON incompleto', () {
      expect(
        () => SearchResults.fromOpenSearchJson(['Dart']),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
