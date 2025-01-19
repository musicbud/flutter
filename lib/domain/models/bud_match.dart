import 'package:equatable/equatable.dart';
import 'bud.dart';

/// A model class representing a match with another user (bud) based on common interests
class BudMatch extends Equatable {
  final String id;
  final String userId;
  final String username;
  final String? avatarUrl;
  final double matchScore;
  final double similarityScore;
  final List<String> commonInterests;
  final DateTime matchedAt;

  const BudMatch({
    required this.id,
    required this.userId,
    required this.username,
    this.avatarUrl,
    required this.matchScore,
    required this.similarityScore,
    required this.commonInterests,
    required this.matchedAt,
  });

  /// Creates a [BudMatch] from a [Bud] instance
  factory BudMatch.fromBud(Bud bud) {
    return BudMatch(
      id: bud.id,
      userId: bud.id,
      username: bud.username,
      avatarUrl: bud.avatarUrl,
      matchScore: bud.matchScore,
      similarityScore: bud.matchScore,
      commonInterests: bud.commonInterests,
      matchedAt: bud.matchedAt,
    );
  }

  /// Creates a [BudMatch] from a JSON map
  factory BudMatch.fromJson(Map<String, dynamic> json) {
    return BudMatch(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatar_url'] as String?,
      matchScore: (json['match_score'] as num).toDouble(),
      similarityScore: (json['similarity_score'] as num).toDouble(),
      commonInterests: (json['common_interests'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      matchedAt: DateTime.parse(json['matched_at'] as String),
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
      'similarity_score': similarityScore,
      'common_interests': commonInterests,
      'matched_at': matchedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        username,
        avatarUrl,
        matchScore,
        similarityScore,
        commonInterests,
        matchedAt
      ];
}
