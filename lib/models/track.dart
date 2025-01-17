class Track {
  final String uid;
  final String name;
  final String artist;
  final String service;
  final String? spotifyId;
  final String? ytmusicId;
  final String? lastfmId;
  final String? imageUrl;

  Track({
    required this.uid,
    required this.name,
    required this.artist,
    required this.service,
    this.spotifyId,
    this.ytmusicId,
    this.lastfmId,
    this.imageUrl,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      uid: json['uid'] as String,
      name: json['name'] as String,
      artist: json['artist'] as String,
      service: json['service'] as String,
      spotifyId: json['spotify_id'] as String?,
      ytmusicId: json['ytmusic_id'] as String?,
      lastfmId: json['lastfm_id'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'artist': artist,
      'service': service,
      'spotify_id': spotifyId,
      'ytmusic_id': ytmusicId,
      'lastfm_id': lastfmId,
      'image_url': imageUrl,
    };
  }
}
