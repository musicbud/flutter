class CommonTrack {
  final String uid;
  final String name;
  final String artistName;
  final String albumName;
  final String artistId;
  final String albumId;
  final String spotifyId;
  final String ytmusicId;
  final String lastfmId;
  final int durationMs;
  final bool isLiked;
  final DateTime? playedAt;
  final double? latitude;
  final double? longitude;

  CommonTrack({
    required this.uid,
    required this.name,
    required this.artistName,
    required this.albumName,
    required this.artistId,
    required this.albumId,
    required this.spotifyId,
    required this.ytmusicId,
    required this.lastfmId,
    required this.durationMs,
    this.isLiked = false,
    this.playedAt,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'artist_name': artistName,
      'album_name': albumName,
      'artist_id': artistId,
      'album_id': albumId,
      'spotify_id': spotifyId,
      'ytmusic_id': ytmusicId,
      'lastfm_id': lastfmId,
      'duration_ms': durationMs,
      'is_liked': isLiked,
      'played_at': playedAt?.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory CommonTrack.fromJson(Map<String, dynamic> json) {
    return CommonTrack(
      uid: json['uid'] as String,
      name: json['name'] as String,
      artistName: json['artist_name'] as String,
      albumName: json['album_name'] as String,
      artistId: json['artist_id'] as String,
      albumId: json['album_id'] as String,
      spotifyId: json['spotify_id'] as String? ?? '',
      ytmusicId: json['ytmusic_id'] as String? ?? '',
      lastfmId: json['lastfm_id'] as String? ?? '',
      durationMs: json['duration_ms'] as int,
      isLiked: json['is_liked'] as bool? ?? false,
      playedAt: json['played_at'] != null
          ? DateTime.parse(json['played_at'] as String)
          : null,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
    );
  }
}
