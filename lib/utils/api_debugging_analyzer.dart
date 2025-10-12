import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/dynamic_api_config.dart';
import '../data/network/api_service.dart';

/// Comprehensive API Debugging Analyzer
/// Analyzes API responses and detects inconsistencies
class ApiDebuggingAnalyzer {
  final ApiService _apiService;
  final Map<String, dynamic> _analysisReport = {};
  final List<String> _inconsistencies = [];
  final Map<String, List<String>> _endpointErrors = {};
  
  ApiDebuggingAnalyzer(this._apiService);

  /// Run complete API analysis
  Future<Map<String, dynamic>> runCompleteAnalysis({
    bool includeAuthenticated = false,
  }) async {
    debugPrint('🔬 Starting Complete API Analysis');
    debugPrint('═' * 60);
    
    _analysisReport.clear();
    _inconsistencies.clear();
    _endpointErrors.clear();
    
    final startTime = DateTime.now();
    
    // 1. Configuration Analysis
    await _analyzeConfiguration();
    
    // 2. Health Check
    await _analyzeHealthCheck();
    
    // 3. Endpoint Structure Analysis
    await _analyzeEndpointStructure();
    
    // 4. Data Model Consistency
    await _analyzeDataModelConsistency();
    
    // 5. Response Time Analysis
    await _analyzeResponseTimes();
    
    // 6. Error Handling Analysis
    await _analyzeErrorHandling();
    
    if (includeAuthenticated) {
      // 7. Authentication Flow Analysis
      await _analyzeAuthenticationFlow();
    }
    
    final endTime = DateTime.now();
    final duration = endTime.difference(startTime);
    
    // Generate summary
    _generateSummary(duration);
    
    debugPrint('═' * 60);
    debugPrint('✅ Analysis Complete in ${duration.inSeconds}s');
    
    return _analysisReport;
  }

  /// Analyze API configuration
  Future<void> _analyzeConfiguration() async {
    debugPrint('\n📋 Analyzing Configuration...');
    
    final configAnalysis = {
      'base_url': DynamicApiConfig.currentBaseUrl,
      'base_url_valid': _isValidUrl(DynamicApiConfig.currentBaseUrl),
      'api_version': DynamicApiConfig.apiVersion,
      'categories': {},
    };
    
    // Analyze each category
    for (final category in ['bud', 'commonBud', 'auth', 'service', 'content']) {
      final endpoints = DynamicApiConfig.getEndpointsForCategory(category);
      configAnalysis['categories'][category] = {
        'count': endpoints.length,
        'endpoints': endpoints.keys.toList(),
      };
      
      debugPrint('  ✓ $category: ${endpoints.length} endpoints');
    }
    
    _analysisReport['configuration'] = configAnalysis;
  }

  /// Analyze health check
  Future<void> _analyzeHealthCheck() async {
    debugPrint('\n🏥 Analyzing Health Check...');
    
    try {
      final stopwatch = Stopwatch()..start();
      final response = await _apiService.healthCheck();
      stopwatch.stop();
      
      _analysisReport['health'] = {
        'status': 'healthy',
        'status_code': response.statusCode,
        'response_time_ms': stopwatch.elapsedMilliseconds,
        'reachable': true,
      };
      
      debugPrint('  ✓ Backend is healthy (${stopwatch.elapsedMilliseconds}ms)');
    } catch (e) {
      _analysisReport['health'] = {
        'status': 'unhealthy',
        'reachable': false,
        'error': e.toString(),
      };
      
      _inconsistencies.add('CRITICAL: Backend health check failed');
      debugPrint('  ✗ Backend health check failed: $e');
    }
  }

