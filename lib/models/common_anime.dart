class CommonAnime {
  final String id;
  final String title;
  final String? imageUrl;
  final bool isLiked;
  final String? source;
  final List<String>? genres;
  final int? episodes;
  final double? rating;

  CommonAnime({
    required this.id,
    required this.title,
    this.imageUrl,
    this.isLiked = false,
    this.source,
    this.genres,
    this.episodes,
    this.rating,
  });

  factory CommonAnime.fromJson(Map<String, dynamic> json) {
    return CommonAnime(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['image_url'] as String?,
      isLiked: json['is_liked'] as bool? ?? false,
      source: json['source'] as String?,
      genres: (json['genres'] as List<dynamic>?)?.cast<String>(),
      episodes: json['episodes'] as int?,
      rating: json['rating'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image_url': imageUrl,
      'is_liked': isLiked,
      'source': source,
      'genres': genres,
      'episodes': episodes,
      'rating': rating,
    };
  }
}
