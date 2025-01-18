import '../domain/models/common_artist.dart';

class Artist {
  final String uid;
  final String name;
  final String spotifyId;
  final String ytmusicId;
  final String lastfmId;
  final List<String> imageUrls;
  final int popularity;
  final int followers;
  final bool isLiked;

  Artist({
    required this.uid,
    required this.name,
    this.spotifyId = '',
    this.ytmusicId = '',
    this.lastfmId = '',
    this.imageUrls = const [],
    this.popularity = 0,
    this.followers = 0,
    this.isLiked = false,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      uid: json['uid'] as String,
      name: json['name'] as String,
      spotifyId: json['spotify_id'] as String? ?? '',
      ytmusicId: json['ytmusic_id'] as String? ?? '',
      lastfmId: json['lastfm_id'] as String? ?? '',
      imageUrls: (json['image_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      popularity: json['popularity'] as int? ?? 0,
      followers: json['followers'] as int? ?? 0,
      isLiked: json['is_liked'] as bool? ?? false,
    );
  }

  factory Artist.fromCommon(CommonArtist common) {
    return Artist(
      uid: common.uid,
      name: common.name,
      spotifyId: common.spotifyId,
      ytmusicId: common.ytmusicId,
      lastfmId: common.lastfmId,
      imageUrls: common.imageUrls,
      popularity: common.popularity,
      followers: common.followers,
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
      'image_urls': imageUrls,
      'popularity': popularity,
      'followers': followers,
      'is_liked': isLiked,
    };
  }
}
