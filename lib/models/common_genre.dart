class CommonGenre {
  final String? name;

  CommonGenre({this.name});

  factory CommonGenre.fromJson(Map<String, dynamic> json) {
    return CommonGenre(
      name: json['name'] as String?,
    );
  }
}
