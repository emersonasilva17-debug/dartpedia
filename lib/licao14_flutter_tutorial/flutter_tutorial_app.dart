// Version: 0.0.0
// Lição 14 - Prática Hands-on (Flutter Getting Started Tutorial - Layout + Estado)
import 'package:flutter/material.dart';
import 'favorite_widget.dart';

class FlutterTutorialApp extends StatelessWidget {
  const FlutterTutorialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Layout & State Tutorial',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const TutorialHomePage(),
    );
  }
}

class TutorialHomePage extends StatelessWidget {
  const TutorialHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Layout Demo - Lição 14'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner ilustrativo no topo
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo.shade800, Colors.blue.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.landscape, size: 72, color: Colors.white),
                    SizedBox(height: 8),
                    Text(
                      'Oeschinen Lake Campground',
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
            // Seção de Título + Componente Interativo FavoriteWidget
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Oeschinen Lake Campground',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Kandersteg, Switzerland',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  FavoriteWidget(),
                ],
              ),
            ),
            // Seção de Botões de Ação (Row com Columns)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButtonColumn(color, Icons.call, 'CALL'),
                _buildButtonColumn(color, Icons.near_me, 'ROUTE'),
                _buildButtonColumn(color, Icons.share, 'SHARE'),
              ],
            ),
            // Seção de Texto Descritivo
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'Lake Oeschinen lies at the foot of the Blüemlisalp in the '
                'Bernese Alps. Situated 1,578 meters above sea level, it is one '
                'of the larger Alpine Lakes. A gondola ride from Kandersteg, '
                'followed by a half-hour walk through pastures and pine forest, '
                'leads you to the lake, which warms to 20 degrees Celsius in the '
                'summer. Activities enjoyed here include rowing, and riding the '
                'summer toboggan run.',
                softWrap: true,
                textAlign: TextAlign.justify,
                style: TextStyle(height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}
