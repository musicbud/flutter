class CommonTrack {
  final String id;
  final String title;
  final String artistName;
  final String? albumName;
  final String? imageUrl;
  final bool isLiked;
  final DateTime? playedAt;
  final String source;

  CommonTrack({
    required this.id,
    required this.title,
    required this.artistName,
    this.albumName,
    this.imageUrl,
    this.isLiked = false,
    this.playedAt,
    required this.source,
  });

  factory CommonTrack.fromJson(Map<String, dynamic> json) {
    return CommonTrack(
      id: json['id'] as String,
      title: json['title'] as String,
      artistName: json['artist_name'] as String,
      albumName: json['album_name'] as String?,
      imageUrl: json['image_url'] as String?,
      isLiked: json['is_liked'] as bool? ?? false,
      playedAt: json['played_at'] != null
          ? DateTime.parse(json['played_at'] as String)
          : null,
      source: json['source'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist_name': artistName,
      'album_name': albumName,
      'image_url': imageUrl,
      'is_liked': isLiked,
      'played_at': playedAt?.toIso8601String(),
      'source': source,
    };
  }
}
