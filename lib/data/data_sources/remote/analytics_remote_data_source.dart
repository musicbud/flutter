import 'package:dio/dio.dart';
import '../../../core/error/exceptions.dart';

class AnalyticsRemoteDataSource {
  final Dio dio;

  AnalyticsRemoteDataSource({required this.dio});

  Future<Map<String, dynamic>> getUserAnalytics() async {
    try {
      final response = await dio.get('/analytics/user');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'An error occurred');
    }
  }

  Future<Map<String, dynamic>> getContentAnalytics() async {
    try {
      final response = await dio.get('/analytics/content');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'An error occurred');
    }
  }

  Future<Map<String, dynamic>> getSocialAnalytics() async {
    try {
      final response = await dio.get('/analytics/social');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'An error occurred');
    }
  }

  Future<void> trackEvent(String eventName, Map<String, dynamic> properties) async {
    try {
      await dio.post('/analytics/events', data: {
        'event_name': eventName,
        'properties': properties,
      });
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'An error occurred');
    }
  }

  Future<void> trackMetric(String metricName, double value) async {
    try {
      await dio.post('/analytics/metrics', data: {
        'metric_name': metricName,
        'value': value,
      });
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'An error occurred');
    }
  }

  Future<Map<String, dynamic>> getTimeRangeAnalytics(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final response = await dio.get(
        '/analytics/timerange',
        queryParameters: {
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'An error occurred');
    }
  }
}
