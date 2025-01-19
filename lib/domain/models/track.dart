import 'package:equatable/equatable.dart';
import 'common_track.dart';

class Track extends CommonTrack with EquatableMixin {
  const Track({
    required String id,
    required String title,
    String? artistName,
    String? albumName,
    String? imageUrl,
    double? latitude,
    double? longitude,
    DateTime? playedAt,
    bool isLiked = false,
  }) : super(
          id: id,
          name: title,
          artistName: artistName,
          albumName: albumName,
          imageUrl: imageUrl,
          latitude: latitude,
          longitude: longitude,
          playedAt: playedAt,
          isLiked: isLiked,
        );

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'] as String,
      title: json['title'] as String,
      artistName: json['artist_name'] as String?,
      albumName: json['album_name'] as String?,
      imageUrl: json['image_url'] as String?,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      playedAt: json['played_at'] != null
          ? DateTime.parse(json['played_at'] as String)
          : null,
      isLiked: json['is_liked'] as bool? ?? false,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': name,
      'artist_name': artistName,
      'album_name': albumName,
      'image_url': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'played_at': playedAt?.toIso8601String(),
      'is_liked': isLiked,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        artistName,
        albumName,
        imageUrl,
        latitude,
        longitude,
        playedAt,
        isLiked,
      ];
}
