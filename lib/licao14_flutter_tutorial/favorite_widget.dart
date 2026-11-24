// Version: 0.0.0
// Componente separado de interatividade e estado (Trilha Oficial Flutter)
import 'package:flutter/material.dart';

class FavoriteWidget extends StatefulWidget {
  const FavoriteWidget({super.key});

  @override
  State<FavoriteWidget> createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool _isFavorited = true;
  int _favoriteCount = 41;

  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _favoriteCount -= 1;
        _isFavorited = false;
      } else {
        _favoriteCount += 1;
        _isFavorited = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          alignment: Alignment.centerRight,
          icon: Icon(
            _isFavorited ? Icons.star : Icons.star_border,
            color: Colors.red.shade600,
          ),
          onPressed: _toggleFavorite,
        ),
        SizedBox(
          width: 24,
          child: Text(
            '$_favoriteCount',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