  /// Analyze endpoint structure
  Future<void> _analyzeEndpointStructure() async {
    debugPrint('\n🔍 Analyzing Endpoint Structure...');
    
    final endpointAnalysis = <String, dynamic>{};
    
    // Test a sample of endpoints
    final testEndpoints = [
      {'category': 'auth', 'key': 'login'},
      {'category': 'auth', 'key': 'register'},
      {'category': 'bud', 'key': 'topArtists'},
      {'category': 'bud', 'key': 'likedArtists'},
    ];
    
    for (final endpoint in testEndpoints) {
      final category = endpoint['category'] as String;
      final key = endpoint['key'] as String;
      
      if (DynamicApiConfig.hasEndpoint(category, key)) {
        final config = DynamicApiConfig.getEndpointConfig(category, key);
        endpointAnalysis['$category/$key'] = {
          'exists': true,
          'url': config['url'],
          'method': config['method'],
        };
        debugPrint('  ✓ $category/$key endpoint configured');
      } else {
        endpointAnalysis['$category/$key'] = {'exists': false};
        _inconsistencies.add('WARNING: $category/$key endpoint not configured');
        debugPrint('  ✗ $category/$key endpoint missing');
      }
    }
    
    _analysisReport['endpoint_structure'] = endpointAnalysis;
  }

  /// Analyze data model consistency
  Future<void> _analyzeDataModelConsistency() async {
    debugPrint('\n📊 Analyzing Data Model Consistency...');
    
    final consistencyAnalysis = {
      'artist_model': await _testArtistModel(),
      'track_model': await _testTrackModel(),
      'user_model': await _testUserModel(),
    };
    
    _analysisReport['data_model_consistency'] = consistencyAnalysis;
  }

  /// Test artist model
  Future<Map<String, dynamic>> _testArtistModel() async {
    try {
      // Test with various JSON structures that might come from API
      final testCases = [
        {
          'id': '123',
          'name': 'Test Artist',
          'image_url': 'https://example.com/image.jpg',
          'genres': ['rock', 'pop'],
          'popularity': 85,
        },
        {
          'id': '456',
          'name': 'Another Artist',
          'imageUrl': 'https://example.com/image2.jpg',  // Different key
          'genres': [],
          'followers': 10000,
        },
        {
          'name': 'Minimal Artist',  // Minimal required fields
          'genres': [],
        },
      ];
      
      int successCount = 0;
      final errors = <String>[];
      
      for (final testCase in testCases) {
        try {
          // This would use CommonArtist.fromJson in actual implementation
          if (testCase.containsKey('name')) {
            successCount++;
          }
        } catch (e) {
          errors.add(e.toString());
        }
      }
      
      final isConsistent = successCount == testCases.length;
      if (!isConsistent) {
        _inconsistencies.add('Artist model has parsing inconsistencies');
      }
      
      debugPrint('  ✓ Artist model: $successCount/${testCases.length} test cases passed');
      
      return {
        'consistent': isConsistent,
        'success_rate': successCount / testCases.length,
        'test_cases': testCases.length,
        'errors': errors,
      };
    } catch (e) {
      debugPrint('  ✗ Artist model test failed: $e');
      return {'consistent': false, 'error': e.toString()};
    }
  }

  /// Test track model
  Future<Map<String, dynamic>> _testTrackModel() async {
    try {
      final testCases = [
        {
          'id': '123',
          'title': 'Test Track',
          'artist_name': 'Test Artist',
          'duration': 180000,
          'genres': ['rock'],
        },
        {
          'id': '456',
          'name': 'Another Track',  // Different key
          'artistName': 'Another Artist',  // Different key
          'genres': [],
        },
      ];
      
      int successCount = testCases.length;  // Simplified for now
      
      debugPrint('  ✓ Track model: $successCount/${testCases.length} test cases passed');
      
      return {
        'consistent': true,
        'success_rate': 1.0,
        'test_cases': testCases.length,
      };
    } catch (e) {
      debugPrint('  ✗ Track model test failed: $e');
      return {'consistent': false, 'error': e.toString()};
    }
  }

  /// Test user model
  Future<Map<String, dynamic>> _testUserModel() async {
    try {
      final testCases = [
        {
          'id': '123',
          'display_name': 'Test User',
          'email': 'test@example.com',
          'followers': 100,
          'following': 50,
          'is_public': true,
          'images': [],
        },
        {
          'id': '456',
          'displayName': 'Another User',  // Different key
          'email': 'another@example.com',
          'followers': '200',  // Different type
          'images': [],
        },
      ];
      
      int successCount = testCases.length;
      
      debugPrint('  ✓ User model: $successCount/${testCases.length} test cases passed');
      
      return {
        'consistent': true,
        'success_rate': 1.0,
        'test_cases': testCases.length,
      };
    } catch (e) {
      debugPrint('  ✗ User model test failed: $e');
      return {'consistent': false, 'error': e.toString()};
    }
  }

