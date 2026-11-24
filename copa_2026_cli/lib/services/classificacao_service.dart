// Version: 0.0.0
// Aluno 3: Mestre dos Critérios de Desempate (Regras Oficiais Copa 2026)
import '../models/selecao.dart';

class ClassificacaoService {
  /// Calcula pontos no confronto direto entre duas seleções empatadas
  int _pontosConfrontoDireto(
    Selecao a,
    Selecao b,
    List<PartidaRegistrada> historico,
  ) {
    int pontosA = 0;
    for (final p in historico) {
      if (p.timeA == a.nome && p.timeB == b.nome) {
        if (p.golsA > p.golsB) {
          pontosA += 3;
        } else if (p.golsA == p.golsB) {
          pontosA += 1;
        }
      } else if (p.timeA == b.nome && p.timeB == a.nome) {
        if (p.golsB > p.golsA) {
          pontosA += 3;
        } else if (p.golsB == p.golsA) {
          pontosA += 1;
        }
      }
    }
    return pontosA;
  }

  /// Ordena aplicando:
  /// 0º Pontos -> 1º Saldo de Gols -> 2º Gols Pró -> 3º Confronto Direto ->
  /// 4º Menos Cartões (Fair Play) -> 5º Ranking da FIFA (menor número = melhor)
  List<Selecao> ordenarTabela(
    List<Selecao> selecoes,
    List<PartidaRegistrada> historico,
  ) {
    final copia = List<Selecao>.from(selecoes);

    copia.sort((a, b) {
      // 0. Pontos
      if (b.pontos != a.pontos) return b.pontos.compareTo(a.pontos);

      // 1º Critério: Saldo de Gols
      if (b.saldoGols != a.saldoGols) {
        return b.saldoGols.compareTo(a.saldoGols);
      }

      // 2º Critério: Gols Pró
      if (b.golsPro != a.golsPro) {
        return b.golsPro.compareTo(a.golsPro);
      }

      // 3º Critério: Confronto Direto
      final ptsA = _pontosConfrontoDireto(a, b, historico);
      final ptsB = _pontosConfrontoDireto(b, a, historico);
      if (ptsB != ptsA) {
        return ptsB.compareTo(ptsA);
      }

      // 4º Critério: Menos Cartões (Fair Play)
      if (a.pontosDisciplinares != b.pontosDisciplinares) {
        return a.pontosDisciplinares.compareTo(b.pontosDisciplinares);
      }

      // 5º Critério Final 2026: Posição no Ranking da FIFA (1º é melhor que 50º)
      return a.rankingFifa.compareTo(b.rankingFifa);
    });

    return copia;
  }

  void exibirTabela(
    Grupo grupo,
    List<Selecao> selecoes,
    List<PartidaRegistrada> historico,
  ) {
    final ordenadas = ordenarTabela(selecoes, historico);

    print('\n=== CLASSIFICAÇÃO GRUPO ${grupo.name} - COPA 2026 ===');
    print(
      '${'Pos'.padRight(4)} | '
      '${'Seleção'.padRight(15)} | '
      '${'Pts'.padLeft(3)} | '
      '${'SG'.padLeft(4)} | '
      '${'GP'.padLeft(3)} | '
      '${'FP'.padLeft(3)} | '
      'Ranking FIFA',
    );
    print('-' * 62);

    for (int i = 0; i < ordenadas.length; i++) {
      final s = ordenadas[i];
      final pos = '${i + 1}º'.padRight(4);
      final nome = s.nome.padRight(15);
      final pts = s.pontos.toString().padLeft(3);
      final sgStr = (s.saldoGols >= 0 ? '+${s.saldoGols}' : '${s.saldoGols}')
          .padLeft(4);
      final gp = s.golsPro.toString().padLeft(3);
      final fp = s.pontosDisciplinares.toString().padLeft(3);
      final rank = '${s.rankingFifa}º'.padRight(5);

      var obs = '';
      if (i == 2) {
        obs = ' <-- Disputa vaga entre os 8 melhores 3º (Ranking FIFA)';
      }

      print('$pos | $nome | $pts | $sgStr | $gp | $fp | $rank$obs');

      if (i == 1) {
        print('${'-' * 45} (Zona de Classificação Direta)');
      }
    }
    print('');
  }
}
