class CommonAlbum {
  final String id;
  final String uid;
  final String name;
  final String? artistName;
  final String? artistId;
  final String? source;
  final String? spotifyId;
  final String? ytmusicId;
  final String? lastfmId;
  final int? popularity;
  final bool isLiked;
  final List<String>? genres;
  final List<String>? imageUrls;
  final String? imageUrl;
  final int? releaseYear;
  final int? totalTracks;

  CommonAlbum({
    required this.id,
    this.uid = '',
    required this.name,
    this.artistName,
    this.artistId,
    this.source,
    this.spotifyId,
    this.ytmusicId,
    this.lastfmId,
    this.popularity,
    this.isLiked = false,
    this.genres,
    this.imageUrls,
    this.imageUrl,
    this.releaseYear,
    this.totalTracks,
  });

  factory CommonAlbum.fromJson(Map<String, dynamic> json) {
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

    return CommonAlbum(
      id: id,
      uid: uid,
      name: name,
      artistName: json['artist_name'] as String?,
      artistId: json['artist_id'] as String?,
      source: json['source'] as String?,
      spotifyId: json['spotify_id'] as String?,
      ytmusicId: json['ytmusic_id'] as String?,
      lastfmId: json['lastfm_id'] as String?,
      popularity: json['popularity'] as int?,
      isLiked: json['is_liked'] as bool? ?? false,
      genres:
          (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
      imageUrls: (json['image_urls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      imageUrl: imageUrl,
      releaseYear: json['release_year'] as int?,
      totalTracks: json['total_tracks'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'artist_name': artistName,
      'artist_id': artistId,
      'source': source,
      'spotify_id': spotifyId,
      'ytmusic_id': ytmusicId,
      'lastfm_id': lastfmId,
      'popularity': popularity,
      'is_liked': isLiked,
      'genres': genres,
      'image_urls': imageUrls,
      'image_url': imageUrl,
      'release_year': releaseYear,
      'total_tracks': totalTracks,
    };
  }

  CommonAlbum copyWith({
    String? id,
    String? uid,
    String? name,
    String? artistName,
    String? artistId,
    String? source,
    String? spotifyId,
    String? ytmusicId,
    String? lastfmId,
    int? popularity,
    bool? isLiked,
    List<String>? genres,
    List<String>? imageUrls,
    String? imageUrl,
    int? releaseYear,
    int? totalTracks,
  }) {
    return CommonAlbum(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      artistName: artistName ?? this.artistName,
      artistId: artistId ?? this.artistId,
      source: source ?? this.source,
      spotifyId: spotifyId ?? this.spotifyId,
      ytmusicId: ytmusicId ?? this.ytmusicId,
      lastfmId: lastfmId ?? this.lastfmId,
      popularity: popularity ?? this.popularity,
      isLiked: isLiked ?? this.isLiked,
      genres: genres ?? this.genres,
      imageUrls: imageUrls ?? this.imageUrls,
      imageUrl: imageUrl ?? this.imageUrl,
      releaseYear: releaseYear ?? this.releaseYear,
      totalTracks: totalTracks ?? this.totalTracks,
    );
  }
}
