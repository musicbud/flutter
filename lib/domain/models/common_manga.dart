class CommonManga {
  final String id;
  final String uid;
  final String title;
  final String? source;
  final String? malId;
  final int? popularity;
  final bool isLiked;
  final List<String>? genres;
  final List<String>? imageUrls;
  final String? imageUrl;
  final int? chapters;
  final int? volumes;
  final String? status;
  final String? synopsis;
  final String? description;
  final double? score;
  final String? type;
  final int? year;

  CommonManga({
    required this.id,
    this.uid = '',
    required this.title,
    this.source,
    this.malId,
    this.popularity,
    this.isLiked = false,
    this.genres,
    this.imageUrls,
    this.imageUrl,
    this.chapters,
    this.volumes,
    this.status,
    this.synopsis,
    this.description,
    this.score,
    this.type,
    this.year,
  });

  factory CommonManga.fromJson(Map<String, dynamic> json) {
    return CommonManga(
      id: json['id'] as String,
      uid: json['uid'] as String? ?? '',
      title: json['title'] as String,
      source: json['source'] as String?,
      malId: json['mal_id'] as String?,
      popularity: json['popularity'] as int?,
      isLiked: json['is_liked'] as bool? ?? false,
      genres:
          (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
      imageUrls: (json['image_urls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      imageUrl: json['image_url'] as String?,
      chapters: json['chapters'] as int?,
      volumes: json['volumes'] as int?,
      status: json['status'] as String?,
      synopsis: json['synopsis'] as String?,
      description: json['description'] as String?,
      score: json['score'] != null ? (json['score'] as num).toDouble() : null,
      type: json['type'] as String?,
      year: json['year'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'title': title,
      'source': source,
      'mal_id': malId,
      'popularity': popularity,
      'is_liked': isLiked,
      'genres': genres,
      'image_urls': imageUrls,
      'image_url': imageUrl,
      'chapters': chapters,
      'volumes': volumes,
      'status': status,
      'synopsis': synopsis,
      'description': description,
      'score': score,
      'type': type,
      'year': year,
    };
  }

  CommonManga copyWith({
    String? id,
    String? uid,
    String? title,
    String? source,
    String? malId,
    int? popularity,
    bool? isLiked,
    List<String>? genres,
    List<String>? imageUrls,
    String? imageUrl,
    int? chapters,
    int? volumes,
    String? status,
    String? synopsis,
    String? description,
    double? score,
    String? type,
    int? year,
  }) {
    return CommonManga(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      source: source ?? this.source,
      malId: malId ?? this.malId,
      popularity: popularity ?? this.popularity,
      isLiked: isLiked ?? this.isLiked,
      genres: genres ?? this.genres,
      imageUrls: imageUrls ?? this.imageUrls,
      imageUrl: imageUrl ?? this.imageUrl,
      chapters: chapters ?? this.chapters,
      volumes: volumes ?? this.volumes,
      status: status ?? this.status,
      synopsis: synopsis ?? this.synopsis,
      description: description ?? this.description,
      score: score ?? this.score,
      type: type ?? this.type,
      year: year ?? this.year,
    );
  }
}
