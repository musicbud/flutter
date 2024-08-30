enum ContentService {
  music,
  anime,
}

extension ContentServiceExtension on ContentService {
  String get name {
    switch (this) {
      case ContentService.music:
        return 'Music';
      case ContentService.anime:
        return 'Anime';
    }
  }
}
