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

class CommonTrack {
  final String? id;
  final String? name;
  // ... other fields ...

  CommonTrack({
    this.id,
    this.name,
    // ... other fields ...
  });

  factory CommonTrack.fromJson(Map<String, dynamic> json) {
    return CommonTrack(
      id: json['id'] as String?,
      name: json['name'] as String?,
      // ... other fields ...
    );
  }
}

// Similar updates for CommonGenre, CommonArtist, etc.
