import 'package:flutter_test/flutter_test.dart';
import 'package:musicbud_flutter/services/endpoint_config_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late EndpointConfigService service;

  setUp(() {
    service = EndpointConfigService();
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