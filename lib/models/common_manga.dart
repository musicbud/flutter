class CommonManga {
  final String uid;
  final String title;
  final String status;
  final String imageUrl;

  CommonManga({
    required this.uid,
    required this.title,
    required this.status,
    required this.imageUrl,
  });

  factory CommonManga.fromJson(Map<String, dynamic> json) {
    return CommonManga(
      uid: json['uid'] ?? '',
      title: json['title'] ?? '',
      status: json['status'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }
}
