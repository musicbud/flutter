class Album {
  final String uid;
  final String name;
  final String artist;
  final String? imageUrl;

  Album({
    required this.uid,
    required this.name,
    required this.artist,
    this.imageUrl,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      uid: json['uid'],
      name: json['name'],
      artist: json['artist'],
      imageUrl: json['image_url'],
    );
  }
}
