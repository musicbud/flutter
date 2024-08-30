import 'artist.dart';

class Album {
  final String id;
  final String name;
  final List<Artist> artists;
  final String? imageUrl;
  final String? releaseDate;
  final int? totalTracks;
  final String? artist;

  Album({
    required this.id,
    required this.name,
    required this.artists,
    this.imageUrl,
    this.releaseDate,
    this.totalTracks,
    this.artist,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      name: json['name'],
      artists: (json['artists'] as List?)?.map((a) => Artist.fromJson(a)).toList() ?? [],
      imageUrl: json['image_url'],
      releaseDate: json['release_date'],
      totalTracks: json['total_tracks'],
      artist: json['artist'],
    );
  }
}
