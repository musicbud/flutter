import '../../domain/repositories/analytics_repository.dart';
import '../data_sources/remote/analytics_remote_data_source.dart';
import '../../core/error/exceptions.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteDataSource _remoteDataSource;

  AnalyticsRepositoryImpl({
    required AnalyticsRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Map<String, dynamic>> getUserAnalytics() async {
    try {
      return await _remoteDataSource.getUserAnalytics();
    } on ServerException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<Map<String, dynamic>> getContentAnalytics() async {
    try {
      return await _remoteDataSource.getContentAnalytics();
    } on ServerException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<Map<String, dynamic>> getSocialAnalytics() async {
    try {
      return await _remoteDataSource.getSocialAnalytics();
    } on ServerException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<void> trackEvent(String eventName, Map<String, dynamic> properties) async {
    try {
      await _remoteDataSource.trackEvent(eventName, properties);
    } on ServerException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<void> trackMetric(String metricName, double value) async {
    try {
      await _remoteDataSource.trackMetric(metricName, value);
    } on ServerException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<Map<String, dynamic>> getTimeRangeAnalytics(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      return await _remoteDataSource.getTimeRangeAnalytics(startDate, endDate);
    } on ServerException catch (e) {
      throw Exception(e.message);
    }
  }
}
