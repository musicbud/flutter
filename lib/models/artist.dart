import 'bud.dart';

class Artist {
  final String id;
  final String name;
  final String? imageUrl;

  Artist({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String?,
    );
  }
}
