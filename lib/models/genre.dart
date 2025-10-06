import '../models/common_genre.dart';

/// Represents a genre in the application
class Genre {
  final String id;
  final String uid;
  final String name;
  final String? source;
  final String? spotifyId;
  final String? ytmusicId;
  final String? lastfmId;
  final int popularity;
  final bool isLiked;

  Genre({
    required this.id,
    this.uid = '',
    required this.name,
    this.source,
    this.spotifyId,
    this.ytmusicId,
    this.lastfmId,
    required this.popularity,
    this.isLiked = false,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'] as String? ?? json['uid'] as String,
      uid: json['uid'] as String? ?? '',
      name: json['name'] as String,
      source: json['source'] as String?,
      spotifyId: json['spotify_id'] as String?,
      ytmusicId: json['ytmusic_id'] as String?,
      lastfmId: json['lastfm_id'] as String?,
      popularity: json['popularity'] as int? ?? 0,
      isLiked: json['is_liked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'source': source,
      'spotify_id': spotifyId,
      'ytmusic_id': ytmusicId,
      'lastfm_id': lastfmId,
      'popularity': popularity,
      'is_liked': isLiked,
    };
  }

  factory Genre.fromCommonGenre(CommonGenre genre) {
    return Genre(
      id: genre.id,
      uid: genre.uid ?? '',
      name: genre.name,
      source: genre.source,
      spotifyId: genre.spotifyId,
      ytmusicId: genre.ytmusicId,
      lastfmId: genre.lastfmId,
      popularity: genre.popularity ?? 0,
      isLiked: genre.isLiked,
    );
  }

  Genre copyWith({
    String? id,
    String? uid,
    String? name,
    String? source,
    String? spotifyId,
    String? ytmusicId,
    String? lastfmId,
    int? popularity,
    bool? isLiked,
  }) {
    return Genre(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      source: source ?? this.source,
      spotifyId: spotifyId ?? this.spotifyId,
      ytmusicId: ytmusicId ?? this.ytmusicId,
      lastfmId: lastfmId ?? this.lastfmId,
      popularity: popularity ?? this.popularity,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
