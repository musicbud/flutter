import 'package:musicbud_flutter/domain/models/common_manga.dart';

class Manga {
  final String id;
  final String uid;
  final String title;
  final String? description;
  final String? imageUrl;
  final String? malId;
  final bool isLiked;
  final int? chapters;
  final int? volumes;
  final double? score;
  final String? status;
  final String? type;
  final int? year;
  final List<String>? genres;

  Manga({
    required this.id,
    this.uid = '',
    required this.title,
    this.description,
    this.imageUrl,
    this.malId,
    this.isLiked = false,
    this.chapters,
    this.volumes,
    this.score,
    this.status,
    this.type,
    this.year,
    this.genres,
  });

  factory Manga.fromJson(Map<String, dynamic> json) {
    return Manga(
      id: json['id'] as String? ?? json['uid'] as String,
      uid: json['uid'] as String? ?? '',
      title: json['title'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      malId: json['mal_id'] as String?,
      isLiked: json['is_liked'] as bool? ?? false,
      chapters: json['chapters'] as int?,
      volumes: json['volumes'] as int?,
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
      'chapters': chapters,
      'volumes': volumes,
      'score': score,
      'status': status,
      'type': type,
      'year': year,
      'genres': genres,
    };
  }

  CommonManga toCommonManga() {
    return CommonManga(
      id: id,
      uid: uid,
      title: title,
      description: description,
      imageUrl: imageUrl,
      malId: malId,
      isLiked: isLiked,
      chapters: chapters,
      volumes: volumes,
      score: score,
      status: status,
      type: type,
      year: year,
      genres: genres,
    );
  }
}
