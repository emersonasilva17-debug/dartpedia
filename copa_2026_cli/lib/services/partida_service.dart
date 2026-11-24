// Version: 0.0.0
// Aluno 2: Gerenciador de Partidas e Placar (Lições 02, 06 e 08)
import 'dart:io';
import '../models/selecao.dart';

class PartidaService {
  final List<PartidaRegistrada> historicoPartidas = [];

  int _lerInteiroValido(String prompt) {
    while (true) {
      stdout.write(prompt);
      final entrada = stdin.readLineSync();
      try {
        if (entrada == null || entrada.trim().isEmpty) {
          throw const FormatException('Entrada vazia');
        }
        final valor = int.parse(entrada.trim());
        if (valor < 0) {
          throw const FormatException('Valor negativo');
        }
        return valor;
      } catch (_) {
        // Requisito Aluno 4: Tratamento elegante de erro no placar
        print('Erro: Digite um placar válido!');
      }
    }
  }

  void registrarJogo(Selecao timeA, Selecao timeB) {
    print('\n--- REGISTRAR PARTIDA: ${timeA.nome} x ${timeB.nome} ---');

    final golsA = _lerInteiroValido('Gols de ${timeA.nome}: ');
    final golsB = _lerInteiroValido('Gols de ${timeB.nome}: ');

    final amarelosA = _lerInteiroValido('Cartões Amarelos (${timeA.nome}): ');
    final vermelhosA = _lerInteiroValido('Cartões Vermelhos (${timeA.nome}): ');

    final amarelosB = _lerInteiroValido('Cartões Amarelos (${timeB.nome}): ');
    final vermelhosB = _lerInteiroValido('Cartões Vermelhos (${timeB.nome}): ');

    // Atualiza gols e cartões
    timeA.golsPro += golsA;
    timeA.golsSofridos += golsB;
    timeA.cartoesAmarelos += amarelosA;
    timeA.cartoesVermelhos += vermelhosA;

    timeB.golsPro += golsB;
    timeB.golsSofridos += golsA;
    timeB.cartoesAmarelos += amarelosB;
    timeB.cartoesVermelhos += vermelhosB;

    // Atualiza pontuação (3 por vitória, 1 por empate)
    if (golsA > golsB) {
      timeA.pontos += 3;
    } else if (golsB > golsA) {
      timeB.pontos += 3;
    } else {
      timeA.pontos += 1;
      timeB.pontos += 1;
    }

    historicoPartidas.add(
      PartidaRegistrada(
        timeA: timeA.nome,
        timeB: timeB.nome,
        golsA: golsA,
        golsB: golsB,
      ),
    );

    print(
      '\nPlacar registrado: ${timeA.nome} $golsA x $golsB ${timeB.nome}!',
    );
  }
}
