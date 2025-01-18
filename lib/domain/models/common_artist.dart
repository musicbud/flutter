class CommonArtist {
  final String uid;
  final String name;
  final String spotifyId;
  final String ytmusicId;
  final String lastfmId;
  final List<String> imageUrls;
  final int popularity;
  final int followers;
  final bool isLiked;

  CommonArtist({
    required this.uid,
    required this.name,
    required this.spotifyId,
    required this.ytmusicId,
    required this.lastfmId,
    required this.imageUrls,
    required this.popularity,
    required this.followers,
    this.isLiked = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'spotify_id': spotifyId,
      'ytmusic_id': ytmusicId,
      'lastfm_id': lastfmId,
      'image_urls': imageUrls,
      'popularity': popularity,
      'followers': followers,
      'is_liked': isLiked,
    };
  }

  factory CommonArtist.fromJson(Map<String, dynamic> json) {
    return CommonArtist(
      uid: json['uid'] as String,
      name: json['name'] as String,
      spotifyId: json['spotify_id'] as String? ?? '',
      ytmusicId: json['ytmusic_id'] as String? ?? '',
      lastfmId: json['lastfm_id'] as String? ?? '',
      imageUrls: (json['image_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      popularity: json['popularity'] as int? ?? 0,
      followers: json['followers'] as int? ?? 0,
      isLiked: json['is_liked'] as bool? ?? false,
    );
  }
}