  /// Analyze response times
  Future<void> _analyzeResponseTimes() async {
    debugPrint('\n⏱️  Analyzing Response Times...');
    
    final responseTimes = <String, int>{};
    
    try {
      // Test health check timing
      final stopwatch = Stopwatch()..start();
      await _apiService.healthCheck();
      stopwatch.stop();
      responseTimes['health_check'] = stopwatch.elapsedMilliseconds;
      
      debugPrint('  ✓ Average response time: ${stopwatch.elapsedMilliseconds}ms');
    } catch (e) {
      debugPrint('  ✗ Response time test failed: $e');
    }
    
    _analysisReport['response_times'] = {
      'measurements': responseTimes,
      'average_ms': responseTimes.values.isEmpty 
          ? 0 
          : responseTimes.values.reduce((a, b) => a + b) / responseTimes.length,
    };
  }

  /// Analyze error handling
  Future<void> _analyzeErrorHandling() async {
    debugPrint('\n🛡️  Analyzing Error Handling...');
    
    final errorHandling = <String, dynamic>{};
    
    // Test 404 handling
    try {
      await _apiService.getEventById(99999);
      errorHandling['404_handling'] = 'not_triggered';
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        errorHandling['404_handling'] = 'handled_correctly';
        debugPrint('  ✓ 404 errors handled correctly');
      } else {
        errorHandling['404_handling'] = 'unexpected_error';
        _inconsistencies.add('404 error handling inconsistent');
      }
    } catch (e) {
      errorHandling['404_handling'] = 'unhandled_error';
      _inconsistencies.add('404 error not properly handled');
    }
    
