class DemoUserProfile {
  final String id;
  final String displayName;
  final String? photoUrl;
  final String role;
  final Map<String, int> stats;
  final Map<String, dynamic> preferences;
  final List<String> interests;
  final DateTime joinedAt;
  final DateTime lastActive;
  final bool isPremium;
  final List<String> badges;

  const DemoUserProfile({
    required this.id,
    required this.displayName,
    this.photoUrl,
    required this.role,
    this.stats = const {},
    this.preferences = const {},
    this.interests = const [],
    required this.joinedAt,
    required this.lastActive,
    this.isPremium = false,
    this.badges = const [],
  });

  factory DemoUserProfile.fromJson(Map<String, dynamic> json) {
    return DemoUserProfile(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      photoUrl: json['photoUrl'] as String?,
      role: json['role'] as String,
      stats: (json['stats'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as int),
          ) ?? const {},
      preferences: json['preferences'] as Map<String, dynamic>? ?? const {},
      interests: (json['interests'] as List<dynamic>?)?.cast<String>() ?? [],
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      lastActive: DateTime.parse(json['lastActive'] as String),
      isPremium: json['isPremium'] as bool? ?? false,
      badges: (json['badges'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'role': role,
      'stats': stats,
      'preferences': preferences,
      'interests': interests,
      'joinedAt': joinedAt.toIso8601String(),
      'lastActive': lastActive.toIso8601String(),
      'isPremium': isPremium,
      'badges': badges,
    };
  }

  DemoUserProfile copyWith({
    String? id,
    String? displayName,
    String? photoUrl,
    String? role,
    Map<String, int>? stats,
    Map<String, dynamic>? preferences,
    List<String>? interests,
    DateTime? joinedAt,
    DateTime? lastActive,
    bool? isPremium,
    List<String>? badges,
  }) {
    return DemoUserProfile(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      stats: stats ?? this.stats,
      preferences: preferences ?? this.preferences,
      interests: interests ?? this.interests,
      joinedAt: joinedAt ?? this.joinedAt,
      lastActive: lastActive ?? this.lastActive,
      isPremium: isPremium ?? this.isPremium,
      badges: badges ?? this.badges,
    );
  }
}
