import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_proxy/shelf_proxy.dart';
import 'package:http/http.dart' as http;

Future<void> startProxyServer() async {
  final targetUrl = 'http://84.235.170.234';
  final proxyHandlerFunc = proxyHandler(targetUrl);

  final handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addMiddleware((innerHandler) {
    return (request) async {
      final updatedRequest = request.change(headers: {
        ...request.headers,
        'Origin': targetUrl,
        'Cookie': 'musicbud_sessionid=8jnl9l28o3egdc25ezykc3v5may4o74i',
      });
      return await innerHandler(updatedRequest);
    };
  })
      .addHandler((request) => proxyHandlerFunc(request));

  final server = await io.serve(handler, 'localhost', 8080);
  print('Proxy server listening on port ${server.port}');
}
