class Track {
  final String uid;
  final String name;
  final String spotifyId;
  final String? uri;
  final int? durationMs;
  final String? spotifyUrl;
  // Add these properties
  final String? imageUrl;
  final String? artist;

  Track({
    required this.uid,
    required this.name,
    required this.spotifyId,
    this.uri,
    this.durationMs,
    this.spotifyUrl,
    this.imageUrl,
    this.artist,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      uid: json['uid'],
      name: json['name'],
      spotifyId: json['spotify_id'],
      uri: json['uri'],
      durationMs: json['duration_ms'],
      spotifyUrl: json['spotify_url'],
      // Add these fields
      imageUrl: json['image_url'],
      artist: json['artist'], // You might need to adjust this based on your API response
    );
  }
}
