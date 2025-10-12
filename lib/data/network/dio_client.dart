import 'package:dio/dio.dart';
import '../../utils/http_utils.dart';
import '../providers/token_provider.dart';
import '../../domain/repositories/auth_repository.dart';

/// A wrapper around [Dio] that provides consistent error handling and configuration
class DioClient {
  final Dio _dio;
  final TokenProvider _tokenProvider;
  final AuthRepository? _authRepository;
  bool _isRefreshing = false;

  DioClient({
    required String baseUrl,
    required Dio dio,
    required TokenProvider tokenProvider,
    AuthRepository? authRepository,
  }) : _dio = dio,
        _tokenProvider = tokenProvider,
        _authRepository = authRepository {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 5); // Reduced from 30 to 5 seconds
    _dio.options.receiveTimeout = const Duration(seconds: 10); // Reduced from 30 to 10 seconds
    _dio.options.sendTimeout = const Duration(seconds: 10); // Reduced from 30 to 10 seconds
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'User-Agent': 'MusicBud-Flutter/1.0',
    };

    // Add custom retry logic via interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          // Retry logic for connection errors
          if (_shouldRetry(error) && error.requestOptions.extra['retryCount'] == null) {
            error.requestOptions.extra['retryCount'] = 1;
            return _retryRequest(error, handler);
          } else if (_shouldRetry(error) && error.requestOptions.extra['retryCount'] < 3) {
            error.requestOptions.extra['retryCount'] = error.requestOptions.extra['retryCount'] + 1;
            return _retryRequest(error, handler);
          }
          return handler.next(error);
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _tokenProvider.token;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          } else {
            // No token available
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
        onError: (error, handler) async {
          // Log the error
          HttpUtils.logError(
            error.response?.statusCode,
            error.requestOptions.uri.toString(),
            message: error.message,
            data: error.response?.data,
          );

          // Handle 401 Unauthorized - attempt token refresh
          if (error.response?.statusCode == 401 && _authRepository != null) {
            if (!_isRefreshing) {
              _isRefreshing = true;
              try {
                // Attempt to refresh token
                final refreshResult = await _authRepository!.refreshToken();
                // Update the token
                await _tokenProvider.updateAccessToken(refreshResult.accessToken);

                // Retry the original request with new token
                final retryOptions = error.requestOptions;
                retryOptions.headers['Authorization'] = 'Bearer ${refreshResult.accessToken}';

                final retryResponse = await _dio.request(
                  retryOptions.path,
                  options: Options(
                    method: retryOptions.method,
                    headers: retryOptions.headers,
                  ),
                  data: retryOptions.data,
                  queryParameters: retryOptions.queryParameters,
                );

                _isRefreshing = false;
                return handler.resolve(retryResponse);
              } catch (refreshError) {
                _isRefreshing = false;
                // If refresh fails, clear tokens and let the error propagate
                await _tokenProvider.clearTokens();
                return handler.next(error);
              }
            } else {
              // If already refreshing, wait a bit and retry
              await Future.delayed(const Duration(milliseconds: 100));
              if (_tokenProvider.token != null) {
                final retryOptions = error.requestOptions;
                retryOptions.headers['Authorization'] = 'Bearer ${_tokenProvider.token}';

                try {
                  final retryResponse = await _dio.request(
                    retryOptions.path,
                    options: Options(
                      method: retryOptions.method,
                      headers: retryOptions.headers,
                    ),
                    data: retryOptions.data,
                    queryParameters: retryOptions.queryParameters,
                  );
                  return handler.resolve(retryResponse);
                } catch (retryError) {
                  return handler.next(error);
                }
              }
            }
          }

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
      // Retry once for 500 server errors (working logic from commit 6cac314)
      if (e.response?.statusCode == 500) {
        try {
          await Future.delayed(const Duration(seconds: 2)); // Wait 2 seconds before retry
          return await _dio.get(path, queryParameters: queryParameters);
        } catch (retryError) {
          if (retryError is DioException) {
            _handleDioException(retryError, 'GET', path);
          }
          rethrow;
        }
      }
      _handleDioException(e, 'GET', path);
      rethrow;
    }
  }

  Future<Response<dynamic>> post(String path,
      {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      // Retry once for 500 server errors (working logic from commit 6cac314)
      if (e.response?.statusCode == 500) {
        try {
          await Future.delayed(const Duration(seconds: 2)); // Wait 2 seconds before retry
          return await _dio.post(path, data: data);
        } catch (retryError) {
          if (retryError is DioException) {
            _handleDioException(retryError, 'POST', path);
          }
          rethrow;
        }
      }
      _handleDioException(e, 'POST', path);
      rethrow;
    }
  }

  Future<Response<dynamic>> put(String path,
      {Map<String, dynamic>? data}) async {
    try {
      return await _dio.put(path, data: data);
    } on DioException catch (e) {
      // Retry once for 500 server errors (working logic from commit 6cac314)
      if (e.response?.statusCode == 500) {
        try {
          await Future.delayed(const Duration(seconds: 2)); // Wait 2 seconds before retry
          return await _dio.put(path, data: data);
        } catch (retryError) {
          if (retryError is DioException) {
            _handleDioException(retryError, 'PUT', path);
          }
          rethrow;
        }
      }
      _handleDioException(e, 'PUT', path);
      rethrow;
    }
  }

  Future<Response<dynamic>> delete(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.delete(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      // Retry once for 500 server errors (working logic from commit 6cac314)
      if (e.response?.statusCode == 500) {
        try {
          await Future.delayed(const Duration(seconds: 2)); // Wait 2 seconds before retry
          return await _dio.delete(path, queryParameters: queryParameters);
        } catch (retryError) {
          if (retryError is DioException) {
            _handleDioException(retryError, 'DELETE', path);
          }
          rethrow;
        }
      }
      _handleDioException(e, 'DELETE', path);
      rethrow;
    }
  }


  /// Handle Dio exceptions with enhanced error information (working from commit 6cac314)
  void _handleDioException(DioException e, String method, String path) {
    if (HttpUtils.isNotFoundError(e)) {
      // 404 Error detected
    }

    if (HttpUtils.isAuthenticationError(e)) {
      // Authentication error
    }

    if (HttpUtils.isServerError(e)) {
      // Server error
    }

    if (HttpUtils.isNetworkError(e)) {
      // Network error
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

  /// Determines if a request should be retried based on the error type
  bool _shouldRetry(DioException error) {
    // Don't retry if it's a connection issue with no backend running
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.unknown) {
      // Only retry once for connection issues
      final retryCount = error.requestOptions.extra['retryCount'] ?? 0;
      return retryCount == 0;
    }
    
    // Don't retry timeout errors excessively
    if (error.type == DioExceptionType.receiveTimeout) {
      return false;
    }
    
    // Retry server errors (5xx)
    return error.response?.statusCode != null && 
           error.response!.statusCode! >= 500;
  }

  /// Retries a failed request after a delay
  Future<void> _retryRequest(DioException error, ErrorInterceptorHandler handler) async {
    final retryCount = error.requestOptions.extra['retryCount'] ?? 1;
    
    // Limit delay for connection issues (fast fail when backend is down)
    final delaySeconds = error.type == DioExceptionType.connectionTimeout ||
                        error.type == DioExceptionType.unknown
                        ? 1 // Quick retry for connection issues
                        : retryCount * 2; // Exponential backoff for other issues
    
    await Future.delayed(Duration(seconds: delaySeconds));
    
    try {
      final response = await _dio.request(
        error.requestOptions.path,
        data: error.requestOptions.data,
        queryParameters: error.requestOptions.queryParameters,
        options: Options(
          method: error.requestOptions.method,
          headers: error.requestOptions.headers,
        ),
      );
      return handler.resolve(response);
    } catch (retryError) {
      if (retryError is DioException) {
        retryError.requestOptions.extra['retryCount'] = retryCount;
        return handler.next(retryError);
      }
      return handler.next(error);
    }
  }
}
