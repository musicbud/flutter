class CommonAlbum {
  final String? name;
  final String? artist;
  final String? imageUrl;

  CommonAlbum({this.name, this.artist, this.imageUrl});

  factory CommonAlbum.fromJson(Map<String, dynamic> json) {
    return CommonAlbum(
      name: json['name'] as String?,
      artist: json['artist'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }
}
