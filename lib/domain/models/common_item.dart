class CommonItem {
  final String name;
  final String? artist;
  final String? imageUrl;

  CommonItem({required this.name, this.artist, this.imageUrl});

  factory CommonItem.fromJson(Map<String, dynamic> json) {
    return CommonItem(
      name: json['name'] ?? json['title'] ?? '',
      artist: json['artist'] ?? json['artists']?.first ?? '',
      imageUrl: json['image_url'] ?? json['album']?['images']?.first?['url'],
    );
  }
}
