import 'package:musicbud_flutter/models/common_anime.dart';

class Anime {
  final String uid;
  final String title;
  final String? status;
  final String? imageUrl;

  Anime({
    required this.uid,
    required this.title,
    this.status,
    this.imageUrl,
  });

  CommonAnime toCommonAnime() {
    return CommonAnime(
      uid: this.uid,
      title: this.title,
      status: this.status ?? 'Unknown',
      imageUrl: this.imageUrl ?? '',
    );
  }
}
