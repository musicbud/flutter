class CommonManga {
  final String uid;
  final String name;
  final String synopsis;
  final String imageUrl;
  final int chapters;
  final int volumes;
  final double score;
  final String type;
  final List<String> genres;
  final DateTime? startDate;
  final DateTime? endDate;
  final String source;
  final String author;
  final String rating;
  final bool isLiked;

  CommonManga({
    required this.uid,
    required this.name,
    required this.synopsis,
    required this.imageUrl,
    required this.chapters,
    required this.volumes,
    required this.score,
    required this.type,
    required this.genres,
    this.startDate,
    this.endDate,
    required this.source,
    required this.author,
    required this.rating,
    this.isLiked = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'synopsis': synopsis,
      'image_url': imageUrl,
      'chapters': chapters,
      'volumes': volumes,
      'score': score,
      'type': type,
      'genres': genres,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'source': source,
      'author': author,
      'rating': rating,
      'is_liked': isLiked,
    };
  }

  factory CommonManga.fromJson(Map<String, dynamic> json) {
    return CommonManga(
      uid: json['uid'] as String,
      name: json['name'] as String,
      synopsis: json['synopsis'] as String,
      imageUrl: json['image_url'] as String,
      chapters: json['chapters'] as int,
      volumes: json['volumes'] as int,
      score: (json['score'] as num).toDouble(),
      type: json['type'] as String,
      genres:
          (json['genres'] as List<dynamic>).map((e) => e as String).toList(),
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'] as String)
          : null,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      source: json['source'] as String,
      author: json['author'] as String,
      rating: json['rating'] as String,
      isLiked: json['is_liked'] as bool? ?? false,
    );
  }
}
