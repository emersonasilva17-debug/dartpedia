// Version: 0.0.0
// Aluno 1: Modelador de Seleções (Lições 05 e 07)

enum Grupo { A, B, C, D, E, F, G, H, I, J, K, L }

class PartidaRegistrada {
  final String timeA;
  final String timeB;
  final int golsA;
  final int golsB;

  const PartidaRegistrada({
    required this.timeA,
    required this.timeB,
    required this.golsA,
    required this.golsB,
  });
}

class Selecao {
  final String nome;
  final Grupo grupo;
  final int rankingFifa;

  int pontos;
  int golsPro;
  int golsSofridos;
  int cartoesAmarelos;
  int cartoesVermelhos;

  Selecao({
    required this.nome,
    required this.grupo,
    required this.rankingFifa,
    this.pontos = 0,
    this.golsPro = 0,
    this.golsSofridos = 0,
    this.cartoesAmarelos = 0,
    this.cartoesVermelhos = 0,
  });

  int get saldoGols => golsPro - golsSofridos;

  /// Pontuação disciplinar FIFA (Fair Play): Amarelo = 1 pt, Vermelho direto = 4 pts
  int get pontosDisciplinares => cartoesAmarelos + (cartoesVermelhos * 4);

  factory Selecao.fromJson(Map<String, dynamic> json, Grupo grupo) {
    return Selecao(
      nome: json['nome'] as String,
      grupo: grupo,
      rankingFifa: json['rankingFifa'] as int,
    );
  }
}
