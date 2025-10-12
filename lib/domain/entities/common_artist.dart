import 'package:equatable/equatable.dart';

/// Common artist entity for unified artist representation
class CommonArtist extends Equatable {
  final String? id;
  final String name;
  final String? imageUrl;
  final int? followers;
  final List<String> genres;
  final int? popularity;
  final String? spotifyId;
  final String? appleMusicId;
  final String? youtubeId;
  final Map<String, dynamic>? metadata;

  const CommonArtist({
    this.id,
    required this.name,
    this.imageUrl,
    this.followers,
    required this.genres,
    this.popularity,
    this.spotifyId,
    this.appleMusicId,
    this.youtubeId,
    this.metadata,
  });

  factory CommonArtist.fromJson(Map<String, dynamic> json) {
    return CommonArtist(
      id: json['id'],
      name: json['name'] ?? '',
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? json['image'],
      followers: json['followers'],
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
      'image_url': imageUrl,
      'followers': followers,
      'genres': genres,
      'popularity': popularity,
      'spotify_id': spotifyId,
      'apple_music_id': appleMusicId,
      'youtube_id': youtubeId,
      'metadata': metadata,
    };
  }

  CommonArtist copyWith({
    String? id,
    String? name,
    String? imageUrl,
    int? followers,
    List<String>? genres,
    int? popularity,
    String? spotifyId,
    String? appleMusicId,
    String? youtubeId,
    Map<String, dynamic>? metadata,
  }) {
    return CommonArtist(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      followers: followers ?? this.followers,
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
        imageUrl,
        followers,
        genres,
        popularity,
        spotifyId,
        appleMusicId,
        youtubeId,
        metadata,
      ];

  @override
  String toString() {
    return 'CommonArtist(id: $id, name: $name)';
  }
}
