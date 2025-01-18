import '../domain/models/common_album.dart';

class Album {
  final String uid;
  final String name;
  final String artistName;
  final String artistId;
  final String spotifyId;
  final String ytmusicId;
  final String lastfmId;
  final List<String> imageUrls;
  final List<String> genres;
  final int releaseYear;
  final int popularity;
  final bool isLiked;

  Album({
    required this.uid,
    required this.name,
    required this.artistName,
    required this.artistId,
    this.spotifyId = '',
    this.ytmusicId = '',
    this.lastfmId = '',
    this.imageUrls = const [],
    this.genres = const [],
    required this.releaseYear,
    this.popularity = 0,
    this.isLiked = false,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      uid: json['uid'] as String,
      name: json['name'] as String,
      artistName: json['artist_name'] as String,
      artistId: json['artist_id'] as String,
      spotifyId: json['spotify_id'] as String? ?? '',
      ytmusicId: json['ytmusic_id'] as String? ?? '',
      lastfmId: json['lastfm_id'] as String? ?? '',
      imageUrls: (json['image_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      releaseYear: json['release_year'] as int,
      popularity: json['popularity'] as int? ?? 0,
      isLiked: json['is_liked'] as bool? ?? false,
    );
  }

  factory Album.fromCommon(CommonAlbum common) {
    return Album(
      uid: common.uid,
      name: common.name,
      artistName: common.artistName,
      artistId: common.artistId,
      spotifyId: common.spotifyId,
      ytmusicId: common.ytmusicId,
      lastfmId: common.lastfmId,
      imageUrls: common.imageUrls,
      genres: common.genres,
      releaseYear: common.releaseYear,
      popularity: common.popularity,
      isLiked: common.isLiked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'artist_name': artistName,
      'artist_id': artistId,
      'spotify_id': spotifyId,
      'ytmusic_id': ytmusicId,
      'lastfm_id': lastfmId,
      'image_urls': imageUrls,
      'genres': genres,
      'release_year': releaseYear,
      'popularity': popularity,
      'is_liked': isLiked,
    };
  }
}
