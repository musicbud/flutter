class Anime {
  final String id;
  final String title;
  final String? imageUrl;
  final String? studio;

  Anime({
    required this.id,
    required this.title,
    this.imageUrl,
    this.studio,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['id'] ?? '',
      title: json['name'] ?? json['title'] ?? '',
      imageUrl: json['image_url'],
      studio: json['studio'],
    );
  }
}
