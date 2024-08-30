class Genre {
  final String name;

  Genre({required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(name: json['name']);
  }
}
