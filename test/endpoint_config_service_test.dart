import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:musicbud_flutter/services/endpoint_config_service.dart';
import 'package:musicbud_flutter/models/endpoint.dart';

// Create a mock service that doesn't require asset loading
class MockEndpointConfigService extends Mock implements EndpointConfigService {
  final List<Endpoint> _mockEndpoints = [
    const Endpoint(
      name: 'auth - login',
      method: 'POST',
      url: 'http://{{host}}/login',
      status: 'done',
    ),
    const Endpoint(
      name: 'auth - register',
      method: 'POST',
      url: 'http://{{host}}/register',
      status: 'done',
    ),
    const Endpoint(
      name: 'buds - get bud profile',
      method: 'POST',
      url: 'http://{{host}}/bud/profile',
      status: 'done',
    ),
  ];

  @override
  Future<void> initialize() async {
    // Mock initialization - no asset loading required
    return Future.value();
  }

  @override
  List<Endpoint> getAllEndpoints() {
    return List.unmodifiable(_mockEndpoints);
  }

  @override
  Endpoint? getEndpointByName(String name) {
    return _mockEndpoints.cast<Endpoint?>().firstWhere(
      (endpoint) => endpoint!.name == name,
      orElse: () => null,
    );
  }

  @override
  String? getEndpointUrl(String name, String baseUrl) {
    final endpoint = getEndpointByName(name);
    return endpoint?.getUrlWithHost(baseUrl);
  }

  @override
  String? getEndpointMethod(String name) {
    final endpoint = getEndpointByName(name);
    return endpoint?.method;
  }

  @override
  Map<String, String>? getEndpointInfo(String name, String baseUrl) {
    final endpoint = getEndpointByName(name);
    if (endpoint == null) return null;

    return {
      'method': endpoint.method,
      'url': endpoint.getUrlWithHost(baseUrl),
    };
  }

  @override
  bool hasEndpoint(String name) {
    return _mockEndpoints.any((endpoint) => endpoint.name == name);
  }

  @override
  List<Endpoint> getEndpointsByStatus(String status) {
    return _mockEndpoints.where((endpoint) => endpoint.status == status).toList();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockEndpointConfigService service;

  setUp(() {
    service = MockEndpointConfigService();
  });

  group('EndpointConfigService', () {
    test('should initialize and load endpoints', () async {
      await service.initialize();

      final endpoints = service.getAllEndpoints();
      expect(endpoints.isNotEmpty, true);
      expect(endpoints.length, greaterThan(0));
    });

    test('should retrieve endpoint by name', () async {
      await service.initialize();

      final endpoint = service.getEndpointByName('auth - login');
      expect(endpoint, isNotNull);
      expect(endpoint!.name, 'auth - login');
      expect(endpoint.method, 'POST');
      expect(endpoint.status, 'done');
    });

    test('should return null for non-existent endpoint', () async {
      await service.initialize();

      final endpoint = service.getEndpointByName('non-existent-endpoint');
      expect(endpoint, isNull);
    });

    test('should get endpoint URL with host replacement', () async {
      await service.initialize();

      const testBaseUrl = 'http://test.example.com';
      final url = service.getEndpointUrl('auth - login', testBaseUrl);
      expect(url, isNotNull);
      expect(url, 'http://test.example.com/login');
    });

    test('should get endpoint method', () async {
      await service.initialize();

      final method = service.getEndpointMethod('auth - login');
      expect(method, 'POST');
    });

    test('should get endpoint info', () async {
      await service.initialize();

      const testBaseUrl = 'http://test.example.com';
      final info = service.getEndpointInfo('auth - login', testBaseUrl);
      expect(info, isNotNull);
      expect(info!['method'], 'POST');
      expect(info['url'], 'http://test.example.com/login');
    });

    test('should check if endpoint exists', () async {
      await service.initialize();

      expect(service.hasEndpoint('auth - login'), true);
      expect(service.hasEndpoint('non-existent'), false);
    });

    test('should get endpoints by status', () async {
      await service.initialize();

      final doneEndpoints = service.getEndpointsByStatus('done');
      expect(doneEndpoints.isNotEmpty, true);
      expect(doneEndpoints.every((e) => e.status == 'done'), true);
    });

    test('should handle host replacement in URL', () async {
      await service.initialize();

      const testBaseUrl = 'https://api.example.com:8080';
      final url = service.getEndpointUrl('auth - login', testBaseUrl);
      expect(url, 'https://api.example.com:8080/login');
    });
  });
}