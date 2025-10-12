import 'dart:convert';
import 'package:flutter/foundation.dart';

/// Enhanced API logger that provides detailed request/response information
class EnhancedApiLogger {
  static const String _separator = '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
  
  /// Log detailed request information
  static void logRequest(
    String method,
    String url, {
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    DateTime? startTime,
  }) {
    if (!kDebugMode) return;

    final timestamp = _formatTimestamp(DateTime.now());
    
    debugPrint('');
    debugPrint(_separator);
    debugPrint('🚀 API REQUEST - $timestamp');
    debugPrint(_separator);
    debugPrint('📍 Method: $method');
    debugPrint('🌐 URL: $url');
    
    // Log query parameters
    if (queryParameters?.isNotEmpty == true) {
      debugPrint('🔍 Query Parameters:');
      queryParameters!.forEach((key, value) {
        debugPrint('   • $key: $value');
      });
    }
    
    // Log headers with sensitive data masking
    if (headers?.isNotEmpty == true) {
      debugPrint('📋 Headers:');
      headers!.forEach((key, value) {
        final maskedValue = _maskSensitiveHeader(key, value?.toString() ?? '');
        debugPrint('   • $key: $maskedValue');
      });
    }
    
    // Log request body
    if (data != null) {
      debugPrint('📤 Request Body:');
      final bodyString = _formatRequestBody(data);
      if (bodyString.length > 1000) {
        debugPrint('   ${bodyString.substring(0, 1000)}... (truncated)');
        debugPrint('   📏 Total body size: ${bodyString.length} characters');
      } else {
        debugPrint('   $bodyString');
      }
    }
    
    debugPrint(_separator);
  }

  /// Log detailed response information
  static void logResponse(
    int statusCode,
    String url, {
    dynamic data,
    Map<String, dynamic>? headers,
    DateTime? startTime,
    int? responseTime,
  }) {
    if (!kDebugMode) return;

    final timestamp = _formatTimestamp(DateTime.now());
    final statusEmoji = _getStatusEmoji(statusCode);
    final statusColor = _getStatusDescription(statusCode);
    
    debugPrint('');
    debugPrint(_separator);
    debugPrint('$statusEmoji API RESPONSE - $timestamp');
    debugPrint(_separator);
    debugPrint('🌐 URL: $url');
    debugPrint('📊 Status: $statusCode $statusColor');
    
    // Log response time if available
    if (responseTime != null) {
      final timeFormatted = _formatResponseTime(responseTime);
      debugPrint('⏱️ Response Time: $timeFormatted');
    } else if (startTime != null) {
      final elapsed = DateTime.now().difference(startTime).inMilliseconds;
      final timeFormatted = _formatResponseTime(elapsed);
      debugPrint('⏱️ Response Time: $timeFormatted');
    }
    
    // Log response headers (if any important ones)
    if (headers?.isNotEmpty == true) {
      final importantHeaders = _extractImportantHeaders(headers!);
      if (importantHeaders.isNotEmpty) {
        debugPrint('📋 Response Headers:');
        importantHeaders.forEach((key, value) {
          debugPrint('   • $key: $value');
        });
      }
    }
    
    // Log response body with formatting
    if (data != null) {
      debugPrint('📥 Response Body:');
      final bodyString = _formatResponseBody(data);
      if (bodyString.length > 2000) {
        debugPrint('   ${bodyString.substring(0, 2000)}... (truncated)');
        debugPrint('   📏 Total response size: ${bodyString.length} characters');
        debugPrint('   🔍 Response summary: ${_extractResponseSummary(data)}');
      } else {
        debugPrint('   $bodyString');
      }
    }
    
    debugPrint(_separator);
  }