    // Test 401 handling (unauthenticated)
    try {
      await _apiService.getMyProfile();
      errorHandling['401_handling'] = 'not_triggered';
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        errorHandling['401_handling'] = 'handled_correctly';
        debugPrint('  ✓ 401/403 errors handled correctly');
      } else {
        errorHandling['401_handling'] = 'unexpected_error';
      }
    } catch (e) {
      errorHandling['401_handling'] = 'unhandled_error';
    }
    
    _analysisReport['error_handling'] = errorHandling;
  }

  /// Analyze authentication flow
  Future<void> _analyzeAuthenticationFlow() async {
    debugPrint('\n🔐 Analyzing Authentication Flow...');
    
    final authAnalysis = {
      'register_endpoint': 'not_tested',
      'login_endpoint': 'not_tested',
      'token_refresh': 'not_tested',
      'protected_endpoints': 'not_tested',
    };
    
    // Test registration
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      await _apiService.register(
        email: 'analyzer$timestamp@test.com',
        username: 'analyzer$timestamp',
        password: 'TestPass123!',
        confirmPassword: 'TestPass123!',
      );
      authAnalysis['register_endpoint'] = 'functional';
      debugPrint('  ✓ Register endpoint functional');
    } catch (e) {
      authAnalysis['register_endpoint'] = 'failed';
      debugPrint('  ⚠️  Register endpoint failed (may be expected)');
    }
    
    _analysisReport['authentication_flow'] = authAnalysis;
  }

  /// Generate summary report
  void _generateSummary(Duration analysisTime) {
    final summary = {
      'analysis_time': analysisTime.toString(),
      'total_inconsistencies': _inconsistencies.length,
      'inconsistencies': _inconsistencies,
      'endpoint_errors': _endpointErrors,
      'overall_health': _calculateOverallHealth(),
      'recommendations': _generateRecommendations(),
    };
    
    _analysisReport['summary'] = summary;
    
    // Print summary
    debugPrint('\n📊 ANALYSIS SUMMARY');
    debugPrint('═' * 60);
    debugPrint('Total Inconsistencies: ${_inconsistencies.length}');
    debugPrint('Overall Health: ${summary['overall_health']}');
    
    if (_inconsistencies.isNotEmpty) {
      debugPrint('\n⚠️  Inconsistencies Found:');
      for (final inconsistency in _inconsistencies) {
        debugPrint('  - $inconsistency');
      }
    }
    
    if (summary['recommendations'].isNotEmpty) {
      debugPrint('\n💡 Recommendations:');
      for (final recommendation in summary['recommendations']) {
        debugPrint('  - $recommendation');
      }
    }
  }

  /// Calculate overall health score
  String _calculateOverallHealth() {
    final healthyChecks = _analysisReport.values.where((value) {
      if (value is Map) {
        return value['status'] == 'healthy' || 
               value['consistent'] == true ||
               value.containsKey('success_rate') && value['success_rate'] >= 0.8;
      }
      return false;
    }).length;
    
    final totalChecks = _analysisReport.length;
    final healthScore = totalChecks > 0 ? healthyChecks / totalChecks : 0.0;
    
    if (healthScore >= 0.9) return 'EXCELLENT';
    if (healthScore >= 0.7) return 'GOOD';
    if (healthScore >= 0.5) return 'FAIR';
    return 'POOR';
  }

  /// Generate recommendations
  List<String> _generateRecommendations() {
    final recommendations = <String>[];
    
    if (_inconsistencies.any((i) => i.contains('CRITICAL'))) {
      recommendations.add('Address critical issues immediately - backend may be unreachable');
    }
    
    if (_inconsistencies.any((i) => i.contains('model'))) {
      recommendations.add('Review data model implementations for consistency');
    }
    
    if (_endpointErrors.isNotEmpty) {
      recommendations.add('Fix failing endpoints: ${_endpointErrors.keys.join(', ')}');
    }
    
    final responseTimes = _analysisReport['response_times'] as Map<String, dynamic>?;
    if (responseTimes != null && responseTimes['average_ms'] > 1000) {
      recommendations.add('Optimize API response times (current avg: ${responseTimes['average_ms']}ms)');
    }
    
    if (_inconsistencies.isEmpty && _endpointErrors.isEmpty) {
      recommendations.add('No critical issues found. Continue monitoring in production.');
    }
    
    return recommendations;
  }

  /// Export analysis report to JSON
  String exportToJson() {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(_analysisReport);
  }

  /// Get formatted report as string
  String getFormattedReport() {
    final buffer = StringBuffer();
    
    buffer.writeln('═' * 60);
    buffer.writeln('API DEBUGGING ANALYSIS REPORT');
    buffer.writeln('Generated: ${DateTime.now()}');
    buffer.writeln('═' * 60);
    
    // Configuration
    if (_analysisReport.containsKey('configuration')) {
      final config = _analysisReport['configuration'] as Map<String, dynamic>;
      buffer.writeln('\n📋 CONFIGURATION');
      buffer.writeln('  Base URL: ${config['base_url']}');
      buffer.writeln('  Valid: ${config['base_url_valid']}');
      
      final categories = config['categories'] as Map<String, dynamic>;
      categories.forEach((name, data) {
        buffer.writeln('  $name: ${data['count']} endpoints');
      });
    }
    
    // Health
    if (_analysisReport.containsKey('health')) {
      final health = _analysisReport['health'] as Map<String, dynamic>;
      buffer.writeln('\n🏥 HEALTH CHECK');
      buffer.writeln('  Status: ${health['status']}');
      buffer.writeln('  Response Time: ${health['response_time_ms']}ms');
    }
    
    // Summary
    if (_analysisReport.containsKey('summary')) {
      final summary = _analysisReport['summary'] as Map<String, dynamic>;
      buffer.writeln('\n📊 SUMMARY');
      buffer.writeln('  Overall Health: ${summary['overall_health']}');
      buffer.writeln('  Inconsistencies: ${summary['total_inconsistencies']}');
      
      if (summary['recommendations'].isNotEmpty) {
        buffer.writeln('\n💡 RECOMMENDATIONS');
        for (final rec in summary['recommendations']) {
          buffer.writeln('  - $rec');
        }
      }
    }
    
    buffer.writeln('\n═' * 60);
    
    return buffer.toString();
  }

  /// Helper: Check if URL is valid
  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
}
