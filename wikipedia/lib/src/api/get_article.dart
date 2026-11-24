// Version: 0.0.0
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/summary.dart';

Future<Summary> getWikipediaSummary(
  String articleTitle, {
  http.Client? client,
}) async {
  final httpClient = client ?? http.Client();
  final url = Uri.https(
    'en.wikipedia.org',
    '/api/rest_v1/page/summary/$articleTitle',
  );

  final response = await httpClient.get(
    url,
    headers: {
      'User-Agent': 'DartpediaApp/1.0 (https://dart.dev; contato@exemplo.com)',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return Summary.fromJson(data);
  } else {
    throw Exception(
      'Falha ao buscar o artigo "$articleTitle" (Status: ${response.statusCode})',
    );
  }
}
