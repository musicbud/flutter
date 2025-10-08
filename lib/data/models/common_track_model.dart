import '../../models/common_track.dart';

class CommonTrackModel extends CommonTrack {
  CommonTrackModel({
    required super.id,
    required super.name,
    super.artistName,
    super.imageUrl,
    super.imageUrls,
    super.durationMs,
    super.albumName,
    super.source,
    super.spotifyId,
    super.ytmusicId,
    super.lastfmId,
    super.popularity,
    super.isLiked = false,
    super.playedAt,
    super.latitude,
    super.longitude,
  });

  factory CommonTrackModel.fromJson(Map<String, dynamic> json) {
    return CommonTrackModel(
      id: json['id'] as String,
      name: json['name'] as String,
      artistName: json['artist_name'] as String?,
      imageUrl: json['image_url'] as String?,
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

  @override
  Map<String, dynamic> toJson() {
    return {
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
}
