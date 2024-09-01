import 'package:musicbud_flutter/models/common_artist.dart';

class CommonTrack {
  final String? name;
  final List<CommonArtist>? artists;
  final String? albumImageUrl;
  final double? similarityScore;

  CommonTrack({
    this.name,
    this.artists,
    this.albumImageUrl,
    this.similarityScore,
  });

  factory CommonTrack.fromJson(Map<String, dynamic> json) {
    return CommonTrack(
      name: json['name'] as String?,
      artists: (json['artists'] as List<dynamic>?)
          ?.map((e) => CommonArtist.fromJson(e as Map<String, dynamic>))
          .toList(),
      albumImageUrl: json['album_image_url'] as String?,
      similarityScore: json['similarity_score'] as double?,
    );
  }
}
