// Version: 0.0.0
import 'package:flutter/material.dart';
import 'exercicio_1_perfil.dart';
import 'exercicio_2_catalogo.dart';
import 'exercicio_3_formulario.dart';

class MenuExerciciosM1M2Screen extends StatelessWidget {
  const MenuExerciciosM1M2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista Prática - Módulos 01 e 02'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.badge),
              label: const Text('Exercício 1: Meu Perfil Dev'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const Exercicio1PerfilScreen(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.list_alt),
              label: const Text('Exercício 2: Catálogo Dinâmico'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const Exercicio2CatalogoScreen(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.edit_note),
              label: const Text('Exercício 3: Formulário Interativo'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const Exercicio3FormularioScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
