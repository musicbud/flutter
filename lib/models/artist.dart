class Artist {
  final String id;
  final String name;
  final List<String> genres;
  final String? imageUrl;

  Artist({
    required this.id,
    required this.name,
    required this.genres,
    this.imageUrl,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'] as String,
      name: json['name'] as String,
      genres: List<String>.from(json['genres'] ?? []),
      imageUrl: json['image_url'] as String?,
    );
  }
}
