import '../../domain/models/bud_match.dart';

class BudMatchModel extends BudMatch {
  const BudMatchModel({
    required super.id,
    required super.userId,
    required super.username,
    required super.avatarUrl,
    required super.matchScore,
    required super.commonArtists,
    required super.commonTracks,
    required super.commonGenres,
  });

  factory BudMatchModel.fromJson(Map<String, dynamic> json) {
    return BudMatchModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatar_url'] as String?,
      matchScore: (json['match_score'] as num).toDouble(),
      commonArtists: json['common_artists'] as int,
      commonTracks: json['common_tracks'] as int,
      commonGenres: json['common_genres'] as int,
    );
  }

  /// Converts this [BudMatchModel] to a JSON map
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'username': username,
      'avatar_url': avatarUrl,
      'match_score': matchScore,
      'common_artists': commonArtists,
      'common_tracks': commonTracks,
      'common_genres': commonGenres,
    };
  }
}
