import 'package:musicbud_flutter/models/common_album.dart';

class Album {
  final String id;
  final String uid;
  final String name;
  final String artistName;
  final String? artistId;
  final List<String>? imageUrls;
  final String? spotifyId;
  final String? ytmusicId;
  final String? lastfmId;
  final bool isLiked;
  final int? releaseYear;
  final int? totalTracks;
  final List<String>? genres;

  Album({
    required this.id,
    this.uid = '',
    required this.name,
    required this.artistName,
    this.artistId,
    this.imageUrls,
    this.spotifyId,
    this.ytmusicId,
    this.lastfmId,
    this.isLiked = false,
    this.releaseYear,
    this.totalTracks,
    this.genres,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] as String? ?? json['uid'] as String,
      uid: json['uid'] as String? ?? '',
      name: json['name'] as String,
      artistName: json['artist_name'] as String,
      artistId: json['artist_id'] as String?,
      imageUrls: (json['image_urls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      spotifyId: json['spotify_id'] as String?,
      ytmusicId: json['ytmusic_id'] as String?,
      lastfmId: json['lastfm_id'] as String?,
      isLiked: json['is_liked'] as bool? ?? false,
      releaseYear: json['release_year'] as int?,
      totalTracks: json['total_tracks'] as int?,
      genres:
          (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'artist_name': artistName,
      'artist_id': artistId,
      'image_urls': imageUrls,
      'spotify_id': spotifyId,
      'ytmusic_id': ytmusicId,
      'lastfm_id': lastfmId,
      'is_liked': isLiked,
      'release_year': releaseYear,
      'total_tracks': totalTracks,
      'genres': genres,
    };
  }

  // Getter methods for backward compatibility
  String get title => name;
  String get artist => artistName;
  String? get imageUrl => imageUrls?.isNotEmpty == true ? imageUrls!.first : null;
  String? get coverUrl => imageUrl;
  String? get coverImageUrl => imageUrl;

  CommonAlbum toCommonAlbum() {
    return CommonAlbum(
      id: id,
      uid: uid,
      name: name,
      artistName: artistName,
      artistId: artistId,
      imageUrls: imageUrls,
      spotifyId: spotifyId,
      ytmusicId: ytmusicId,
      lastfmId: lastfmId,
      isLiked: isLiked,
      releaseYear: releaseYear,
      totalTracks: totalTracks,
      genres: genres,
    );
  }
}
