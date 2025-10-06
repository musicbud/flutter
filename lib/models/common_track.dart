class CommonTrack {
  final String? uid;
  final String? id;
  final String name;
  final String? artistName;
  final String? imageUrl;
  final List<String>? imageUrls;
  final int? durationMs;
  final String? albumName;
  final String? source;
  final String? spotifyId;
  final String? ytmusicId;
  final String? lastfmId;
  final int? popularity;
  final bool isLiked;
  final DateTime? playedAt;
  final double? latitude;
  final double? longitude;

  String get title => name;

  const CommonTrack({
    this.uid,
    this.id,
    required this.name,
    this.artistName,
    this.imageUrl,
    this.imageUrls,
    this.durationMs,
    this.albumName,
    this.source,
    this.spotifyId,
    this.ytmusicId,
    this.lastfmId,
    this.popularity,
    this.isLiked = false,
    this.playedAt,
    this.latitude,
    this.longitude,
  });

  factory CommonTrack.fromJson(Map<String, dynamic> json) {
    // Handle backend response structure - backend returns 'uid' instead of 'id'
    final id = json['uid'] as String? ?? json['id'] as String? ?? '';
    final name = json['name'] as String? ?? '';

    // Handle image URL - backend returns images array, take first one
    String? imageUrl = json['image_url'] as String?;
    if (imageUrl == null && json['images'] is List && (json['images'] as List).isNotEmpty) {
      final images = json['images'] as List;
      if (images.isNotEmpty && images[0] is Map<String, dynamic>) {
        imageUrl = images[0]['url'] as String?;
      }
    }

    return CommonTrack(
      id: id,
      name: name,
      artistName: json['artist_name'] as String?,
      imageUrl: imageUrl,
      imageUrls: (json['image_urls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      durationMs: json['duration_ms'] as int?,
      albumName: json['album_name'] as String?,
      source: json['source'] as String?,
      spotifyId: json['spotify_id'] as String?,
      ytmusicId: json['ytmusic_id'] as String?,
      lastfmId: json['lastfm_id'] as String?,
      popularity: json['popularity'] as int?,
      isLiked: json['is_liked'] as bool? ?? false,
      playedAt: json['played_at'] != null
          ? DateTime.parse(json['played_at'] as String)
          : null,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'id': id,
      'name': name,
      'artist_name': artistName,
      'image_url': imageUrl,
      'image_urls': imageUrls,
      'duration_ms': durationMs,
      'album_name': albumName,
      'source': source,
      'spotify_id': spotifyId,
      'ytmusic_id': ytmusicId,
      'lastfm_id': lastfmId,
      'popularity': popularity,
      'is_liked': isLiked,
      'played_at': playedAt?.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  CommonTrack copyWith({
    String? uid,
    String? id,
    String? name,
    String? artistName,
    String? imageUrl,
    List<String>? imageUrls,
    int? durationMs,
    String? albumName,
    String? source,
    String? spotifyId,
    String? ytmusicId,
    String? lastfmId,
    int? popularity,
    bool? isLiked,
    DateTime? playedAt,
    double? latitude,
    double? longitude,
  }) {
    return CommonTrack(
      uid: uid ?? this.uid,
      id: id ?? this.id,
      name: name ?? this.name,
      artistName: artistName ?? this.artistName,
      imageUrl: imageUrl ?? this.imageUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      durationMs: durationMs ?? this.durationMs,
      albumName: albumName ?? this.albumName,
      source: source ?? this.source,
      spotifyId: spotifyId ?? this.spotifyId,
      ytmusicId: ytmusicId ?? this.ytmusicId,
      lastfmId: lastfmId ?? this.lastfmId,
      popularity: popularity ?? this.popularity,
      isLiked: isLiked ?? this.isLiked,
      playedAt: playedAt ?? this.playedAt,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
