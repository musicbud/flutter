import '../domain/models/common_track.dart';

class Track {
  final String uid;
  final String artistName;
  final String albumName;
  final String artistId;
  final String albumId;
  final String name;
  final String spotifyId;
  final String ytmusicId;
  final String lastfmId;
  final int durationMs;
  final bool isLiked;
  final DateTime? playedAt;
  final double? latitude;
  final double? longitude;

  Track({
    required this.uid,
    required this.artistName,
    required this.albumName,
    required this.artistId,
    required this.albumId,
    required this.name,
    this.spotifyId = '',
    this.ytmusicId = '',
    this.lastfmId = '',
    required this.durationMs,
    this.isLiked = false,
    this.playedAt,
    this.latitude,
    this.longitude,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      uid: json['uid'] as String,
      artistName: json['artist_name'] as String,
      albumName: json['album_name'] as String,
      artistId: json['artist_id'] as String,
      albumId: json['album_id'] as String,
      name: json['name'] as String,
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

  factory Track.fromCommon(CommonTrack common) {
    return Track(
      uid: common.uid,
      artistName: common.artistName,
      albumName: common.albumName,
      artistId: common.artistId,
      albumId: common.albumId,
      name: common.name,
      spotifyId: common.spotifyId,
      ytmusicId: common.ytmusicId,
      lastfmId: common.lastfmId,
      durationMs: common.durationMs,
      isLiked: common.isLiked,
      playedAt: common.playedAt,
      latitude: common.latitude,
      longitude: common.longitude,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'artist_name': artistName,
      'album_name': albumName,
      'artist_id': artistId,
      'album_id': albumId,
      'name': name,
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
}
