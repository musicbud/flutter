import 'package:musicbud_flutter/models/common_artist.dart';

class CommonAlbum {
  final String? name;
  final List<CommonArtist>? artists;
  final String? imageUrl;
  final double? similarityScore;
  final String? artist; // Add this line

  CommonAlbum({
    this.name,
    this.artists,
    this.imageUrl,
    this.similarityScore,
    this.artist, // Add this line
  });

  factory CommonAlbum.fromJson(Map<String, dynamic> json) {
    return CommonAlbum(
      name: json['name'] as String?,
      artists: (json['artists'] as List<dynamic>?)
          ?.map((artistJson) => CommonArtist.fromJson(artistJson as Map<String, dynamic>))
          .toList(),
      imageUrl: json['image_url'] as String?,
      similarityScore: json['similarity_score'] as double?,
      artist: json['artist'] as String?, // Add this line
    );
  }
}
