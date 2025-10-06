import 'package:musicbud_flutter/models/common_artist.dart';

class Artist {
  final String id;
  final String uid;
  final String name;
  final List<String>? genres;
  final List<String>? imageUrls;
  final String? spotifyId;
  final String? ytmusicId;
  final String? lastfmId;
  final bool isLiked;
  final int? popularity;
  final int? followers;

  Artist({
    required this.id,
    this.uid = '',
    required this.name,
    this.genres,
    this.imageUrls,
    this.spotifyId,
    this.ytmusicId,
    this.lastfmId,
    this.isLiked = false,
    this.popularity,
    this.followers,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'] as String? ?? json['uid'] as String,
      uid: json['uid'] as String? ?? '',
      name: json['name'] as String,
      genres:
          (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
      imageUrls: (json['image_urls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      spotifyId: json['spotify_id'] as String?,
      ytmusicId: json['ytmusic_id'] as String?,
      lastfmId: json['lastfm_id'] as String?,
      isLiked: json['is_liked'] as bool? ?? false,
      popularity: json['popularity'] as int?,
      followers: json['followers'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'genres': genres,
      'image_urls': imageUrls,
      'spotify_id': spotifyId,
      'ytmusic_id': ytmusicId,
      'lastfm_id': lastfmId,
      'is_liked': isLiked,
      'popularity': popularity,
      'followers': followers,
    };
  }

  Artist copyWith({
    String? id,
    String? uid,
    String? name,
    List<String>? genres,
    List<String>? imageUrls,
    String? spotifyId,
    String? ytmusicId,
    String? lastfmId,
    bool? isLiked,
    int? popularity,
    int? followers,
  }) {
    return Artist(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      genres: genres ?? this.genres,
      imageUrls: imageUrls ?? this.imageUrls,
      spotifyId: spotifyId ?? this.spotifyId,
      ytmusicId: ytmusicId ?? this.ytmusicId,
      lastfmId: lastfmId ?? this.lastfmId,
      isLiked: isLiked ?? this.isLiked,
      popularity: popularity ?? this.popularity,
      followers: followers ?? this.followers,
    );
  }

  CommonArtist toCommonArtist() {
    return CommonArtist(
      id: id,
      uid: uid,
      name: name,
      genres: genres,
      imageUrls: imageUrls,
      spotifyId: spotifyId,
      ytmusicId: ytmusicId,
      lastfmId: lastfmId,
      isLiked: isLiked,
      popularity: popularity,
      followers: followers,
    );
  }
}
