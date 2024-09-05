class CommonGenre {
  final String name;

  CommonGenre({required this.name});

  factory CommonGenre.fromJson(Map<String, dynamic> json) {
    return CommonGenre(name: json['name']);
  }
}
