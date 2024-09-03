import 'package:musicbud_flutter/models/common_artist.dart';

class CommonAlbum {
  final String uid;
  final String name;
  final String artist;
  final String spotifyId;
  final String spotifyUrl;
  final List<ArtworkImage> images;
  final double? similarityScore;

  CommonAlbum({
    required this.uid,
    required this.name,
    required this.artist,
    required this.spotifyId,
    required this.spotifyUrl,
    required this.images,
    this.similarityScore,
  });

  String get imageUrl => images.isNotEmpty ? images.first.url : '';

  factory CommonAlbum.fromJson(Map<String, dynamic> json) {
    return CommonAlbum(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      artist: json['artist'] ?? '',
      spotifyId: json['spotify_id'] ?? '',
      spotifyUrl: json['spotify_url'] ?? '',
      images: (json['images'] as List<dynamic>?)
              ?.map((image) => ArtworkImage.fromJson(image))
              .toList() ??
          [],
      similarityScore: json['similarity_score'] != null
          ? double.tryParse(json['similarity_score'].toString())
          : null,
    );
  }
}
