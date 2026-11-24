// Version: 0.0.0

class Article {
  final String title;
  final String extract;

  const Article({
    required this.title,
    required this.extract,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] as String? ?? '',
      extract: json['extract'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'extract': extract,
      };
}
