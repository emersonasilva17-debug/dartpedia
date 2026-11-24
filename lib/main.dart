// Version: 0.0.1
// Exercício 07 e 08: Importação de CartaoEstudante e DesafioListaScreen
import 'package:flutter/material.dart';
import 'desafio_lista.dart';
import 'widgets/cartao_estudante.dart';

void main() {
  runApp(const CarteirinhaApp());
}

class CarteirinhaApp extends StatelessWidget {
  const CarteirinhaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crachá Estudantil',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const DesafioListaScreen(),
    );
  }
}

class CrachaUnicoScreen extends StatelessWidget {
  const CrachaUnicoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crachá do Estudante'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CartaoEstudante(
            nome: 'Emerson Silva',
            curso: 'Desenvolvimento de Sistemas',
            ra: '2026001',
            email: 'emerson.silva@escola.edu.br',
            avatarUrl: 'https://i.pravatar.cc/150?img=11',
          ),
        ),
      ),
    );
  }
}
