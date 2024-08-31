import 'bud.dart';

class BudMatch {
  final Bud bud;
  final double similarityScore;

  BudMatch({required this.bud, required this.similarityScore});

  factory BudMatch.fromJson(Map<String, dynamic> json) {
    return BudMatch(
      bud: Bud.fromJson(json['bud']),
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
  final bool isAuthenticated;
  final double similarityScore;

  Bud({
    required this.uid,
    required this.username,
    this.email,
    this.photoUrl,
    this.bio,
    this.displayName,
    required this.isActive,
    required this.isAuthenticated,
    required this.similarityScore,
  });

  factory Bud.fromJson(Map<String, dynamic> json) {
    final budData = json['bud'] as Map<String, dynamic>;
    return Bud(
      uid: budData['uid'] as String,
      username: budData['username'] as String,
      email: budData['email'] as String?,
      photoUrl: budData['photo_url'] as String?,
      bio: budData['bio'] as String?,
      displayName: budData['display_name'] as String?,
      isActive: budData['is_active'] as bool,
      isAuthenticated: budData['is_authenticated'] as bool,
      similarityScore: (json['similarity_score'] as num).toDouble(),
    );
  }

  // Helper method to parse expiration times if needed
  double? parseExpirationTime(String? timeString) {
    if (timeString == null) return null;
    return double.tryParse(timeString);
  }
}
