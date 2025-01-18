class CommonManga {
  final String id;
  final String title;
  final String? imageUrl;
  final bool isLiked;
  final String? source;
  final List<String>? genres;
  final int? chapters;
  final int? volumes;
  final double? rating;

  CommonManga({
    required this.id,
    required this.title,
    this.imageUrl,
    this.isLiked = false,
    this.source,
    this.genres,
    this.chapters,
    this.volumes,
    this.rating,
  });

  factory CommonManga.fromJson(Map<String, dynamic> json) {
    return CommonManga(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['image_url'] as String?,
      isLiked: json['is_liked'] as bool? ?? false,
      source: json['source'] as String?,
      genres: (json['genres'] as List<dynamic>?)?.cast<String>(),
      chapters: json['chapters'] as int?,
      volumes: json['volumes'] as int?,
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
      'chapters': chapters,
      'volumes': volumes,
      'rating': rating,
    };
  }
}
