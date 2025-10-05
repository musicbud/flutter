class Analytics {
  final Map<String, int> userEngagement;
  final Map<String, int> contentInteractions;
  final Map<String, int> socialInteractions;
  final Map<String, double> usageMetrics;

  const Analytics({
    required this.userEngagement,
    required this.contentInteractions,
    required this.socialInteractions,
    required this.usageMetrics,
  });

  factory Analytics.fromJson(Map<String, dynamic> json) {
    return Analytics(
      userEngagement: Map<String, int>.from(json['user_engagement'] ?? {}),
      contentInteractions: Map<String, int>.from(json['content_interactions'] ?? {}),
      socialInteractions: Map<String, int>.from(json['social_interactions'] ?? {}),
      usageMetrics: Map<String, double>.from(json['usage_metrics'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'user_engagement': userEngagement,
    'content_interactions': contentInteractions,
    'social_interactions': socialInteractions,
    'usage_metrics': usageMetrics,
  };
}
