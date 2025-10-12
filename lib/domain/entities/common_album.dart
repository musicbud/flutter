import 'package:equatable/equatable.dart';

/// Common album entity for unified album representation
class CommonAlbum extends Equatable {
  final String? id;
  final String name;
  final String artistName;
  final String? imageUrl;
  final int? totalTracks;
  final DateTime? releaseDate;
  final List<String> genres;
  final int? popularity;
  final String? spotifyId;
  final String? appleMusicId;
  final String? youtubeId;
  final Map<String, dynamic>? metadata;

  const CommonAlbum({
    this.id,
    required this.name,
    required this.artistName,
    this.imageUrl,
    this.totalTracks,
    this.releaseDate,
    required this.genres,
    this.popularity,
    this.spotifyId,
    this.appleMusicId,
    this.youtubeId,
    this.metadata,
  });

  factory CommonAlbum.fromJson(Map<String, dynamic> json) {
    return CommonAlbum(
      id: json['id'],
      name: json['name'] ?? json['title'] ?? '',
      artistName: json['artist_name'] ?? json['artistName'] ?? json['artist'] ?? '',
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? json['image'],
      totalTracks: json['total_tracks'] ?? json['totalTracks'],
      releaseDate: json['release_date'] != null || json['releaseDate'] != null
          ? DateTime.tryParse(json['release_date'] ?? json['releaseDate'] ?? '')
          : null,
      genres: List<String>.from(json['genres'] ?? []),
      popularity: json['popularity'],
      spotifyId: json['spotify_id'] ?? json['spotifyId'],
      appleMusicId: json['apple_music_id'] ?? json['appleMusicId'],
      youtubeId: json['youtube_id'] ?? json['youtubeId'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'artist_name': artistName,
      'image_url': imageUrl,
      'total_tracks': totalTracks,
      'release_date': releaseDate?.toIso8601String(),
      'genres': genres,
      'popularity': popularity,
      'spotify_id': spotifyId,
      'apple_music_id': appleMusicId,
      'youtube_id': youtubeId,
      'metadata': metadata,
    };
  }

  CommonAlbum copyWith({
    String? id,
    String? name,
    String? artistName,
    String? imageUrl,
    int? totalTracks,
    DateTime? releaseDate,
    List<String>? genres,
    int? popularity,
    String? spotifyId,
    String? appleMusicId,
    String? youtubeId,
    Map<String, dynamic>? metadata,
  }) {
    return CommonAlbum(
      id: id ?? this.id,
      name: name ?? this.name,
      artistName: artistName ?? this.artistName,
      imageUrl: imageUrl ?? this.imageUrl,
      totalTracks: totalTracks ?? this.totalTracks,
      releaseDate: releaseDate ?? this.releaseDate,
      genres: genres ?? this.genres,
      popularity: popularity ?? this.popularity,
      spotifyId: spotifyId ?? this.spotifyId,
      appleMusicId: appleMusicId ?? this.appleMusicId,
      youtubeId: youtubeId ?? this.youtubeId,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        artistName,
        imageUrl,
        totalTracks,
        releaseDate,
        genres,
        popularity,
        spotifyId,
        appleMusicId,
        youtubeId,
        metadata,
      ];

  @override
  String toString() {
    return 'CommonAlbum(id: $id, name: $name, artistName: $artistName)';
  }
}
