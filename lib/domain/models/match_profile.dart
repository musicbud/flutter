class MatchProfile {
  final String id;
  final String userId;
  final String displayName;
  final String? photoUrl;
  final double matchScore;
  final List<String> commonInterests;
  final Map<String, dynamic> preferences;
  final DateTime lastActive;
  final bool isOnline;

  const MatchProfile({
    required this.id,
    required this.userId,
    required this.displayName,
    this.photoUrl,
    required this.matchScore,
    this.commonInterests = const [],
    this.preferences = const {},
    required this.lastActive,
    this.isOnline = false,
  });

  factory MatchProfile.fromJson(Map<String, dynamic> json) {
    return MatchProfile(
      id: json['id'] as String,
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      photoUrl: json['photoUrl'] as String?,
      matchScore: (json['matchScore'] as num).toDouble(),
      commonInterests: (json['commonInterests'] as List<dynamic>?)?.cast<String>() ?? [],
      preferences: json['preferences'] as Map<String, dynamic>? ?? {},
      lastActive: DateTime.parse(json['lastActive'] as String),
      isOnline: json['isOnline'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'matchScore': matchScore,
      'commonInterests': commonInterests,
      'preferences': preferences,
      'lastActive': lastActive.toIso8601String(),
      'isOnline': isOnline,
    };
  }
}
