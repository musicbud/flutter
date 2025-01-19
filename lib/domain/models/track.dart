import 'package:equatable/equatable.dart';

class Track extends Equatable {
  final String id;
  final String title;
  final String artistName;
  final String? albumName;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;
  final DateTime? playedAt;
  final bool isLiked;

  const Track({
    required this.id,
    required this.title,
    required this.artistName,
    this.albumName,
    this.imageUrl,
    this.latitude,
    this.longitude,
    this.playedAt,
    this.isLiked = false,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'] as String,
      title: json['title'] as String,
      artistName: json['artist_name'] as String,
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist_name': artistName,
      'album_name': albumName,
      'image_url': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'played_at': playedAt?.toIso8601String(),
      'is_liked': isLiked,
    };
  }

  Track copyWith({
    String? id,
    String? title,
    String? artistName,
    String? albumName,
    String? imageUrl,
    double? latitude,
    double? longitude,
    DateTime? playedAt,
    bool? isLiked,
  }) {
    return Track(
      id: id ?? this.id,
      title: title ?? this.title,
      artistName: artistName ?? this.artistName,
      albumName: albumName ?? this.albumName,
      imageUrl: imageUrl ?? this.imageUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      playedAt: playedAt ?? this.playedAt,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        artistName,
        albumName,
        imageUrl,
        latitude,
        longitude,
        playedAt,
        isLiked,
      ];
}
