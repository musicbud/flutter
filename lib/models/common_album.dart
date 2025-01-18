class CommonAlbum {
  final String id;
  final String title;
  final String artistName;
  final String? imageUrl;
  final bool isLiked;
  final String source;
  final int? year;
  final List<String> genres;

  CommonAlbum({
    required this.id,
    required this.title,
    required this.artistName,
    this.imageUrl,
    this.isLiked = false,
    required this.source,
    this.year,
    this.genres = const [],
  });

  factory CommonAlbum.fromJson(Map<String, dynamic> json) {
    return CommonAlbum(
      id: json['id'] as String,
      title: json['title'] as String,
      artistName: json['artist_name'] as String,
      imageUrl: json['image_url'] as String?,
      isLiked: json['is_liked'] as bool? ?? false,
      source: json['source'] as String,
      year: json['year'] as int?,
      genres: (json['genres'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist_name': artistName,
      'image_url': imageUrl,
      'is_liked': isLiked,
      'source': source,
      'year': year,
      'genres': genres,
    };
  }
}
