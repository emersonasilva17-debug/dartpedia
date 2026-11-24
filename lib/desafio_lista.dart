// Version: 0.0.0
// Exercício 08: Column com 3 crachás diferentes com espaçamentos entre eles
import 'package:flutter/material.dart';
import 'widgets/cartao_estudante.dart';

class DesafioListaScreen extends StatelessWidget {
  const DesafioListaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carteirinha Estudantil - Lista'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            CartaoEstudante(
              nome: 'Emerson Silva',
              curso: 'Desenvolvimento de Sistemas',
              ra: '2026001',
              email: 'emerson.silva@escola.edu.br',
              avatarUrl: 'https://i.pravatar.cc/150?img=11',
            ),
            SizedBox(height: 16),
            CartaoEstudante(
              nome: 'Mariana Costa',
              curso: 'Análise e Desenv. de Sistemas',
              ra: '2026002',
              email: 'mariana.costa@escola.edu.br',
              avatarUrl: 'https://i.pravatar.cc/150?img=5',
            ),
            SizedBox(height: 16),
            CartaoEstudante(
              nome: 'Lucas Oliveira',
              curso: 'Ciência da Computação',
              ra: '2026003',
              email: 'lucas.oliveira@escola.edu.br',
              avatarUrl: 'https://i.pravatar.cc/150?img=3',
            ),
          ],
        ),
      ),
    );
  }
}
