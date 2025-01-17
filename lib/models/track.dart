class Track {
  final String id;
  final String name;
  final String artist;
  final String spotifyId;
  final String spotifyUrl;
  final String? imageUrl;

  Track({
    required this.id,
    required this.name,
    required this.artist,
    required this.spotifyId,
    required this.spotifyUrl,
    this.imageUrl,
  });
}
