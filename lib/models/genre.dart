import '../domain/models/common_genre.dart';

class Genre {
  final String uid;
  final String name;
  final String spotifyId;
  final String ytmusicId;
  final String lastfmId;
  final int popularity;
  final bool isLiked;

  Genre({
    required this.uid,
    required this.name,
    this.spotifyId = '',
    this.ytmusicId = '',
    this.lastfmId = '',
    this.popularity = 0,
    this.isLiked = false,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      uid: json['uid'] as String,
      name: json['name'] as String,
      spotifyId: json['spotify_id'] as String? ?? '',
      ytmusicId: json['ytmusic_id'] as String? ?? '',
      lastfmId: json['lastfm_id'] as String? ?? '',
      popularity: json['popularity'] as int? ?? 0,
      isLiked: json['is_liked'] as bool? ?? false,
    );
  }

  factory Genre.fromCommon(CommonGenre common) {
    return Genre(
      uid: common.uid,
      name: common.name,
      spotifyId: common.spotifyId,
      ytmusicId: common.ytmusicId,
      lastfmId: common.lastfmId,
      popularity: common.popularity,
      isLiked: common.isLiked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'spotify_id': spotifyId,
      'ytmusic_id': ytmusicId,
      'lastfm_id': lastfmId,
      'popularity': popularity,
      'is_liked': isLiked,
    };
  }
}
