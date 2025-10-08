import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_proxy/shelf_proxy.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:logging/logging.dart';

final _logger = Logger('ProxyServer');
const _proxyPort = 8080;
const _targetUrl = 'http://localhost:3000';

Future<void> startProxyServer() async {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    _logger.info('${record.level.name}: ${record.time}: ${record.message}');
  });

  final handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addHandler(proxyHandler(_targetUrl));

  final server = await io.serve(handler, 'localhost', _proxyPort);
  _logger.info('Proxy server running on localhost:${server.port}');
}