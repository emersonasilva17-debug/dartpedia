// Version: 0.0.0
// Exercícios 01, 02, 03, 05, 06 e 07
import 'package:flutter/material.dart';

class CartaoEstudante extends StatelessWidget {
  final String nome;
  final String curso;
  final String email;
  final String ra;
  final String avatarUrl;

  const CartaoEstudante({
    super.key,
    required this.nome,
    required this.curso,
    required this.email,
    required this.ra,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        // Exercício 01: tonalidade leve de verde
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.green.shade300, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      // Exercício 05: Column envolvida em Padding de 8 pixels em todos os lados
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Exercício 03: CircleAvatar com foregroundImage usando NetworkImage
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.green.shade100,
              foregroundImage: NetworkImage(avatarUrl),
              child: const Icon(Icons.person, size: 40, color: Colors.green),
            ),
            const SizedBox(height: 12),
            Text(
              nome,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$curso • RA: $ra',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Exercício 01: cor principal dos ícones Colors.green
                const Icon(Icons.email, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Text(
                  email,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Exercício 02: nova Row abaixo do e-mail com Icons.check_circle e Status
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Text(
                  'Status: Matriculado / Ativo',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Exercício 06: rodapé com ElevatedButton "Validar Carteirinha"
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Validar Carteirinha'),
            ),
          ],
        ),
      ),
    );
  }
}
