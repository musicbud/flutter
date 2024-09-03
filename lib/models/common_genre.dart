class CommonGenre {
  final String uid;
  final String name;
  final String elementIdProperty;

  CommonGenre({
    required this.uid,
    required this.name,
    required this.elementIdProperty,
  });

  factory CommonGenre.fromJson(Map<String, dynamic> json) {
    return CommonGenre(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      elementIdProperty: json['element_id_property'] ?? '',
    );
  }

  // Add this getter for the default image
  String get defaultImageUrl => 'https://example.com/default_genre_image.jpg'; // Replace with your actual default image URL
}
