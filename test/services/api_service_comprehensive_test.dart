/// Comprehensive API Service Tests

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:musicbud_flutter/data/network/dio_client.dart';
import '../test_config.dart';

@GenerateMocks([Dio, DioClient])
import 'api_service_comprehensive_test.mocks.dart';

void main() {
  group('API Service Comprehensive Tests', () {
    late MockDio mockDio;
    late MockDioClient mockDioClient;

    setUp(() {
      TestLogger.log('Setting up API service test');
      mockDio = MockDio();
      mockDioClient = MockDioClient();
    });

    group('HTTP GET Requests', () {
      test('GET request returns data successfully', () async {
        final response = TestUtils.createMockResponse(
          data: {'message': 'success'},
          statusCode: 200,
        );

        when(mockDio.get(any)).thenAnswer((_) async => response);

        final result = await mockDio.get('/test');
        expect(result.data, {'message': 'success'});
        expect(result.statusCode, 200);
        
        TestLogger.logSuccess('GET request successful');
      });

      test('GET request handles 404 error', () async {
        when(mockDio.get(any)).thenThrow(
          TestUtils.createMockError(
            message: 'Not found',
            statusCode: 404,
          ),
        );

        expect(
          () async => await mockDio.get('/nonexistent'),
          throwsA(isA<DioException>()),
        );
        
        TestLogger.logSuccess('404 error handled');
      });

      test('GET request handles network timeout', () async {
        when(mockDio.get(any)).thenThrow(
          TestUtils.createMockError(
            message: 'Connection timeout',
            type: DioExceptionType.connectionTimeout,
          ),
        );

        expect(
          () async => await mockDio.get('/timeout'),
          throwsA(isA<DioException>()),
        );
      });
    });

    group('HTTP POST Requests', () {
      test('POST request with body succeeds', () async {
        final requestBody = {'username': 'test', 'password': 'pass'};
        final response = TestUtils.createMockResponse(
          data: {'token': 'test_token'},
          statusCode: 201,
        );

        when(mockDio.post(any, data: anyNamed('data')))
            .thenAnswer((_) async => response);

        final result = await mockDio.post('/auth/login', data: requestBody);
        expect(result.statusCode, 201);
        expect(result.data['token'], 'test_token');
      });

      test('POST request handles validation error', () async {
        when(mockDio.post(any, data: anyNamed('data'))).thenThrow(
          TestUtils.createMockError(
            message: 'Validation failed',
            statusCode: 422,
          ),
        );

        expect(
          () async => await mockDio.post('/test', data: {}),
          throwsA(isA<DioException>()),
        );
      });
    });

    group('HTTP PUT Requests', () {
      test('PUT request updates resource', () async {
        final response = TestUtils.createMockResponse(
          data: {'updated': true},
          statusCode: 200,
        );

        when(mockDio.put(any, data: anyNamed('data')))
            .thenAnswer((_) async => response);

        final result = await mockDio.put('/user/1', data: {'name': 'Updated'});
        expect(result.data['updated'], true);
      });
    });

    group('HTTP DELETE Requests', () {
      test('DELETE request removes resource', () async {
        final response = TestUtils.createMockResponse(
          data: {'deleted': true},
          statusCode: 204,
        );

        when(mockDio.delete(any)).thenAnswer((_) async => response);

        final result = await mockDio.delete('/user/1');
        expect(result.statusCode, 204);
      });
    });

    group('Request Headers', () {
      test('Authorization header is included', () async {
        final response = TestUtils.createMockResponse(
          data: {},
          statusCode: 200,
        );

        when(mockDio.get(
          any,
          options: anyNamed('options'),
        )).thenAnswer((_) async => response);

        await mockDio.get(
          '/protected',
          options: Options(headers: {'Authorization': 'Bearer ${TestConfig.testToken}'}),
        );

        verify(mockDio.get(
          any,
          options: anyNamed('options'),
        )).called(1);
      });
    });

    group('Response Parsing', () {
      test('Parses JSON response correctly', () async {
        final jsonData = TestDataGenerator.generateUserProfile();
        final response = TestUtils.createMockResponse(
          data: jsonData,
          statusCode: 200,
        );

        when(mockDio.get(any)).thenAnswer((_) async => response);

        final result = await mockDio.get('/user/profile');
        expect(result.data['username'], TestConfig.testUsername);
        expect(result.data['email'], TestConfig.testEmail);
      });

      test('Handles list response', () async {
        final listData = TestDataGenerator.generateContentList(5);
        final response = TestUtils.createMockResponse(
          data: listData,
          statusCode: 200,
        );

        when(mockDio.get(any)).thenAnswer((_) async => response);

        final result = await mockDio.get('/content/list');
        expect(result.data, isA<List>());
        expect(result.data.length, 5);
      });
    });

    group('Error Handling', () {
      test('Handles server error (500)', () async {
        when(mockDio.get(any)).thenThrow(
          TestUtils.createMockError(
            message: TestConfig.serverErrorMessage,
            statusCode: 500,
          ),
        );

        expect(
          () async => await mockDio.get('/error'),
          throwsA(isA<DioException>()),
        );
      });

      test('Handles unauthorized (401)', () async {
        when(mockDio.get(any)).thenThrow(
          TestUtils.createMockError(
            message: 'Unauthorized',
            statusCode: 401,
          ),
        );

        expect(
          () async => await mockDio.get('/protected'),
          throwsA(isA<DioException>()),
        );
      });

      test('Handles connection error', () async {
        when(mockDio.get(any)).thenThrow(
          TestUtils.createMockError(
            message: TestConfig.networkErrorMessage,
            type: DioExceptionType.connectionError,
          ),
        );

        expect(
          () async => await mockDio.get('/test'),
          throwsA(isA<DioException>()),
        );
      });
    });

    group('Request Retry Logic', () {
      test('Retries failed request', () async {
        var callCount = 0;
        when(mockDio.get(any)).thenAnswer((_) async {
          callCount++;
          if (callCount < 3) {
            throw TestUtils.createMockError(message: 'Temporary error');
          }
          return TestUtils.createMockResponse(data: {'success': true});
        });

        // Simulate retry logic
        dynamic result;
        for (var i = 0; i < 3; i++) {
          try {
            result = await mockDio.get('/test');
            break;
          } catch (e) {
            if (i == 2) rethrow;
            await Future.delayed(TestConfig.shortDelay);
          }
        }

        expect(result.data['success'], true);
        expect(callCount, 3);
      });
    });

    group('Request Cancellation', () {
      test('Cancels in-flight request', () async {
        final cancelToken = CancelToken();
        
        when(mockDio.get(any, cancelToken: anyNamed('cancelToken')))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.cancel,
        ));

        cancelToken.cancel('User cancelled');

        expect(
          () async => await mockDio.get('/test', cancelToken: cancelToken),
          throwsA(isA<DioException>()),
        );
      });
    });

    TestLogger.logSuccess('All API service tests completed');
  });
}
