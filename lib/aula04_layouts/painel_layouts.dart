// Version: 0.0.0
// Aula 04 - Layout Widgets (Row, Column, Expanded e Stack) - Exercícios 01 a 07
import 'package:flutter/material.dart';
import '../widgets/bloco_estatistica.dart';

class PainelLayoutsScreen extends StatelessWidget {
  const PainelLayoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel de Layouts - Aula 04'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        // Exercício 02: Alinhamento do eixo cruzado alterado para CrossAxisAlignment.center
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Resumo de Atividades',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            // Exercícios 01 e 07: 3 Cards na primeira Row com Expanded e BlocoEstatistica
            const Row(
              children: [
                Expanded(
                  child: BlocoEstatistica(
                    icone: Icons.folder,
                    contagem: '12',
                    legenda: 'Projetos',
                    cor: Colors.indigo,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: BlocoEstatistica(
                    icone: Icons.check_circle,
                    contagem: '28',
                    legenda: 'Tarefas',
                    cor: Colors.teal,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: BlocoEstatistica(
                    icone: Icons.camera_alt,
                    contagem: '45',
                    legenda: 'Fotos',
                    cor: Colors.deepOrange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Card de Destaque',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            // Exercício 06: Card widget do Material com elevation: 4
            Card(
              elevation: 4,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              // Exercício 05: Stack com selos sobrepostos (incluindo "Confirmado" verde na parte inferior esquerda)
              child: Stack(
                children: [
                  Container(
                    height: 170,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.indigo.shade800, Colors.blue.shade500],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.flutter_dash, size: 54, color: Colors.white),
                          SizedBox(height: 8),
                          Text(
                            'Projeto Dartpedia & Flutter UI',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade700,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Destaque',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Exercício 05: Selo sobreposto na parte inferior esquerda com texto "Confirmado" e fundo verde
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'Confirmado',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Últimos Registros',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            // Exercício 03: Container contendo Row com ícone de lista, texto e botão alinhados com spaceBetween
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.list_alt, color: Colors.indigo),
                      SizedBox(width: 10),
                      Text(
                        'Histórico de atualizações',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Ver Todos'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
