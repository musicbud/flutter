import 'package:musicbud_flutter/models/common_anime.dart';

class Anime {
  final String uid;
  final int animeId;
  final String title;
  final String? status;
  final int score;
  final int numWatchedEpisodes;
  final bool isRewatching;
  final DateTime? updatedAt;
  final List<Map<String, dynamic>> mainPictures;

  Anime({
    required this.uid,
    required this.animeId,
    required this.title,
    this.status,
    this.score = 0,
    this.numWatchedEpisodes = 0,
    this.isRewatching = false,
    this.updatedAt,
    this.mainPictures = const [],
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      uid: json['uid'] as String,
      animeId: json['anime_id'] as int,
      title: json['title'] as String,
      status: json['status'] as String?,
      score: json['score'] as int? ?? 0,
      numWatchedEpisodes: json['num_watched_episodes'] as int? ?? 0,
      isRewatching: json['is_rewatching'] as bool? ?? false,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      mainPictures: (json['main_picture'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'anime_id': animeId,
      'title': title,
      'status': status,
      'score': score,
      'num_watched_episodes': numWatchedEpisodes,
      'is_rewatching': isRewatching,
      'updated_at': updatedAt?.toIso8601String(),
      'main_picture': mainPictures,
    };
  }

  CommonAnime toCommonAnime() {
    return CommonAnime(
      uid: this.uid,
      title: this.title,
      status: this.status ?? 'Unknown',
      imageUrl:
          mainPictures.isNotEmpty ? mainPictures.first['medium'] ?? '' : '',
    );
  }
}
