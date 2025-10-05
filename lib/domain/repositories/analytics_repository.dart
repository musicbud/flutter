abstract class AnalyticsRepository {
  /// Get analytics data for the current user
  Future<Map<String, dynamic>> getUserAnalytics();

  /// Get content interaction analytics
  Future<Map<String, dynamic>> getContentAnalytics();

  /// Get social interaction analytics
  Future<Map<String, dynamic>> getSocialAnalytics();

  /// Track a specific user event
  Future<void> trackEvent(String eventName, Map<String, dynamic> properties);

  /// Track a specific metric
  Future<void> trackMetric(String metricName, double value);

  /// Get analytics for a specific time range
  Future<Map<String, dynamic>> getTimeRangeAnalytics(
    DateTime startDate,
    DateTime endDate,
  );
}
