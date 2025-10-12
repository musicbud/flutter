import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../utils/enhanced_api_logger.dart';

/// Enhanced Dio interceptor that provides detailed logging and performance tracking
class EnhancedLoggingInterceptor extends Interceptor {
  final bool logRequests;
  final bool logResponses;
  final bool logErrors;
  final bool logPerformance;
  final int maxBodyLength;
  
  // Track request start times for performance measurement
  final Map<RequestOptions, DateTime> _requestStartTimes = {};

  EnhancedLoggingInterceptor({
    this.logRequests = true,
    this.logResponses = true,
    this.logErrors = true,
    this.logPerformance = true,
    this.maxBodyLength = 2000,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!kDebugMode) {
      handler.next(options);
      return;
    }

    // Record start time for performance tracking
    final startTime = DateTime.now();
    _requestStartTimes[options] = startTime;

    if (logRequests) {
      EnhancedApiLogger.logRequest(
        options.method.toUpperCase(),
        options.uri.toString(),
        data: options.data,
        headers: Map<String, dynamic>.from(options.headers),
        queryParameters: options.queryParameters.isNotEmpty 
          ? Map<String, dynamic>.from(options.queryParameters)
          : null,
        startTime: startTime,
      );
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (!kDebugMode) {
      handler.next(response);
      return;
    }

    final startTime = _requestStartTimes.remove(response.requestOptions);
    final responseTime = startTime != null 
      ? DateTime.now().difference(startTime).inMilliseconds 
      : null;

    if (logResponses) {
      EnhancedApiLogger.logResponse(
        response.statusCode ?? 200,
        response.requestOptions.uri.toString(),
        data: _truncateData(response.data),
        headers: response.headers.map.map((key, value) => MapEntry(key, value.first)),
        startTime: startTime,
        responseTime: responseTime,
      );
    }

    if (logPerformance && responseTime != null) {
      final requestSize = _calculateRequestSize(response.requestOptions);
      final responseSize = _calculateResponseSize(response.data);
      
      EnhancedApiLogger.logApiSummary(
        response.requestOptions.method.toUpperCase(),
        response.requestOptions.uri.toString(),
        response.statusCode ?? 200,
        responseTime,
        requestSize: requestSize,
        responseSize: responseSize,
      );
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!kDebugMode) {
      handler.next(err);
      return;
    }

    final startTime = _requestStartTimes.remove(err.requestOptions);

    if (logErrors) {
      EnhancedApiLogger.logError(
        err.response?.statusCode,
        err.requestOptions.uri.toString(),
        message: err.message,
        data: _truncateData(err.response?.data),
        startTime: startTime,
        errorType: err.type.toString(),
        stackTrace: err.stackTrace,
      );
    }

    if (logPerformance && startTime != null) {
      final responseTime = DateTime.now().difference(startTime).inMilliseconds;
      final requestSize = _calculateRequestSize(err.requestOptions);
      
      EnhancedApiLogger.logApiSummary(
        err.requestOptions.method.toUpperCase(),
        err.requestOptions.uri.toString(),
        err.response?.statusCode ?? 0,
        responseTime,
        requestSize: requestSize,
      );
    }

    handler.next(err);
  }

  /// Truncate data to prevent extremely long log messages
  dynamic _truncateData(dynamic data) {
    if (data == null) return null;
    
    final dataString = data.toString();
    if (dataString.length <= maxBodyLength) {
      return data;
    }
    
    // For string data, truncate directly
    if (data is String) {
      return '${data.substring(0, maxBodyLength)}... (truncated from ${data.length} chars)';
    }
    
    // For other data types, return original (let the logger handle truncation)
    return data;
  }

  /// Calculate approximate request size in bytes
  int? _calculateRequestSize(RequestOptions options) {
    try {
      int size = 0;
      
      // Add URL size
      size += options.uri.toString().length;
      
      // Add headers size
      options.headers.forEach((key, value) {
        size += key.length + value.toString().length;
      });
      
      // Add query parameters size
      options.queryParameters.forEach((key, value) {
        size += key.length + value.toString().length;
      });
      
      // Add body size (approximate)
      if (options.data != null) {
        final bodyString = options.data.toString();
        size += bodyString.length;
      }
      
      return size;
    } catch (e) {
      return null;
    }
  }

  /// Calculate approximate response size in bytes
  int? _calculateResponseSize(dynamic data) {
    try {
      if (data == null) return 0;
      return data.toString().length;
    } catch (e) {
      return null;
    }
  }

  /// Clean up any remaining request start times (prevent memory leaks)
  void cleanup() {
    _requestStartTimes.clear();
  }
}