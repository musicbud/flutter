import 'package:equatable/equatable.dart';

/// A model class representing a match with another user (bud) based on common interests
class BudMatch extends Equatable {
  final String id;
  final String userId;
  final String username;
  final String? avatarUrl;
  final double matchScore;
  final int commonArtists;
  final int commonTracks;
  final int commonGenres;

  const BudMatch({
    required this.id,
    required this.userId,
    required this.username,
    this.avatarUrl,
    required this.matchScore,
    required this.commonArtists,
    required this.commonTracks,
    required this.commonGenres,
  });

  /// Creates a [BudMatch] from a JSON map
  factory BudMatch.fromJson(Map<String, dynamic> json) {
    return BudMatch(
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

  /// Converts this [BudMatch] to a JSON map
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

  @override
  List<Object?> get props => [
        id,
        userId,
        username,
        avatarUrl,
        matchScore,
        commonArtists,
        commonTracks,
        commonGenres,
      ];
}
