import 'package:musicbud_flutter/models/common_manga.dart';

class Manga {
  final String uid;
  final String title;
  final String? status;
  final String? imageUrl;

  Manga({
    required this.uid,
    required this.title,
    this.status,
    this.imageUrl,
  });

  CommonManga toCommonManga() {
    return CommonManga(
      uid: this.uid,
      title: this.title,
      status: this.status ?? 'Unknown',
      imageUrl: this.imageUrl ?? '',
    );
  }
}
