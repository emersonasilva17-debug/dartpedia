// Version: 0.0.0
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> getWikipediaArticle(String articleTitle) async {
  final url = Uri.https(
    'en.wikipedia.org',
    '/api/rest_v1/page/summary/$articleTitle',
  );

  final response = await http.get(
    url,
    headers: {
      'User-Agent': 'DartpediaApp/1.0 (https://dart.dev; contato@exemplo.com)',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data['extract'] as String? ?? 'Resumo não encontrado.';
  } else {
    throw Exception(
      'Falha ao buscar artigo "$articleTitle" (Status: ${response.statusCode})',
    );
  }
}
