class CommonGenre {
  final String id;
  final String name;
  final bool isLiked;
  final String source;

  CommonGenre({
    required this.id,
    required this.name,
    this.isLiked = false,
    required this.source,
  });

  factory CommonGenre.fromJson(Map<String, dynamic> json) {
    return CommonGenre(
      id: json['id'] as String,
      name: json['name'] as String,
      isLiked: json['is_liked'] as bool? ?? false,
      source: json['source'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_liked': isLiked,
      'source': source,
    };
  }
}
