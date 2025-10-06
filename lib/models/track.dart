import 'package:equatable/equatable.dart';
import 'common_track.dart';
import 'artist.dart';

class Track extends CommonTrack with EquatableMixin {
  const Track({
    required String uid,
    required String title,
    String? artistName,
    String? albumName,
    String? imageUrl,
    double? latitude,
    double? longitude,
    DateTime? playedAt,
    bool isLiked = false,
  }) : super(
          id: uid,
          name: title,
          artistName: artistName,
          albumName: albumName,
          imageUrl: imageUrl,
          latitude: latitude,
          longitude: longitude,
          playedAt: playedAt,
          isLiked: isLiked,
        );

 // Getter to provide artist object for compatibility
 Artist? get artist {
   if (artistName == null) return null;
   return Artist(
     id: '', // No artist ID available
     name: artistName!,
     isLiked: false,
   );
 }

 factory Track.fromJson(Map<String, dynamic> json) {
    // Handle backend response structure
    // Backend returns 'uid' and 'name'
    final uid = json['uid'] as String? ?? json['id'] as String? ?? '';
    final title = json['name'] as String? ?? json['title'] as String? ?? '';

    // Backend may not include artist info directly in track serialization
    // This might need to be populated from related data
    final artistName = json['artist_name'] as String?;
    final albumName = json['album_name'] as String?;

    // Handle image URL - backend returns images array, take first one
    String? imageUrl = json['image_url'] as String?;
    if (imageUrl == null && json['images'] is List && (json['images'] as List).isNotEmpty) {
      final images = json['images'] as List;
      if (images.isNotEmpty && images[0] is Map<String, dynamic>) {
        imageUrl = images[0]['url'] as String?;
      }
    }

    return Track(
      uid: uid,
      title: title,
      artistName: artistName,
      albumName: albumName,
      imageUrl: imageUrl,
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
      'uid': id,
      'name': name,
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
