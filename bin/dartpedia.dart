import 'dart:io';
import 'package:dartpedia/wikipedia.dart';

const version = '0.0.2';

void main(List<String> arguments) async {
  if (arguments.isEmpty || arguments.first == 'help') {
    printUsage();
  } else if (arguments.first == 'version') {
    print('Dartpedia CLI version $version');
  } else if (arguments.first == 'search') {
    final inputArgs = arguments.length > 1 ? arguments.sublist(1) : <String>[];
    await searchWikipedia(inputArgs);
  } else {
    printUsage();
  }
}

void printUsage() {
  print('Uso: dart run bin/dartpedia.dart <comando> [argumentos]');
  print('Comandos:');
  print('  help               Mostra esta mensagem de ajuda');
  print('  version            Mostra a versão atual ($version)');
  print('  search <artigo>    Busca o resumo de um artigo na Wikipédia');
}

Future<void> searchWikipedia(List<String>? arguments) async {
  late String articleTitle;

  if (arguments == null || arguments.isEmpty) {
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
