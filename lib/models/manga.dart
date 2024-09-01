class Manga {
  final String title;
  final String? imageUrl;
  final String? author;

  Manga({required this.title, this.imageUrl, this.author});

  factory Manga.fromJson(Map<String, dynamic> json) {
    return Manga(
      title: json['title'],
      imageUrl: json['image_url'],
      author: json['author'],
    );
  }
}