  /// Log detailed error information
  static void logError(
    int? statusCode,
    String url, {
    String? message,
    dynamic data,
    DateTime? startTime,
    String? errorType,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return;

    final timestamp = _formatTimestamp(DateTime.now());
    
    debugPrint('');
    debugPrint(_separator);
    debugPrint('💥 API ERROR - $timestamp');
    debugPrint(_separator);
    debugPrint('🌐 URL: $url');
    debugPrint('📊 Status Code: ${statusCode ?? 'N/A'}');
    
    if (errorType != null) {
      debugPrint('🏷️ Error Type: $errorType');
    }
    
    if (message != null) {
      debugPrint('💬 Error Message: $message');
    }
    
    // Log response time for failed requests
    if (startTime != null) {
      final elapsed = DateTime.now().difference(startTime).inMilliseconds;
      final timeFormatted = _formatResponseTime(elapsed);
      debugPrint('⏱️ Failed After: $timeFormatted');
    }
    
    // Log error response data
    if (data != null) {
      debugPrint('📥 Error Response:');
      final errorString = _formatErrorResponse(data);
      debugPrint('   $errorString');
    }
    
    // Log stack trace if available (truncated)
    if (stackTrace != null) {
      final stackLines = stackTrace.toString().split('\n').take(5).join('\n');
      debugPrint('📚 Stack Trace (top 5 lines):');
      debugPrint('   $stackLines');
    }
    
    debugPrint(_separator);
  }

  /// Log API call summary for analytics
  static void logApiSummary(
    String method,
    String url,
    int statusCode,
    int responseTime, {
    int? requestSize,
    int? responseSize,
  }) {
    if (!kDebugMode) return;

    final statusEmoji = _getStatusEmoji(statusCode);
    final timeFormatted = _formatResponseTime(responseTime);
    
    debugPrint('📊 API SUMMARY: $statusEmoji $method $url - '
        '$statusCode in $timeFormatted'
        '${requestSize != null ? ' (req: ${_formatBytes(requestSize)})' : ''}'
        '${responseSize != null ? ' (res: ${_formatBytes(responseSize)})' : ''}');
  }

  // Helper methods
  static String _formatTimestamp(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:'
           '${dateTime.minute.toString().padLeft(2, '0')}:'
           '${dateTime.second.toString().padLeft(2, '0')}'
           '.${dateTime.millisecond.toString().padLeft(3, '0')}';
  }

  static String _getStatusEmoji(int statusCode) {
    if (statusCode >= 200 && statusCode < 300) return '✅';
    if (statusCode >= 300 && statusCode < 400) return '🔄';
    if (statusCode >= 400 && statusCode < 500) return '⚠️';
    if (statusCode >= 500) return '💥';
    return '❓';
  }

  static String _getStatusDescription(int statusCode) {
    if (statusCode >= 200 && statusCode < 300) return 'SUCCESS';
    if (statusCode >= 300 && statusCode < 400) return 'REDIRECT';
    if (statusCode >= 400 && statusCode < 500) return 'CLIENT ERROR';
    if (statusCode >= 500) return 'SERVER ERROR';
    return 'UNKNOWN';
  }

  static String _formatResponseTime(int milliseconds) {
    if (milliseconds < 1000) {
      return '${milliseconds}ms';
    } else if (milliseconds < 60000) {
      return '${(milliseconds / 1000).toStringAsFixed(2)}s';
    } else {
      final minutes = milliseconds ~/ 60000;
      final seconds = (milliseconds % 60000) / 1000;
      return '${minutes}m ${seconds.toStringAsFixed(2)}s';
    }
  }

  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  static String _maskSensitiveHeader(String key, String value) {
    final sensitiveKeys = ['authorization', 'cookie', 'x-api-key', 'token'];
    if (sensitiveKeys.any((k) => key.toLowerCase().contains(k))) {
      if (value.length <= 10) return '***';
      return '${value.substring(0, 8)}...${value.substring(value.length - 4)}';
    }
    return value;
  }

  static String _formatRequestBody(dynamic data) {
    try {
      if (data is String) return data;
      if (data is Map || data is List) {
        return const JsonEncoder.withIndent('  ').convert(data);
      }
      return data.toString();
    } catch (e) {
      return 'Failed to format request body: $e';
    }
  }

  static String _formatResponseBody(dynamic data) {
    try {
      if (data is String) {
        // Try to parse as JSON for pretty printing
        try {
          final parsed = jsonDecode(data);
          return const JsonEncoder.withIndent('  ').convert(parsed);
        } catch (_) {
          return data;
        }
      }
      if (data is Map || data is List) {
        return const JsonEncoder.withIndent('  ').convert(data);
      }
      return data.toString();
    } catch (e) {
      return 'Failed to format response body: $e';
    }
  }

  static String _formatErrorResponse(dynamic data) {
    try {
      if (data is Map) {
        // Extract key error information
        final Map<String, dynamic> errorInfo = {};
        if (data.containsKey('message')) errorInfo['message'] = data['message'];
        if (data.containsKey('error')) errorInfo['error'] = data['error'];
        if (data.containsKey('code')) errorInfo['code'] = data['code'];
        if (data.containsKey('details')) errorInfo['details'] = data['details'];
        
        return errorInfo.isNotEmpty 
          ? const JsonEncoder.withIndent('  ').convert(errorInfo)
          : const JsonEncoder.withIndent('  ').convert(data);
      }
      return data.toString();
    } catch (e) {
      return 'Failed to format error response: $e';
    }
  }

  static Map<String, String> _extractImportantHeaders(Map<String, dynamic> headers) {
    final important = <String, String>{};
    final importantKeys = ['content-type', 'content-length', 'cache-control', 'etag'];
    
    headers.forEach((key, value) {
      if (importantKeys.contains(key.toLowerCase())) {
        important[key] = value.toString();
      }
    });
    
    return important;
  }

  static String _extractResponseSummary(dynamic data) {
    try {
      if (data is Map) {
        final keys = data.keys.take(5).join(', ');
        return 'Contains keys: $keys${data.keys.length > 5 ? '...' : ''}';
      } else if (data is List) {
        return 'Array with ${data.length} items';
      }
      return 'Data type: ${data.runtimeType}';
    } catch (e) {
      return 'Unable to extract summary';
    }
  }
}