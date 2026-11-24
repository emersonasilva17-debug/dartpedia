// Version: 0.0.0
// Aula 03 - Layouts e organização de Widgets (Exercícios 1 a 4)
import 'package:flutter/material.dart';

class PerfilGradienteScreen extends StatelessWidget {
  const PerfilGradienteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil Dev - Layouts'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      // 4. Aplicar um fundo gradiente (LinearGradient) dentro da decoração do Container
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.indigo.shade700,
              Colors.indigo.shade400,
              Colors.blue.shade200,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 1. Substituir o ícone padrão do CircleAvatar por uma imagem real usando NetworkImage
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.indigo.shade100,
                      foregroundImage: const NetworkImage(
                        'https://i.pravatar.cc/200?img=11',
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Emerson Silva',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Desenvolvedor Mobile • Turma T2DEV-T3',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const Divider(height: 28),
                    // 2. Adicionar uma nova seção com o texto "Sobre Mim" e uma breve biografia
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Sobre Mim',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Estudante do curso Técnico em Desenvolvimento de Sistemas (Noturno), focado na criação de aplicações multiplataforma modernas com Dart e Flutter.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Habilidades',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 3. Incluir badges de habilidades (skills) utilizando o widget Chip dentro de uma Row
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Chip(
                            avatar: const Icon(Icons.code, size: 18, color: Colors.indigo),
                            label: const Text('Dart'),
                            backgroundColor: Colors.indigo.shade50,
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            avatar: const Icon(Icons.phone_android, size: 18, color: Colors.indigo),
                            label: const Text('Flutter'),
                            backgroundColor: Colors.indigo.shade50,
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            avatar: const Icon(Icons.account_tree, size: 18, color: Colors.indigo),
                            label: const Text('Git & GitHub'),
                            backgroundColor: Colors.indigo.shade50,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
