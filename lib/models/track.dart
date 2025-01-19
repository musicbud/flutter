import 'package:musicbud_flutter/domain/models/common_track.dart';

class Track {
  final String id;
  final String uid;
  final String title;
  final String name;
  final String artistName;
  final String? albumName;
  final String? artistId;
  final String? albumId;
  final String? spotifyId;
  final String? ytmusicId;
  final String? lastfmId;
  final String? imageUrl;
  final int? durationMs;
  final bool isLiked;
  final DateTime? playedAt;
  final String? source;
  final double? latitude;
  final double? longitude;

  Track({
    required this.id,
    this.uid = '',
    required this.title,
    this.name = '',
    required this.artistName,
    this.albumName,
    this.artistId,
    this.albumId,
    this.spotifyId,
    this.ytmusicId,
    this.lastfmId,
    this.imageUrl,
    this.durationMs,
    this.isLiked = false,
    this.playedAt,
    this.source,
    this.latitude,
    this.longitude,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'] as String? ?? json['uid'] as String,
      uid: json['uid'] as String? ?? '',
      title: json['title'] as String? ?? json['name'] as String,
      name: json['name'] as String? ?? json['title'] as String,
      artistName: json['artist_name'] as String,
      albumName: json['album_name'] as String?,
      artistId: json['artist_id'] as String?,
      albumId: json['album_id'] as String?,
      spotifyId: json['spotify_id'] as String?,
      ytmusicId: json['ytmusic_id'] as String?,
      lastfmId: json['lastfm_id'] as String?,
      imageUrl: json['image_url'] as String?,
      durationMs: json['duration_ms'] as int?,
      isLiked: json['is_liked'] as bool? ?? false,
      playedAt: json['played_at'] != null
          ? DateTime.parse(json['played_at'] as String)
          : null,
      source: json['source'] as String?,
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'title': title,
      'name': name,
      'artist_name': artistName,
      'album_name': albumName,
      'artist_id': artistId,
      'album_id': albumId,
      'spotify_id': spotifyId,
      'ytmusic_id': ytmusicId,
      'lastfm_id': lastfmId,
      'image_url': imageUrl,
      'duration_ms': durationMs,
      'is_liked': isLiked,
      'played_at': playedAt?.toIso8601String(),
      'source': source,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  CommonTrack toCommonTrack() {
    return CommonTrack(
      id: id,
      uid: uid,
      title: title,
      name: name,
      artistName: artistName,
      albumName: albumName,
      artistId: artistId,
      albumId: albumId,
      spotifyId: spotifyId,
      ytmusicId: ytmusicId,
      lastfmId: lastfmId,
      imageUrl: imageUrl,
      durationMs: durationMs,
      isLiked: isLiked,
      playedAt: playedAt,
      source: source,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
