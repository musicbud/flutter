import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:musicbud_flutter/data/network/dio_client.dart';
import 'package:musicbud_flutter/data/providers/token_provider.dart';

class HttpUtils {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiryKey = 'token_expiry';

  /// Handle Dio exceptions and provide meaningful error messages
  static String handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Send timeout. Request took too long to send.';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout. Response took too long to receive.';
      case DioExceptionType.badResponse:
        return _handleBadResponse(e.response);
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        return 'Connection error. Please check your internet connection.';
      case DioExceptionType.unknown:
        return 'An unknown error occurred: ${e.message}';
      default:
        return 'Network error: ${e.message}';
    }
  }

  /// Handle HTTP response errors with specific status codes
  static String _handleBadResponse(Response? response) {
    if (response == null) {
      return 'No response received from server.';
    }

    final statusCode = response.statusCode;
    final data = response.data;

    switch (statusCode) {
      case 400:
        return 'Bad request: ${_extractErrorMessage(data)}';
      case 401:
        return 'Unauthorized. Please log in again.';
      case 403:
        return 'Forbidden. You don\'t have permission to access this resource.';
      case 404:
        return 'Resource not found. The requested endpoint may not exist or has been moved.';
      case 405:
        return 'Method not allowed. The HTTP method is not supported for this endpoint.';
      case 409:
        return 'Conflict. The request conflicts with the current state of the server.';
      case 422:
        return 'Validation error: ${_extractErrorMessage(data)}';
      case 429:
        return 'Too many requests. Please try again later.';
      case 500:
        return 'Internal server error. Please try again later.';
      case 502:
        return 'Bad gateway. The server received an invalid response.';
      case 503:
        return 'Service unavailable. The server is temporarily unavailable.';
      case 504:
        return 'Gateway timeout. The server took too long to respond.';
      default:
        return 'HTTP error $statusCode: ${_extractErrorMessage(data)}';
    }
  }

  /// Extract error message from response data
  static String _extractErrorMessage(dynamic data) {
    if (data == null) return 'No error details available';

    if (data is Map<String, dynamic>) {
      if (data.containsKey('message')) {
        return data['message'].toString();
      }
      if (data.containsKey('error')) {
        return data['error'].toString();
      }
      if (data.containsKey('detail')) {
        return data['detail'].toString();
      }
      return data.toString();
    }

    return data.toString();
  }

  /// Log request details for debugging
  static void logRequest(String method, String url, {Map<String, dynamic>? data, Map<String, dynamic>? headers}) {
    if (kDebugMode) {
      debugPrint('🌐 [$method] Request: $url');
      if (data != null) {
        debugPrint('📤 Body: $data');
      }
      if (headers != null) {
        debugPrint('📋 Headers: $headers');
      }
    }
  }

  /// Log response details for debugging
  static void logResponse(int statusCode, String url, {dynamic data}) {
    if (kDebugMode) {
      debugPrint('✅ [$statusCode] Response: $url');
      if (data != null) {
        debugPrint('📥 Body: $data');
      }
    }
  }

  /// Log error details for debugging
  static void logError(int? statusCode, String url, {String? message, dynamic data}) {
    if (kDebugMode) {
      debugPrint('❌ [${statusCode ?? 'N/A'}] Error: $url');
      if (message != null) {
        debugPrint('💬 Message: $message');
      }
      if (data != null) {
        debugPrint('📥 Error Data: $data');
      }
    }
  }

  /// Check if the error is a 404 (Not Found) error
  static bool isNotFoundError(DioException e) {
    return e.type == DioExceptionType.badResponse && e.response?.statusCode == 404;
  }

  /// Check if the error is an authentication error
  static bool isAuthenticationError(DioException e) {
    return e.type == DioExceptionType.badResponse &&
           (e.response?.statusCode == 401 || e.response?.statusCode == 403);
  }

  /// Check if the error is a server error
  static bool isServerError(DioException e) {
    return e.type == DioExceptionType.badResponse &&
           (e.response?.statusCode ?? 0) >= 500;
  }

  /// Check if the error is a network connectivity issue
  static bool isNetworkError(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
           e.type == DioExceptionType.connectionError ||
           e.type == DioExceptionType.receiveTimeout ||
           e.type == DioExceptionType.sendTimeout;
  }

  /// Gets user-friendly error messages for different error types
  static String getUserFriendlyMessage(DioException e) {
    if (isNotFoundError(e)) {
      return 'The requested resource was not found. Please:\n'
             '• Check the URL or resource ID\n'
             '• Verify the resource still exists\n'
             '• Try again in a few minutes\n'
             '• Check if the service is available\n'
             '• Contact support if the problem persists';
    }

    if (isNetworkError(e)) {
      return 'Network connection issue. Please:\n'
             '• Check your internet connection\n'
             '• Try again when connection is stable\n'
             '• Check if the server is reachable';
    }

    return handleDioException(e);
  }
}
