class CommonGenre {
  final String uid;
  final String name;
  final String elementIdProperty;
  final double? similarityScore;  // Add this line

  CommonGenre({
    required this.uid,
    required this.name,
    required this.elementIdProperty,
    this.similarityScore,  // Add this line
  });

  factory CommonGenre.fromJson(Map<String, dynamic> json) {
    return CommonGenre(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      elementIdProperty: json['element_id_property'] ?? '',
      similarityScore: json['similarity_score'] != null
          ? double.tryParse(json['similarity_score'].toString())
          : null,  // Add this line
    );
  }
}
