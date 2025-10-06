import 'package:equatable/equatable.dart';

/// A model class representing another user (bud) in the system
class Bud extends Equatable {
  final String id;
  final String username;
  final String? avatarUrl;
  final double matchScore;
  final List<String> commonInterests;
  final DateTime matchedAt;
  final bool isOnline;
  final String status; // 'pending', 'accepted', 'rejected'

  const Bud({
    required this.id,
    required this.username,
    this.avatarUrl,
    required this.matchScore,
    required this.commonInterests,
    required this.matchedAt,
    this.isOnline = false,
    this.status = 'pending',
  });

  /// Creates a [Bud] from a JSON map
  factory Bud.fromJson(Map<String, dynamic> json) {
    return Bud(
      id: json['id'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatar_url'] as String?,
      matchScore: (json['match_score'] as num).toDouble(),
      commonInterests: (json['common_interests'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      matchedAt: DateTime.parse(json['matched_at'] as String),
      isOnline: json['is_online'] as bool? ?? false,
      status: json['status'] as String? ?? 'pending',
    );
  }

  /// Converts this [Bud] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'avatar_url': avatarUrl,
      'match_score': matchScore,
      'common_interests': commonInterests,
      'matched_at': matchedAt.toIso8601String(),
      'is_online': isOnline,
      'status': status,
    };
  }

  /// Creates a copy of this [Bud] with the given fields replaced with new values
  Bud copyWith({
    String? id,
    String? username,
    String? avatarUrl,
    double? matchScore,
    List<String>? commonInterests,
    DateTime? matchedAt,
    bool? isOnline,
    String? status,
  }) {
    return Bud(
      id: id ?? this.id,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      matchScore: matchScore ?? this.matchScore,
      commonInterests: commonInterests ?? this.commonInterests,
      matchedAt: matchedAt ?? this.matchedAt,
      isOnline: isOnline ?? this.isOnline,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        id,
        username,
        avatarUrl,
        matchScore,
        commonInterests,
        matchedAt,
        isOnline,
        status,
      ];
}
