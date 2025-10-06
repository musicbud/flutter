class AdminStats {
  final Map<String, int> userStats;
  final Map<String, int> contentStats;
  final Map<String, int> engagementStats;
  final Map<String, int> systemStats;

  const AdminStats({
    required this.userStats,
    required this.contentStats,
    required this.engagementStats,
    required this.systemStats,
  });

  factory AdminStats.fromJson(Map<String, dynamic> json) {
    return AdminStats(
      userStats: Map<String, int>.from(json['user_stats'] ?? {}),
      contentStats: Map<String, int>.from(json['content_stats'] ?? {}),
      engagementStats: Map<String, int>.from(json['engagement_stats'] ?? {}),
      systemStats: Map<String, int>.from(json['system_stats'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'user_stats': userStats,
    'content_stats': contentStats,
    'engagement_stats': engagementStats,
    'system_stats': systemStats,
  };
}

class AdminAction {
  final String actionType;
  final String targetId;
  final String performedBy;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;

  const AdminAction({
    required this.actionType,
    required this.targetId,
    required this.performedBy,
    required this.timestamp,
    this.metadata = const {},
  });

  factory AdminAction.fromJson(Map<String, dynamic> json) {
    return AdminAction(
      actionType: json['action_type'],
      targetId: json['target_id'],
      performedBy: json['performed_by'],
      timestamp: DateTime.parse(json['timestamp']),
      metadata: json['metadata'] ?? {},
    );
  }

  Map<String, dynamic> toJson() => {
    'action_type': actionType,
    'target_id': targetId,
    'performed_by': performedBy,
    'timestamp': timestamp.toIso8601String(),
    'metadata': metadata,
  };
}
