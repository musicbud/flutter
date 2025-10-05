import '../domain/models/common_track.dart';

/// Represents a track in the application
class Track {
  final String id;
  final String title;
  final String? artistName;
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
  final String? imageUrl;
  final List<String>? imageUrls;
  final int? durationMs;

  Track({
    required this.id,
    required this.title,
    this.artistName,
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
    this.imageUrl,
    this.imageUrls,
    this.durationMs,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'] as String,
      title: json['title'] as String,
      artistName: json['artist_name'] as String?,
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
      imageUrl: json['image_url'] as String?,
      imageUrls: (json['image_urls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      durationMs: json['duration_ms'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist_name': artistName,
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
      'image_url': imageUrl,
      'image_urls': imageUrls,
      'duration_ms': durationMs,
    };
  }

  factory Track.fromCommonTrack(CommonTrack track) {
    return Track(
      id: track.id,
      title: track.title,
      artistName: track.artistName,
      albumName: track.albumName,
      source: track.source,
      spotifyId: track.spotifyId,
      ytmusicId: track.ytmusicId,
      lastfmId: track.lastfmId,
      popularity: track.popularity,
      isLiked: track.isLiked,
      playedAt: track.playedAt,
      latitude: track.latitude,
      longitude: track.longitude,
      imageUrl: track.imageUrl,
      imageUrls: track.imageUrls,
      durationMs: track.durationMs,
    );
  }

  Track copyWith({
    String? id,
    String? title,
    String? artistName,
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
    String? imageUrl,
    List<String>? imageUrls,
    int? durationMs,
  }) {
    return Track(
      id: id ?? this.id,
      title: title ?? this.title,
      artistName: artistName ?? this.artistName,
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
      imageUrl: imageUrl ?? this.imageUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      durationMs: durationMs ?? this.durationMs,
    );
  }
}
