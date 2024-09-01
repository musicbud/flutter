import 'dart:convert';
import 'bud.dart';

class BudMatch {
  final Bud bud;
  final double similarityScore;

  BudMatch({
    required this.bud,
    required this.similarityScore,
  });

  factory BudMatch.fromJson(Map<String, dynamic> json) {
    return BudMatch(
      bud: Bud.fromJson(json['bud'] as Map<String, dynamic>),
      similarityScore: (json['similarity_score'] as num).toDouble(),
    );
  }
}

class Bud {
  final String uid;
  final String username;
  final String? email;
  final String? photoUrl;
  final String? bio;
  final String? displayName;
  final bool isActive;
  final bool? isAuthenticated;
  final String? accessToken;
  final String? refreshToken;
  final String? accessTokenExpiresAt;
  final String? refreshTokenExpiresAt;

  Bud({
    required this.uid,
    required this.username,
    this.email,
    this.photoUrl,
    this.bio,
    this.displayName,
    required this.isActive,
    this.isAuthenticated,
    this.accessToken,
    this.refreshToken,
    this.accessTokenExpiresAt,
    this.refreshTokenExpiresAt,
  });

  factory Bud.fromJson(Map<String, dynamic> json) {
    return Bud(
      uid: json['uid'] as String,
      username: json['username'] as String,
      email: json['email'] as String?,
      photoUrl: json['photo_url'] as String?,
      bio: json['bio'] as String?,
      displayName: json['display_name'] as String?,
      isActive: json['is_active'] as bool? ?? false,
      isAuthenticated: json['is_authenticated'] as bool?,
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
      accessTokenExpiresAt: json['access_token_expires_at']?.toString(),
      refreshTokenExpiresAt: json['refresh_token_expires_at']?.toString(),
    );
  }
}
