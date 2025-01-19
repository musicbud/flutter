import 'package:dio/dio.dart';

/// A wrapper around [Dio] that provides consistent error handling and configuration
class DioClient {
  final Dio _dio;

  DioClient({required String baseUrl})
      : _dio = Dio(BaseOptions(baseUrl: baseUrl));

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
