/// Represents a common artist across different music platforms
class CommonArtist {
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
  final int? followers;
  final List<String>? genres;

  CommonArtist({
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
    this.followers,
    this.genres,
  });

  factory CommonArtist.fromJson(Map<String, dynamic> json) {
    // Handle backend response structure - backend returns 'uid' instead of 'id'
    final id = json['uid'] as String? ?? json['id'] as String? ?? '';
    final uid = json['uid'] as String? ?? id;
    final name = json['name'] as String? ?? '';

    // Handle image URL - backend returns images array, take first one
    String? imageUrl = json['image_url'] as String?;
    if (imageUrl == null && json['images'] is List && (json['images'] as List).isNotEmpty) {
      final images = json['images'] as List;
      if (images.isNotEmpty && images[0] is Map<String, dynamic>) {
        imageUrl = images[0]['url'] as String?;
      }
    }

    return CommonArtist(
      id: id,
      uid: uid,
      name: name,
      source: json['source'] as String?,
      spotifyId: json['spotify_id'] as String?,
      ytmusicId: json['ytmusic_id'] as String?,
      lastfmId: json['lastfm_id'] as String?,
      popularity: json['popularity'] as int?,
      isLiked: json['is_liked'] as bool? ?? false,
      imageUrl: imageUrl,
      imageUrls: (json['image_urls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      followers: json['followers'] as int?,
      genres:
          (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
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
      'followers': followers,
      'genres': genres,
    };
  }

  CommonArtist copyWith({
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
    int? followers,
    List<String>? genres,
  }) {
    return CommonArtist(
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
      followers: followers ?? this.followers,
      genres: genres ?? this.genres,
    );
  }
}
