class Anime {
  final String title;
  final String? imageUrl;
  final String? studio;

  Anime({required this.title, this.imageUrl, this.studio});

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      title: json['title'],
      imageUrl: json['image_url'],
      studio: json['studio'],
    );
  }
}
