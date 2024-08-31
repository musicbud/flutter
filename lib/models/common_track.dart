class CommonTrack {
  final String? uid;
  final String? spotifyId;
  final String? name;
  final String? uri;
  final String? spotifyUrl;
  final int? durationMs;
  final String? image;  // Add this
  final String? artist; // Add this

  CommonTrack({
    this.uid,
    this.spotifyId,
    this.name,
    this.uri,
    this.spotifyUrl,
    this.durationMs,
    this.image,    // Add this
    this.artist,   // Add this
  });

  factory CommonTrack.fromJson(Map<String, dynamic> json) {
    return CommonTrack(
      uid: json['uid'] as String?,
      spotifyId: json['spotify_id'] as String?,
      name: json['name'] as String?,
      uri: json['uri'] as String?,
      spotifyUrl: json['spotify_url'] as String?,
      durationMs: json['duration_ms'] as int?,
      image: json['image'] as String?,    // Add this
      artist: json['artist'] as String?,  // Add this
    );
  }
}
