import 'package:dio/dio.dart';
import '../../utils/http_utils.dart';
import '../providers/token_provider.dart';

/// A wrapper around [Dio] that provides consistent error handling and configuration
class DioClient {
  final Dio _dio;
  final TokenProvider _tokenProvider;

  DioClient({
    required String baseUrl,
    required Dio dio,
    required TokenProvider tokenProvider,
  }) : _dio = dio,
       _tokenProvider = tokenProvider {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _tokenProvider.token;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          // Log request details
          HttpUtils.logRequest(
            options.method,
            options.uri.toString(),
            data: options.data,
            headers: options.headers,
          );

          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Log response details
          HttpUtils.logResponse(
            response.statusCode ?? 0,
            response.requestOptions.uri.toString(),
            data: response.data,
          );

          return handler.next(response);
        },
        onError: (error, handler) {
          // Log the error
          HttpUtils.logError(
            error.response?.statusCode,
            error.requestOptions.uri.toString(),
            message: error.message,
            data: error.response?.data,
          );

          // Create a new error with enhanced message for 404 errors
          if (HttpUtils.isNotFoundError(error)) {
            final enhancedError = DioException(
              requestOptions: error.requestOptions,
              response: error.response,
              type: error.type,
              error: error.error,
              message: HttpUtils.getUserFriendlyMessage(error),
            );
            return handler.next(enhancedError);
          }

          return handler.next(error);
        },
      ),
    );
  }

  /// Get the underlying Dio instance
  Dio get dio => _dio;

  Future<Response<dynamic>> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      _handleDioException(e, 'GET', path);
      rethrow;
    }
  }

  Future<Response<dynamic>> post(String path,
      {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      _handleDioException(e, 'POST', path);
      rethrow;
    }
  }

  Future<Response<dynamic>> put(String path,
      {Map<String, dynamic>? data}) async {
    try {
      return await _dio.put(path, data: data);
    } on DioException catch (e) {
      _handleDioException(e, 'PUT', path);
      rethrow;
    }
  }

  Future<Response<dynamic>> delete(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.delete(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      _handleDioException(e, 'DELETE', path);
      rethrow;
    }
  }

  /// Handle Dio exceptions with enhanced error information
  void _handleDioException(DioException e, String method, String path) {
    final fullUrl = '${_dio.options.baseUrl}$path';

    if (HttpUtils.isNotFoundError(e)) {
      print('🚨 404 Error detected for $method $fullUrl');
      print('💡 This endpoint may not exist in the backend API');
      print('📚 Check the backend repository for correct endpoints: https://github.com/musicbud/backend');
      print('🔧 Consider updating the API configuration if endpoints have changed');
    }

    if (HttpUtils.isAuthenticationError(e)) {
      print('🔐 Authentication error for $method $fullUrl');
      print('💡 Check if the user is properly logged in and token is valid');
    }

    if (HttpUtils.isServerError(e)) {
      print('🖥️ Server error for $method $fullUrl');
      print('💡 The backend server may be experiencing issues');
    }

    if (HttpUtils.isNetworkError(e)) {
      print('🌐 Network error for $method $fullUrl');
      print('💡 Check internet connection and server availability');
    }
  }

  /// Adds an interceptor to the Dio instance
  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  /// Updates the base URL of the Dio instance
  void updateBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  /// Updates the headers of the Dio instance
  void updateHeaders(Map<String, dynamic> headers) {
    _dio.options.headers.addAll(headers);
  }
}
