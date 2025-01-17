import 'image.dart';

class CommonArtist {
  final String uid;
  final String name;
  final String spotifyId;
  final String spotifyUrl;
  final String href;
  final int popularity;
  final String type;
  final String uri;
  final int followers;
  final List<Image> images;
  final List<String> genres;
  final int? elementIdProperty;

  CommonArtist({
    required this.uid,
    required this.name,
    required this.spotifyId,
    required this.spotifyUrl,
    required this.href,
    required this.popularity,
    required this.type,
    required this.uri,
    required this.followers,
    required this.images,
    required this.genres,
    this.elementIdProperty,
  });

  factory CommonArtist.fromJson(Map<String, dynamic> json) {
    return CommonArtist(
      uid: json['uid'],
      name: json['name'],
      spotifyId: json['spotify_id'],
      spotifyUrl: json['spotify_url'],
      href: json['href'],
      popularity: json['popularity'],
      type: json['type'],
      uri: json['uri'],
      followers: json['followers'],
      images: (json['images'] as List).map((i) => Image.fromJson(i)).toList(),
      genres: List<String>.from(json['genres']),
    );
  }
}
