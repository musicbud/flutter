import 'package:dio/dio.dart';
import 'dart:developer' as developer;

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    developer.log('REQUEST[${options.method}] => PATH: ${options.path}');
    developer.log('Request Headers:');
    options.headers.forEach((key, value) {
      developer.log('$key: $value');
    });
    developer.log('Request Data: ${options.data}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    developer.log('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');

    developer.log('Full Response Object:');
    developer.log(response.toString());

    developer.log('Response Headers:');
    _printHeaders(response.headers.map);

    developer.log('Response Data: ${response.data}');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    developer.log('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');

    if (err.response != null) {
      developer.log('Error Response Headers:');
      _printHeaders(err.response!.headers.map);
    }

    developer.log('Error Data: ${err.response?.data}');
    return super.onError(err, handler);
  }

  void _printHeaders(Map<String, List<String>> headers) {
    headers.forEach((key, values) {
      for (var value in values) {
        developer.log('$key: $value');
      }
    });
  }
}