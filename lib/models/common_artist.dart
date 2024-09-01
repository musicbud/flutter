class CommonArtist {
  final String? name;
  final String? imageUrl;
  final double? similarityScore;

  CommonArtist({
    this.name,
    this.imageUrl,
    this.similarityScore,
  });

  factory CommonArtist.fromJson(Map<String, dynamic> json) {
    return CommonArtist(
      name: json['name'] as String?,
      imageUrl: json['image_url'] as String?,
      similarityScore: json['similarity_score'] as double?,
    );
  }
}
