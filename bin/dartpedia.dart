import 'dart:io';
import 'package:command_runner/command_runner.dart';
import 'package:dartpedia/wikipedia.dart';

const version = '0.0.3';

void main(List<String> arguments) async {
  final runner = CommandRunner()
    ..registerCommand(
      'version',
      (_) => print('Dartpedia CLI version $version'),
      description: 'Exibe a versão atual ($version)',
    )
    ..registerCommand(
      'search',
      searchWikipedia,
      description: 'Busca o resumo de um artigo na Wikipédia',
    );

  await runner.run(arguments);
}

Future<void> searchWikipedia(List<String> arguments) async {
  late String articleTitle;

  if (arguments.isEmpty) {
    stdout.write('Digite o título do artigo para buscar: ');
    final inputFromStdin = stdin.readLineSync();
    if (inputFromStdin == null || inputFromStdin.isEmpty) {
      print('Nenhum título informado. Encerrando.');
      return;
    }
    articleTitle = inputFromStdin;
  } else {
    articleTitle = arguments.join('_');
  }

  print('Buscando "$articleTitle" na Wikipédia...\n');
  try {
    final summary = await getWikipediaArticle(articleTitle);
    print('=== $articleTitle ===');
    print(summary);
  } catch (e) {
    print('Erro na requisição: $e');
  }
}
