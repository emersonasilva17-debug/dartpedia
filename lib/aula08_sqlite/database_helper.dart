// Version: 0.0.0
// Aula 08 - Banco de Dados Relacional com SQLite (DatabaseHelper)
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Tarefa {
  final int? id;
  final String titulo;
  final bool concluida;

  const Tarefa({
    this.id,
    required this.titulo,
    this.concluida = false,
  });

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'titulo': titulo,
        'concluida': concluida ? 1 : 0,
      };

  factory Tarefa.fromMap(Map<String, Object?> map) => Tarefa(
        id: map['id'] as int?,
        titulo: map['titulo'] as String,
        concluida: (map['concluida'] as int) == 1,
      );
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tarefas_aula08.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tarefas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            concluida INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );
  }

  Future<int> insertTarefa(Tarefa tarefa) async {
    final db = await database;
    return await db.insert('tarefas', tarefa.toMap());
  }

  Future<List<Tarefa>> getAllTarefas() async {
    final db = await database;
    final maps = await db.query('tarefas', orderBy: 'id DESC');
    return maps.map(Tarefa.fromMap).toList();
  }

  // Exercício 03: Busca por texto utilizando WHERE titulo LIKE %...%
  Future<List<Tarefa>> searchTarefas(String termo) async {
    final db = await database;
    if (termo.trim().isEmpty) {
      return getAllTarefas();
    }
    final maps = await db.query(
      'tarefas',
      where: 'titulo LIKE ?',
      whereArgs: ['%${termo.trim()}%'],
      orderBy: 'id DESC',
    );
    return maps.map(Tarefa.fromMap).toList();
  }

  Future<int> updateTarefa(Tarefa tarefa) async {
    final db = await database;
    return await db.update(
      'tarefas',
      tarefa.toMap(),
      where: 'id = ?',
      whereArgs: [tarefa.id],
    );
  }

  Future<int> deleteTarefa(int id) async {
    final db = await database;
    return await db.delete(
      'tarefas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Exercício 02: Método deleteAll() para limpar todas as tarefas do SQLite
  Future<int> deleteAll() async {
    final db = await database;
    return await db.delete('tarefas');
  }
}
