import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    print('Request Headers:');
    options.headers.forEach((key, value) {
      print('$key: $value');
    });
    print('Request Data: ${options.data}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');

    print('Full Response Object:');
    print(response.toString());

    print('Response Headers:');
    _printHeaders(response.headers.map);

    print('Response Data: ${response.data}');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');

    if (err.response != null) {
      print('Error Response Headers:');
      _printHeaders(err.response!.headers.map);
    }

    print('Error Data: ${err.response?.data}');
    return super.onError(err, handler);
  }

  void _printHeaders(Map<String, List<String>> headers) {
    headers.forEach((key, values) {
      for (var value in values) {
        print('$key: $value');
      }
    });
  }
}