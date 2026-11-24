// Version: 0.0.0

class Summary {
  final String title;
  final int pageId;
  final String extract;
  final String? description;

  const Summary({
    required this.title,
    required this.pageId,
    required this.extract,
    this.description,
  });

  factory Summary.fromJson(Map<String, Object?> json) {
    return switch (json) {
      {
        'titles': {'canonical': final String title},
        'pageid': final int pageId,
        'extract': final String extract,
      } =>
        Summary(
          title: title,
          pageId: pageId,
          extract: extract,
          description: json['description'] as String?,
        ),
      {
        'title': final String title,
        'pageid': final int pageId,
        'extract': final String extract,
      } =>
        Summary(
          title: title,
          pageId: pageId,
          extract: extract,
          description: json['description'] as String?,
        ),
      _ => throw const FormatException('JSON inválido para o modelo Summary.'),
    };
  }

  Map<String, Object?> toJson() => {
        'title': title,
        'pageid': pageId,
        'extract': extract,
        if (description != null) 'description': description,
      };
}
