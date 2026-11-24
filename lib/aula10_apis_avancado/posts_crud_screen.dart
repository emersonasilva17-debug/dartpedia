// Version: 0.0.0
// Aula 10 - Consumo de APIs RESTful Avançado (POST, PUT, DELETE)
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostModel {
  final int id;
  final String title;
  final String body;
  final int userId;

  const PostModel({
    required this.id,
    required this.title,
    required this.body,
    this.userId = 1,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      userId: json['userId'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'userId': userId,
      };
}

class PostsCrudScreen extends StatefulWidget {
  const PostsCrudScreen({super.key});

  @override
  State<PostsCrudScreen> createState() => _PostsCrudScreenState();
}

class _PostsCrudScreenState extends State<PostsCrudScreen> {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  final TextEditingController _buscaAppBarController = TextEditingController();
  List<PostModel> _todosPosts = [];
  String _termoFiltro = '';
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _carregarPosts();
  }

  @override
  void dispose() {
    _buscaAppBarController.dispose();
    super.dispose();
  }

  // Exercício 03: Exibir o statusCode retornado pelo servidor dentro da SnackBar
  void _mostrarSnackBarStatus({
    required String operacao,
    required int statusCode,
    bool erro = false,
  }) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$operacao concluído — Status HTTP: $statusCode'),
        backgroundColor: erro ? Colors.red.shade700 : Colors.green.shade700,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // GET: Carregar lista inicial de posts
  Future<void> _carregarPosts() async {
    setState(() => _carregando = true);
    try {
      final response = await http.get(Uri.parse('$_baseUrl?_limit=15'));
      if (response.statusCode == 200) {
        final lista = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          _todosPosts = lista
              .map((item) => PostModel.fromJson(item as Map<String, dynamic>))
              .toList();
        });
      }
      _mostrarSnackBarStatus(
        operacao: 'GET (Listar Posts)',
        statusCode: response.statusCode,
        erro: response.statusCode != 200,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro de conexão (GET): $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  // POST: Criar novo post
  Future<void> _criarPost(String title, String body) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'title': title,
          'body': body,
          'userId': 1,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final criado = PostModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
        setState(() {
          _todosPosts.insert(
            0,
            PostModel(
              id: criado.id == 0 ? _todosPosts.length + 101 : criado.id,
              title: title,
              body: body,
            ),
          );
        });
      }

      _mostrarSnackBarStatus(
        operacao: 'POST (Criar Post)',
        statusCode: response.statusCode,
        erro: response.statusCode != 201 && response.statusCode != 200,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro de conexão (POST): $e')),
        );
      }
    }
  }

  // PUT: Atualizar post existente
  Future<void> _atualizarPost(PostModel post, String novoTitle, String novoBody) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/${post.id}'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'id': post.id,
          'title': novoTitle,
          'body': novoBody,
          'userId': post.userId,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          final index = _todosPosts.indexWhere((p) => p.id == post.id);
          if (index != -1) {
            _todosPosts[index] = PostModel(
              id: post.id,
              title: novoTitle,
              body: novoBody,
              userId: post.userId,
            );
          }
        });
      }

      _mostrarSnackBarStatus(
        operacao: 'PUT (Atualizar Post #${post.id})',
        statusCode: response.statusCode,
        erro: response.statusCode != 200,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro de conexão (PUT): $e')),
        );
      }
    }
  }

  // Exercício 01: Confirmação visual (AlertDialog) antes de disparar o DELETE
  Future<void> _confirmarExclusao(PostModel post) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Confirmar Exclusão'),
          ],
        ),
        content: Text(
          'Deseja realmente excluir o post #${post.id} ("${post.title}")?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Excluir (DELETE)'),
          ),
        ],
      ),
    );

    if (confirmado == true) {
      await _deletarPost(post);
    }
  }

  // DELETE: Excluir post no servidor
  Future<void> _deletarPost(PostModel post) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/${post.id}'));

      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          _todosPosts.removeWhere((p) => p.id == post.id);
        });
      }

      _mostrarSnackBarStatus(
        operacao: 'DELETE (Excluir Post #${post.id})',
        statusCode: response.statusCode,
        erro: response.statusCode != 200 && response.statusCode != 204,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro de conexão (DELETE): $e')),
        );
      }
    }
  }

  Future<void> _abrirFormularioPost({PostModel? postExistente}) async {
    final titleController =
        TextEditingController(text: postExistente?.title ?? '');
    final bodyController =
        TextEditingController(text: postExistente?.body ?? '');

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(postExistente == null ? 'Novo Post (POST)' : 'Editar Post (PUT)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: bodyController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Conteúdo',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();
              final body = bodyController.text.trim();
              if (title.isEmpty || body.isEmpty) return;

              Navigator.of(ctx).pop();
              if (postExistente == null) {
                _criarPost(title, body);
              } else {
                _atualizarPost(postExistente, title, body);
              }
            },
            child: Text(postExistente == null ? 'Enviar POST' : 'Salvar PUT'),
          ),
        ],
      ),
    );
  }

  List<PostModel> get _postsFiltrados {
    if (_termoFiltro.trim().isEmpty) return _todosPosts;
    final query = _termoFiltro.toLowerCase();
    return _todosPosts
        .where((post) => post.title.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final listaExibida = _postsFiltrados;

    return Scaffold(
      // Exercício 02: Filtro de busca local na AppBar usando TextField
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade800,
        foregroundColor: Colors.white,
        title: TextField(
          controller: _buscaAppBarController,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          onChanged: (valor) {
            setState(() => _termoFiltro = valor);
          },
          decoration: InputDecoration(
            hintText: 'Filtrar posts pelo título...',
            hintStyle: const TextStyle(color: Colors.white70),
            prefixIcon: const Icon(Icons.search, color: Colors.white70),
            suffixIcon: _termoFiltro.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white70),
                    onPressed: () {
                      _buscaAppBarController.clear();
                      setState(() => _termoFiltro = '');
                    },
                  )
                : null,
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Recarregar (GET)',
            icon: const Icon(Icons.refresh),
            onPressed: _carregarPosts,
          ),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : listaExibida.isEmpty
              ? const Center(
                  child: Text('Nenhum post encontrado com o filtro informado.'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: listaExibida.length,
                  itemBuilder: (context, index) {
                    final post = listaExibida[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueGrey.shade700,
                          foregroundColor: Colors.white,
                          child: Text('${post.id}'),
                        ),
                        title: Text(
                          post.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          post.body,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Editar (PUT)',
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () =>
                                  _abrirFormularioPost(postExistente: post),
                            ),
                            IconButton(
                              tooltip: 'Excluir (DELETE)',
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmarExclusao(post),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormularioPost(),
        icon: const Icon(Icons.add),
        label: const Text('Novo Post'),
      ),
    );
  }
}
