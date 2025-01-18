class CommonArtist {
  final String id;
  final String name;
  final String? imageUrl;
  final bool isLiked;
  final String source;
  final List<String> genres;

  CommonArtist({
    required this.id,
    required this.name,
    this.imageUrl,
    this.isLiked = false,
    required this.source,
    this.genres = const [],
  });

  factory CommonArtist.fromJson(Map<String, dynamic> json) {
    return CommonArtist(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String?,
      isLiked: json['is_liked'] as bool? ?? false,
      source: json['source'] as String,
      genres: (json['genres'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'is_liked': isLiked,
      'source': source,
      'genres': genres,
    };
  }
}
