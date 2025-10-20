class MusicCategory {
  final String id;
  final String name;
  final String icon;
  final int count;

  const MusicCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.count,
  });

  factory MusicCategory.fromJson(Map<String, dynamic> json) {
    return MusicCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      count: json['count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'count': count,
    };
  }
}
