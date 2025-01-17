import 'package:musicbud_flutter/models/common_manga.dart';

class Manga {
  final String uid;
  final int mangaId;
  final String title;
  final String? status;
  final List<Map<String, dynamic>> mainPictures;

  Manga({
    required this.uid,
    required this.mangaId,
    required this.title,
    this.status,
    this.mainPictures = const [],
  });

  factory Manga.fromJson(Map<String, dynamic> json) {
    return Manga(
      uid: json['uid'] as String,
      mangaId: json['manga_id'] as int,
      title: json['title'] as String,
      status: json['status'] as String?,
      mainPictures: (json['main_picture'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'manga_id': mangaId,
      'title': title,
      'status': status,
      'main_picture': mainPictures,
    };
  }

  CommonManga toCommonManga() {
    return CommonManga(
      uid: this.uid,
      title: this.title,
      status: this.status ?? 'Unknown',
      imageUrl:
          mainPictures.isNotEmpty ? mainPictures.first['medium'] ?? '' : '',
    );
  }
}
