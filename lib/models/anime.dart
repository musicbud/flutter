import 'package:musicbud_flutter/domain/models/common_anime.dart';

class Anime {
  final String id;
  final String uid;
  final String title;
  final String? description;
  final String? imageUrl;
  final String? malId;
  final bool isLiked;
  final int? episodes;
  final double? score;
  final String? status;
  final String? type;
  final int? year;
  final List<String>? genres;

  Anime({
    required this.id,
    this.uid = '',
    required this.title,
    this.description,
    this.imageUrl,
    this.malId,
    this.isLiked = false,
    this.episodes,
    this.score,
    this.status,
    this.type,
    this.year,
    this.genres,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['id'] as String? ?? json['uid'] as String,
      uid: json['uid'] as String? ?? '',
      title: json['title'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      malId: json['mal_id'] as String?,
      isLiked: json['is_liked'] as bool? ?? false,
      episodes: json['episodes'] as int?,
      score: (json['score'] as num?)?.toDouble(),
      status: json['status'] as String?,
      type: json['type'] as String?,
      year: json['year'] as int?,
      genres:
          (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'mal_id': malId,
      'is_liked': isLiked,
      'episodes': episodes,
      'score': score,
      'status': status,
      'type': type,
      'year': year,
      'genres': genres,
    };
  }

  CommonAnime toCommonAnime() {
    return CommonAnime(
      id: id,
      uid: uid,
      title: title,
      description: description,
      imageUrl: imageUrl,
      malId: malId,
      isLiked: isLiked,
      episodes: episodes,
      score: score,
      status: status,
      type: type,
      year: year,
      genres: genres,
    );
  }
}
