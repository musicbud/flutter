import 'bud.dart';

class Artist {
  final String id;
  final String name;
  final String? imageUrl;
  final int? popularity;
  final List<Bud> buds;

  Artist({
    required this.id,
    required this.name,
    this.imageUrl,
    this.popularity,
    this.buds = const [], // Initialize with an empty list
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      imageUrl: json['images']?[0]?['url']?.toString(),
      popularity: json['popularity'] as int?,
      buds: (json['buds'] as List?)
          ?.map((b) => Bud.fromJson(b))
          .toList() ?? [],
    );
  }
}
