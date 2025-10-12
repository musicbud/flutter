import 'package:equatable/equatable.dart';

/// Common track entity for unified track representation
class CommonTrack extends Equatable {
  final String? id;
  final String title;
  final String artistName;
  final String? albumName;
  final int? duration;
  final String? imageUrl;
  final String? previewUrl;
  final String? spotifyId;
  final String? appleMusicId;
  final String? youtubeId;
  final List<String> genres;
  final int? popularity;
  final DateTime? releaseDate;
  final Map<String, dynamic>? metadata;

  const CommonTrack({
    this.id,
    required this.title,
    required this.artistName,
    this.albumName,
    this.duration,
    this.imageUrl,
    this.previewUrl,
    this.spotifyId,
    this.appleMusicId,
    this.youtubeId,
    required this.genres,
    this.popularity,
    this.releaseDate,
    this.metadata,
  });

  factory CommonTrack.fromJson(Map<String, dynamic> json) {
    return CommonTrack(
      id: json['id'],
      title: json['title'] ?? json['name'] ?? '',
      artistName: json['artist_name'] ?? json['artistName'] ?? json['artist'] ?? '',
      albumName: json['album_name'] ?? json['albumName'] ?? json['album'],
      duration: json['duration'],
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? json['image'],
      previewUrl: json['preview_url'] ?? json['previewUrl'] ?? json['preview'],
      spotifyId: json['spotify_id'] ?? json['spotifyId'],
      appleMusicId: json['apple_music_id'] ?? json['appleMusicId'],
      youtubeId: json['youtube_id'] ?? json['youtubeId'],
      genres: List<String>.from(json['genres'] ?? []),
      popularity: json['popularity'],
      releaseDate: json['release_date'] != null || json['releaseDate'] != null
          ? DateTime.tryParse(json['release_date'] ?? json['releaseDate'] ?? '')
          : null,
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist_name': artistName,
      'album_name': albumName,
      'duration': duration,
      'image_url': imageUrl,
      'preview_url': previewUrl,
      'spotify_id': spotifyId,
      'apple_music_id': appleMusicId,
      'youtube_id': youtubeId,
      'genres': genres,
      'popularity': popularity,
      'release_date': releaseDate?.toIso8601String(),
      'metadata': metadata,
    };
  }

  CommonTrack copyWith({
    String? id,
    String? title,
    String? artistName,
    String? albumName,
    int? duration,
    String? imageUrl,
    String? previewUrl,
    String? spotifyId,
    String? appleMusicId,
    String? youtubeId,
    List<String>? genres,
    int? popularity,
    DateTime? releaseDate,
    Map<String, dynamic>? metadata,
  }) {
    return CommonTrack(
      id: id ?? this.id,
      title: title ?? this.title,
      artistName: artistName ?? this.artistName,
      albumName: albumName ?? this.albumName,
      duration: duration ?? this.duration,
      imageUrl: imageUrl ?? this.imageUrl,
      previewUrl: previewUrl ?? this.previewUrl,
      spotifyId: spotifyId ?? this.spotifyId,
      appleMusicId: appleMusicId ?? this.appleMusicId,
      youtubeId: youtubeId ?? this.youtubeId,
      genres: genres ?? this.genres,
      popularity: popularity ?? this.popularity,
      releaseDate: releaseDate ?? this.releaseDate,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        artistName,
        albumName,
        duration,
        imageUrl,
        previewUrl,
        spotifyId,
        appleMusicId,
        youtubeId,
        genres,
        popularity,
        releaseDate,
        metadata,
      ];

  @override
  String toString() {
    return 'CommonTrack(id: $id, title: $title, artistName: $artistName)';
  }
}
