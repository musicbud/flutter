import 'package:equatable/equatable.dart';

class Bud extends Equatable {
  final String id;
  final String username;
  final String? email;
  final String? avatarUrl;
  final String? bio;
  final String? displayName;
  final bool isActive;
  final bool? isAuthenticated;
  final String? accessToken;
  final String? refreshToken;
  final String? accessTokenExpiresAt;
  final String? refreshTokenExpiresAt;
  final double matchScore;
  final List<String> commonInterests;
  final DateTime matchedAt;

  Bud({
    required this.id,
    required this.username,
    this.email,
    this.avatarUrl,
    this.bio,
    this.displayName,
    required this.isActive,
    this.isAuthenticated,
    this.accessToken,
    this.refreshToken,
    this.accessTokenExpiresAt,
    this.refreshTokenExpiresAt,
    required this.matchScore,
    this.commonInterests = const [],
    DateTime? matchedAt,
  }) : matchedAt = matchedAt ?? DateTime.now();

  factory Bud.fromJson(Map<String, dynamic> json) {
    return Bud(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String?,
      displayName: json['display_name'] as String?,
      isActive: json['is_active'] as bool? ?? false,
      isAuthenticated: json['is_authenticated'] as bool?,
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
      accessTokenExpiresAt: json['access_token_expires_at'] as String?,
      refreshTokenExpiresAt: json['refresh_token_expires_at'] as String?,
      matchScore: (json['match_score'] as num?)?.toDouble() ?? 0.0,
      commonInterests: (json['common_interests'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      matchedAt: json['matched_at'] != null
          ? DateTime.parse(json['matched_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatar_url': avatarUrl,
      'bio': bio,
      'display_name': displayName,
      'is_active': isActive,
      'is_authenticated': isAuthenticated,
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'access_token_expires_at': accessTokenExpiresAt,
      'refresh_token_expires_at': refreshTokenExpiresAt,
      'match_score': matchScore,
      'common_interests': commonInterests,
      'matched_at': matchedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        username,
        avatarUrl,
        bio,
        displayName,
        isActive,
        isAuthenticated,
        accessToken,
        refreshToken,
        accessTokenExpiresAt,
        refreshTokenExpiresAt,
        matchScore,
        commonInterests,
        matchedAt,
      ];
}
