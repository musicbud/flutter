/// Represents a common genre across different music platforms
class CommonGenre {
  final String id;
  final String uid;
  final String name;
  final String? source;
  final String? spotifyId;
  final String? ytmusicId;
  final String? lastfmId;
  final int? popularity;
  final bool isLiked;
  final String? imageUrl;
  final List<String>? imageUrls;

  CommonGenre({
    required this.id,
    this.uid = '',
    required this.name,
    this.source,
    this.spotifyId,
    this.ytmusicId,
    this.lastfmId,
    this.popularity,
    this.isLiked = false,
    this.imageUrl,
    this.imageUrls,
  });

  factory CommonGenre.fromJson(Map<String, dynamic> json) {
    return CommonGenre(
      id: json['id'] as String,
      uid: json['uid'] as String? ?? '',
      name: json['name'] as String,
      source: json['source'] as String?,
      spotifyId: json['spotify_id'] as String?,
      ytmusicId: json['ytmusic_id'] as String?,
      lastfmId: json['lastfm_id'] as String?,
      popularity: json['popularity'] as int?,
      isLiked: json['is_liked'] as bool? ?? false,
      imageUrl: json['image_url'] as String?,
      imageUrls: (json['image_urls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'source': source,
      'spotify_id': spotifyId,
      'ytmusic_id': ytmusicId,
      'lastfm_id': lastfmId,
      'popularity': popularity,
      'is_liked': isLiked,
      'image_url': imageUrl,
      'image_urls': imageUrls,
    };
  }

  CommonGenre copyWith({
    String? id,
    String? uid,
    String? name,
    String? source,
    String? spotifyId,
    String? ytmusicId,
    String? lastfmId,
    int? popularity,
    bool? isLiked,
    String? imageUrl,
    List<String>? imageUrls,
  }) {
    return CommonGenre(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      source: source ?? this.source,
      spotifyId: spotifyId ?? this.spotifyId,
      ytmusicId: ytmusicId ?? this.ytmusicId,
      lastfmId: lastfmId ?? this.lastfmId,
      popularity: popularity ?? this.popularity,
      isLiked: isLiked ?? this.isLiked,
      imageUrl: imageUrl ?? this.imageUrl,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }
}
