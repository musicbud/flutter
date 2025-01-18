class CommonGenre {
  final String uid;
  final String name;
  final String spotifyId;
  final String ytmusicId;
  final String lastfmId;
  final int popularity;
  final bool isLiked;

  CommonGenre({
    required this.uid,
    required this.name,
    required this.spotifyId,
    required this.ytmusicId,
    required this.lastfmId,
    required this.popularity,
    this.isLiked = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'spotify_id': spotifyId,
      'ytmusic_id': ytmusicId,
      'lastfm_id': lastfmId,
      'popularity': popularity,
      'is_liked': isLiked,
    };
  }

  factory CommonGenre.fromJson(Map<String, dynamic> json) {
    return CommonGenre(
      uid: json['uid'] as String,
      name: json['name'] as String,
      spotifyId: json['spotify_id'] as String? ?? '',
      ytmusicId: json['ytmusic_id'] as String? ?? '',
      lastfmId: json['lastfm_id'] as String? ?? '',
      popularity: json['popularity'] as int? ?? 0,
      isLiked: json['is_liked'] as bool? ?? false,
    );
  }
}
