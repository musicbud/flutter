class Artist {
  final String uid;
  final String name;
  final String spotifyId;
  final String? imageUrl;
  final List<String> genres;
  final String uri;
  final String spotifyUrl;

  Artist({
    required this.uid,
    required this.name,
    required this.spotifyId,
    this.imageUrl,
    required this.genres,
    required this.uri,
    required this.spotifyUrl,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      uid: json['uid'],
      name: json['name'],
      spotifyId: json['spotify_id'],
      imageUrl: json['images'] != null && json['images'].isNotEmpty ? json['images'][0] : null,
      genres: List<String>.from(json['genres'] ?? []),
      uri: json['uri'],
      spotifyUrl: json['spotify_url'],
    );
  }
}
