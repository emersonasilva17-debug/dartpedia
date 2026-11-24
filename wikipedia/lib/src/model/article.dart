// Version: 0.0.0

class Article {
  final String title;
  final String extract;

  const Article({
    required this.title,
    required this.extract,
  });

  factory Article.fromJson(Map<String, Object?> json) {
    if (json
        case {
          'title': final String title,
          'extract': final String extract,
        }) {
      return Article(title: title, extract: extract);
    }
    throw const FormatException('JSON inválido para o modelo Article.');
  }

  Map<String, Object?> toJson() => {
        'title': title,
        'extract': extract,
      };
}
