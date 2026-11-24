// Version: 0.0.0
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../model/summary.dart';

Future<Summary> fetchWikipediaSummary(String articleTitle) async {
  final encodedTitle = Uri.encodeComponent(articleTitle.trim());
  final url = Uri.https(
    'en.wikipedia.org',
    '/api/rest_v1/page/summary/$encodedTitle',
  );

  final response = await http.get(
    url,
    headers: {
      'User-Agent': 'DartpediaCLI/0.0.9 (Educational Dart Project)',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, Object?>) {
      return Summary.fromJson(decoded);
    }
    throw const FormatException('Formato raiz do JSON inesperado.');
  } else if (response.statusCode == 404) {
    throw HttpException('Artigo "$articleTitle" não encontrado (HTTP 404).');
  } else {
    throw HttpException(
      'Erro na API da Wikipédia: status ${response.statusCode}',
    );
  }
}
