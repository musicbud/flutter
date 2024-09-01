class CommonGenre {
  final String uid;
  final String name;
  final double similarityScore;

  CommonGenre({
    required this.uid,
    required this.name,
    required this.similarityScore,
  });

  factory CommonGenre.fromJson(Map<String, dynamic> json) {
    return CommonGenre(
      uid: json['uid'],
      name: json['name'],
      similarityScore: json['similarity_score']?.toDouble() ?? 0.0,
    );
  }
}
