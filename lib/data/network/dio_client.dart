import 'package:dio/dio.dart';
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
          return handler.next(options);
        },
      ),
    );
  }

  /// Get the underlying Dio instance
  Dio get dio => _dio;

  Future<Response<dynamic>> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response<dynamic>> post(String path,
      {Map<String, dynamic>? data}) async {
    return await _dio.post(path, data: data);
  }

  Future<Response<dynamic>> put(String path,
      {Map<String, dynamic>? data}) async {
    return await _dio.put(path, data: data);
  }

  Future<Response<dynamic>> delete(String path) async {
    return await _dio.delete(path);
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
