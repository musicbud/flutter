import '../../models/common_genre.dart';

class CommonGenreModel extends CommonGenre {
  CommonGenreModel({
    required String id,
    String uid = '',
    required String name,
    String? source,
    String? spotifyId,
    String? ytmusicId,
    String? lastfmId,
    int? popularity,
    bool isLiked = false,
    String? imageUrl,
    List<String>? imageUrls,
  }) : super(
          id: id,
          uid: uid,
          name: name,
          source: source,
          spotifyId: spotifyId,
          ytmusicId: ytmusicId,
          lastfmId: lastfmId,
          popularity: popularity,
          isLiked: isLiked,
          imageUrl: imageUrl,
          imageUrls: imageUrls,
        );

  factory CommonGenreModel.fromJson(Map<String, dynamic> json) {
    return CommonGenreModel(
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
    };
  }
}
