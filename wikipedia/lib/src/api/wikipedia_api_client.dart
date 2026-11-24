// Version: 0.0.0
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../model/search_results.dart';
import '../model/summary.dart';

class WikipediaApiClient {
  final String language;
  final http.Client _client;

  WikipediaApiClient({
    this.language = 'en',
    http.Client? client,
  }) : _client = client ?? http.Client();

  String get _host => '$language.wikipedia.org';

  Map<String, String> get _defaultHeaders => const {
        'User-Agent': 'DartpediaCLI/0.1.0 (Educational Dart Project)',
        'Accept': 'application/json',
      };

  /// Obtém o resumo estruturado (REST v1) de um artigo específico.
  Future<Summary> getArticleSummary(String title) async {
    final normalizedTitle = title.trim().replaceAll(' ', '_');
    final uri = Uri.https(
      _host,
      '/api/rest_v1/page/summary/${Uri.encodeComponent(normalizedTitle)}',
    );

    final response = await _client.get(uri, headers: _defaultHeaders);
    final decoded = _decodeJsonResponse(response, resourceName: title);
    return Summary.fromJson(decoded);
  }

  /// Obtém o resumo de um artigo aleatório da Wikipédia.
  Future<Summary> getRandomSummary() async {
    final uri = Uri.https(_host, '/api/rest_v1/page/random/summary');

    final response = await _client.get(uri, headers: _defaultHeaders);
    final decoded = _decodeJsonResponse(response, resourceName: 'random');
    return Summary.fromJson(decoded);
  }

  /// Pesquisa artigos na Action API da Wikipédia usando queryParameters complexos.
  Future<SearchResults> searchArticles(
    String query, {
    int limit = 5,
  }) async {
    final uri = Uri.https(
      _host,
      '/w/api.php',
      <String, String>{
        'action': 'query',
        'list': 'search',
        'srsearch': query.trim(),
        'srlimit': limit.toString(),
        'utf8': '1',
        'format': 'json',
      },
    );

    final response = await _client.get(uri, headers: _defaultHeaders);
    final decoded = _decodeJsonResponse(response, resourceName: query);
    return SearchResults.fromJson(query, decoded);
  }

  Map<String, Object?> _decodeJsonResponse(
    http.Response response, {
    required String resourceName,
  }) {
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, Object?>) {
        return decoded;
      }
      throw const FormatException('Estrutura raiz do JSON inválida.');
    } else if (response.statusCode == 404) {
      throw HttpException('Recurso "$resourceName" não encontrado (HTTP 404).');
    } else {
      throw HttpException(
        'Falha na requisição à Wikipédia (HTTP ${response.statusCode}).',
      );
    }
  }

  void close() {
    _client.close();
  }
}
