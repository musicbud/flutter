import '../domain/models/common_anime.dart';

class Anime {
  final String uid;
  final String name;
  final String synopsis;
  final String imageUrl;
  final int episodes;
  final double score;
  final String type;
  final List<String> genres;
  final DateTime? startDate;
  final DateTime? endDate;
  final String source;
  final String studio;
  final String rating;
  final bool isLiked;

  Anime({
    required this.uid,
    required this.name,
    required this.synopsis,
    required this.imageUrl,
    required this.episodes,
    required this.score,
    required this.type,
    required this.genres,
    this.startDate,
    this.endDate,
    required this.source,
    required this.studio,
    required this.rating,
    this.isLiked = false,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      uid: json['uid'] as String,
      name: json['name'] as String,
      synopsis: json['synopsis'] as String,
      imageUrl: json['image_url'] as String,
      episodes: json['episodes'] as int,
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
      studio: json['studio'] as String,
      rating: json['rating'] as String,
      isLiked: json['is_liked'] as bool? ?? false,
    );
  }

  factory Anime.fromCommon(CommonAnime common) {
    return Anime(
      uid: common.uid,
      name: common.name,
      synopsis: common.synopsis,
      imageUrl: common.imageUrl,
      episodes: common.episodes,
      score: common.score,
      type: common.type,
      genres: common.genres,
      startDate: common.startDate,
      endDate: common.endDate,
      source: common.source,
      studio: common.studio,
      rating: common.rating,
      isLiked: common.isLiked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'synopsis': synopsis,
      'image_url': imageUrl,
      'episodes': episodes,
      'score': score,
      'type': type,
      'genres': genres,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'source': source,
      'studio': studio,
      'rating': rating,
      'is_liked': isLiked,
    };
  }
}
