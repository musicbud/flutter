class Artist {
  final String id;
  final String name;
  final String? imageUrl;
  final int? popularity;

  Artist({
    required this.id,
    required this.name,
    this.imageUrl,
    this.popularity,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['image_url'],
      popularity: json['popularity'],
    );
  }
}
