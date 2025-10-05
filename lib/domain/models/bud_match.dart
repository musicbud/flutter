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
    // Handle backend response structure - backend returns 'bud' with user data and 'similarity_score'
    final budData = json['bud'] as Map<String, dynamic>? ?? json;
    final similarityScore = json['similarity_score'] as num? ?? 0;

    final id = budData['uid'] as String? ?? budData['id'] as String? ?? '';
    final userId = budData['uid'] as String? ?? budData['id'] as String? ?? '';
    final username = budData['username'] as String? ?? '';

    // Handle avatar URL - backend returns images array, take first one
    String? avatarUrl = budData['avatar_url'] as String?;
    if (avatarUrl == null && budData['images'] is List && (budData['images'] as List).isNotEmpty) {
      final images = budData['images'] as List;
      if (images.isNotEmpty && images[0] is Map<String, dynamic>) {
        avatarUrl = images[0]['url'] as String?;
      }
    }

    return BudMatch(
      id: id,
      userId: userId,
      username: username,
      avatarUrl: avatarUrl,
      matchScore: similarityScore.toDouble(),
      commonArtists: 0, // Backend doesn't provide individual counts
      commonTracks: 0,
      commonGenres: 0,
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
