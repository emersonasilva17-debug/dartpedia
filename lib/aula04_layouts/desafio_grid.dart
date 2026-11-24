// Version: 0.0.0
// Exercício 08: Refatoração com GridView.count exibindo 4 cards em grade 2x2
import 'package:flutter/material.dart';
import '../widgets/bloco_estatistica.dart';

class DesafioGridScreen extends StatelessWidget {
  const DesafioGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estatísticas em Grade 2x2'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: const [
            BlocoEstatistica(
              icone: Icons.folder,
              contagem: '12',
              legenda: 'Projetos',
              cor: Colors.indigo,
            ),
            BlocoEstatistica(
              icone: Icons.check_circle,
              contagem: '28',
              legenda: 'Tarefas',
              cor: Colors.teal,
            ),
            BlocoEstatistica(
              icone: Icons.camera_alt,
              contagem: '45',
              legenda: 'Fotos',
              cor: Colors.deepOrange,
            ),
            BlocoEstatistica(
              icone: Icons.star,
              contagem: '98%',
              legenda: 'Desempenho',
              cor: Colors.amber,
            ),
          ],
        ),
      ),
    );
  }
}
