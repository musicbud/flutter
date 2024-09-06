class CommonGenre {
  final String name;
  final int? elementIdProperty;

  CommonGenre({required this.name, this.elementIdProperty});

  factory CommonGenre.fromJson(Map<String, dynamic> json) {
    return CommonGenre(
      name: json['name'],
      elementIdProperty: json['element_id_property'] != null
          ? int.tryParse(json['element_id_property'].toString())
          : null,
    );
  }
}
