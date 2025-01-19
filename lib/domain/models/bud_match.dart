class BudMatch {
  final String id;
  final String userId;
  final String username;
  final String? avatarUrl;
  final double matchScore;
  final int commonItemsCount;
  final String status; // 'pending', 'accepted', 'rejected'
  final DateTime createdAt;
  final DateTime updatedAt;

  BudMatch({
    required this.id,
    required this.userId,
    required this.username,
    this.avatarUrl,
    required this.matchScore,
    required this.commonItemsCount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BudMatch.fromJson(Map<String, dynamic> json) {
    return BudMatch(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatar_url'] as String?,
      matchScore: (json['match_score'] as num).toDouble(),
      commonItemsCount: json['common_items_count'] as int,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'username': username,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      'match_score': matchScore,
      'common_items_count': commonItemsCount,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  BudMatch copyWith({
    String? id,
    String? userId,
    String? username,
    String? avatarUrl,
    double? matchScore,
    int? commonItemsCount,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BudMatch(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      matchScore: matchScore ?? this.matchScore,
      commonItemsCount: commonItemsCount ?? this.commonItemsCount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
