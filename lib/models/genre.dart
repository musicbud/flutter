import 'bud.dart';

class Genre {
  final String name;
  final List<Bud> buds;

  Genre({
    required this.name,
    this.buds = const [],
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      name: json['name']?.toString() ?? '',
      buds: (json['buds'] as List?)
          ?.map((b) => Bud.fromJson(b))
          .toList() ?? [],
    );
  }
}
