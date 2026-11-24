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

  factory Summary.fromJson(Map<String, dynamic> json) {
    final titles = json['titles'] as Map<String, dynamic>?;
    final parsedTitle = (titles != null && titles['normalized'] is String)
        ? titles['normalized'] as String
        : (json['title'] as String? ?? '');

    return Summary(
      title: parsedTitle,
      pageId: json['pageid'] as int? ?? 0,
      extract: json['extract'] as String? ?? '',
      description: json['description'] as String?,
    );
  }
}
