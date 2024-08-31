class CommonArtist {
  final String? uid;
  final List<String>? genres;
  final String? spotifyId;
  final String? name;
  final String? uri;
  final String? spotifyUrl;
  final String? imageUrl;        // Add this
  final double? similarityScore; // Add this

  CommonArtist({
    this.uid,
    this.genres,
    this.spotifyId,
    this.name,
    this.uri,
    this.spotifyUrl,
    this.imageUrl,        // Add this
    this.similarityScore, // Add this
  });

  factory CommonArtist.fromJson(Map<String, dynamic> json) {
    return CommonArtist(
      uid: json['uid'] as String?,
      genres: (json['genres'] as List<dynamic>?)?.cast<String>(),
      spotifyId: json['spotify_id'] as String?,
      name: json['name'] as String?,
      uri: json['uri'] as String?,
      spotifyUrl: json['spotify_url'] as String?,
      imageUrl: json['image_url'] as String?,        // Add this
      similarityScore: json['similarity_score'] as double?, // Add this
    );
  }
}
