class Manga {
  final String id;
  final String title;
  final String? imageUrl;
  final String? author;

  Manga({
    required this.id,
    required this.title,
    this.imageUrl,
    this.author,
  });

  factory Manga.fromJson(Map<String, dynamic> json) {
    return Manga(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['image_url'],
      author: json['author'],
    );
  }
}
