import 'artist.dart';

class Track {
  final String id;
  final String name;
  final List<Artist> artists;
  final String? albumName;
  final String? imageUrl;
  final String? artistName;
  final int? durationMs;
  final bool? explicit;
  final int? popularity;

  Track({
    required this.id,
    required this.name,
    required this.artists,
    this.albumName,
    this.imageUrl,
    this.artistName,
    this.durationMs,
    this.explicit,
    this.popularity,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      artists: (json['artists'] as List?)?.map((a) => Artist.fromJson(a)).toList() ?? [],
      albumName: json['album_name'],
      imageUrl: json['image_url'],
      artistName: json['artist_name'],
      durationMs: json['duration_ms'],
      explicit: json['explicit'],
      popularity: json['popularity'],
    );
  }
}
