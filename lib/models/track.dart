import 'artist.dart';
import 'bud.dart';

class Track {
  final String id;
  final String name;
  final List<Artist> artists;
  final String? albumName;
  final String? albumImageUrl;
  final int? popularity;
  final List<Bud> buds;

  Track({
    required this.id,
    required this.name,
    required List<Artist> artists,  // Changed this line
    this.albumName,
    this.albumImageUrl,
    this.popularity,
    this.buds = const [],
  }) : artists = artists.isNotEmpty ? artists : [Artist(id: '', name: 'Unknown Artist')];  // This line ensures there's always at least one artist

  factory Track.fromJson(Map<String, dynamic> json) {
    List<Artist> artistsList = (json['artists'] as List?)
        ?.map((a) => Artist.fromJson(a))
        .toList() 
        ?? [];
    
    return Track(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      artists: artistsList,  // Pass the parsed list here
      albumName: json['album']?['name']?.toString(),
      albumImageUrl: json['album']?['images']?[0]?['url']?.toString(),
      popularity: json['popularity'] as int?,
      buds: (json['buds'] as List?)
          ?.map((b) => Bud.fromJson(b))
          .toList() ?? [],
    );
  }
}
