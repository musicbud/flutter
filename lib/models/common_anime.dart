class CommonAnime {
  final String uid;
  final String title;
  final String status;
  final String imageUrl;

  CommonAnime({
    required this.uid,
    required this.title,
    required this.status,
    required this.imageUrl,
  });

  factory CommonAnime.fromJson(Map<String, dynamic> json) {
    return CommonAnime(
      uid: json['uid'] ?? '',
      title: json['title'] ?? '',
      status: json['status'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }
}
