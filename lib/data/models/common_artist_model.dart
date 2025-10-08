import '../../models/common_artist.dart';

class CommonArtistModel extends CommonArtist {
  CommonArtistModel({
    required super.id,
    super.uid = '',
    required super.name,
    super.source,
    super.spotifyId,
    super.ytmusicId,
    super.lastfmId,
    super.popularity,
    super.isLiked = false,
    super.imageUrl,
    super.imageUrls,
    super.followers,
    super.genres,
  });

  factory CommonArtistModel.fromJson(Map<String, dynamic> json) {
    return CommonArtistModel(
      id: json['id'] as String,
      uid: json['uid'] as String? ?? '',
      name: json['name'] as String,
      source: json['source'] as String?,
      spotifyId: json['spotify_id'] as String?,
      ytmusicId: json['ytmusic_id'] as String?,
      lastfmId: json['lastfm_id'] as String?,
      popularity: json['popularity'] as int?,
      isLiked: json['is_liked'] as bool? ?? false,
      imageUrl: json['image_url'] as String?,
      imageUrls: (json['image_urls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      followers: json['followers'] as int?,
      genres:
          (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }

  @override
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
      'image_url': imageUrl,
      'image_urls': imageUrls,
      'followers': followers,
      'genres': genres,
    };
  }
}
