import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/endpoint.dart';

/// Service for managing dynamic endpoint configuration
class EndpointConfigService {
  static const String _endpointsAssetPath = 'assets/endpoints_map.json';

  List<Endpoint>? _endpoints;
  bool _isInitialized = false;

  /// Initializes the service by loading and parsing the endpoints JSON
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final jsonString = await rootBundle.loadString(_endpointsAssetPath);
      final jsonData = json.decode(jsonString) as List<dynamic>;

      _endpoints = jsonData
          .map((item) => Endpoint.fromJson(item as Map<String, dynamic>))
          .toList();

      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to load endpoints configuration: $e');
    }
  }

  /// Gets all loaded endpoints
  List<Endpoint> getAllEndpoints() {
    _ensureInitialized();
    return List.unmodifiable(_endpoints!);
  }

  /// Gets an endpoint by its name
  Endpoint? getEndpointByName(String name) {
    _ensureInitialized();
    return _endpoints!.cast<Endpoint?>().firstWhere(
          (endpoint) => endpoint!.name == name,
          orElse: () => null,
        );
  }

  /// Gets the full URL for an endpoint by name with host replacement
  String? getEndpointUrl(String name, String baseUrl) {
    final endpoint = getEndpointByName(name);
    return endpoint?.getUrlWithHost(baseUrl);
  }

  /// Gets the HTTP method for an endpoint by name
  String? getEndpointMethod(String name) {
    final endpoint = getEndpointByName(name);
    return endpoint?.method;
  }

  /// Gets endpoint information (method and URL) by name
  Map<String, String>? getEndpointInfo(String name, String baseUrl) {
    final endpoint = getEndpointByName(name);
    if (endpoint == null) return null;

    return {
      'method': endpoint.method,
      'url': endpoint.getUrlWithHost(baseUrl),
    };
  }

  /// Checks if an endpoint exists by name
  bool hasEndpoint(String name) {
    _ensureInitialized();
    return _endpoints!.any((endpoint) => endpoint.name == name);
  }

  /// Gets endpoints filtered by status
  List<Endpoint> getEndpointsByStatus(String status) {
    _ensureInitialized();
    return _endpoints!.where((endpoint) => endpoint.status == status).toList();
  }

  void _ensureInitialized() {
    if (!_isInitialized || _endpoints == null) {
      throw StateError(
        'EndpointConfigService must be initialized before use. Call initialize() first.',
      );
    }
  }
}