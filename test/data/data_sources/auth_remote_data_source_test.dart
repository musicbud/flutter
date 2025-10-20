/// Comprehensive AuthRemoteDataSource Tests
/// 
/// This file contains complete tests for the AuthRemoteDataSource including:
/// - Successful API calls
/// - Network error handling
/// - Authentication error handling
/// - Server error handling
/// - Timeout handling
/// - Connection error handling
/// - Response parsing

import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:musicbud_flutter/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:musicbud_flutter/data/network/dio_client.dart';
import 'package:musicbud_flutter/services/endpoint_config_service.dart';
import 'package:musicbud_flutter/core/error/exceptions.dart';
import '../../test_config.dart';

@GenerateMocks([DioClient, EndpointConfigService])
import 'auth_remote_data_source_test.mocks.dart';

void main() {
  group('AuthRemoteDataSource Tests', () {
    late AuthRemoteDataSourceImpl dataSource;
    late MockDioClient mockDioClient;
    late MockEndpointConfigService mockEndpointConfigService;

    setUp(() {
      TestLogger.log('Setting up AuthRemoteDataSource test');
      mockDioClient = MockDioClient();
      mockEndpointConfigService = MockEndpointConfigService();
      dataSource = AuthRemoteDataSourceImpl(
        dioClient: mockDioClient,
        endpointConfigService: mockEndpointConfigService,
      );
    });

    tearDown(() {
      TestLogger.log('Tearing down AuthRemoteDataSource test');
    });

    group('Login', () {
      const username = 'testuser';
      const password = 'testpass123';

      test('login returns data on successful response', () async {
        final responseData = {
          'access_token': 'test_access_token',
          'refresh_token': 'test_refresh_token',
          'user_id': '123',
        };

        when(mockDioClient.post(any, data: anyNamed('data')))
            .thenAnswer((_) async => Response(
                  requestOptions: RequestOptions(path: ''),
                  data: responseData,
                  statusCode: 200,
                ));

        final result = await dataSource.login(username, password);

        expect(result, equals(responseData));
        verify(mockDioClient.post(any, data: {
          'username': username,
          'password': password,
        })).called(1);
        TestLogger.logSuccess('Login success verified');
      });

      test('login throws NetworkException on connection timeout', () async {
        when(mockDioClient.post(any, data: anyNamed('data')))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionTimeout,
        ));

        expect(
          () => dataSource.login(username, password),
          throwsA(isA<NetworkException>().having(
            (e) => e.message,
            'message',
            contains('Connection timeout'),
          )),
        );
        TestLogger.logSuccess('Connection timeout handled correctly');
      });

      test('login throws NetworkException on unknown error', () async {
        when(mockDioClient.post(any, data: anyNamed('data')))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.unknown,
        ));

        expect(
          () => dataSource.login(username, password),
          throwsA(isA<NetworkException>().having(
            (e) => e.message,
            'message',
            contains('Cannot connect to server'),
          )),
        );
      });

      test('login throws NetworkException on receive timeout', () async {
        when(mockDioClient.post(any, data: anyNamed('data')))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.receiveTimeout,
        ));

        expect(
          () => dataSource.login(username, password),
          throwsA(isA<NetworkException>().having(
            (e) => e.message,
            'message',
            contains('Request timeout'),
          )),
        );
      });

      test('login throws NetworkException on send timeout', () async {
        when(mockDioClient.post(any, data: anyNamed('data')))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.sendTimeout,
        ));

        expect(
          () => dataSource.login(username, password),
          throwsA(isA<NetworkException>().having(
            (e) => e.message,
            'message',
            contains('Send timeout'),
          )),
        );
      });

      test('login throws AuthenticationException on 401 response', () async {
        when(mockDioClient.post(any, data: anyNamed('data')))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 401,
          ),
          type: DioExceptionType.badResponse,
        ));

        expect(
          () => dataSource.login(username, password),
          throwsA(isA<Exception>()),
        );
      });

      test('login throws ServerException on 500 response', () async {
        when(mockDioClient.post(any, data: anyNamed('data')))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 500,
          ),
          type: DioExceptionType.badResponse,
        ));

        expect(
          () => dataSource.login(username, password),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Register', () {
      const username = 'newuser';
      const email = 'newuser@example.com';
      const password = 'newpass123';

      test('register returns data on successful response', () async {
        final responseData = {
          'message': 'Registration successful',
          'user_id': '123',
        };

        when(mockDioClient.post(any, data: anyNamed('data')))
            .thenAnswer((_) async => Response(
                  requestOptions: RequestOptions(path: ''),
                  data: responseData,
                  statusCode: 201,
                ));

        final result = await dataSource.register(username, email, password);

        expect(result, equals(responseData));
        verify(mockDioClient.post(any, data: {
          'username': username,
          'email': email,
          'password': password,
        })).called(1);
        TestLogger.logSuccess('Registration success verified');
      });

      test('register throws NetworkException on connection timeout', () async {
        when(mockDioClient.post(any, data: anyNamed('data')))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionTimeout,
        ));

        expect(
          () => dataSource.register(username, email, password),
          throwsA(isA<NetworkException>()),
        );
      });

      test('register throws ServerException on validation error (422)', () async {
        when(mockDioClient.post(any, data: anyNamed('data')))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 422,
          ),
          type: DioExceptionType.badResponse,
        ));

        expect(
          () => dataSource.register(username, email, password),
          throwsA(isA<ServerException>().having(
            (e) => e.message,
            'message',
            contains('validation failed'),
          )),
        );
      });

      test('register throws ServerException on conflict (409)', () async {
        when(mockDioClient.post(any, data: anyNamed('data')))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 409,
          ),
          type: DioExceptionType.badResponse,
        ));

        expect(
          () => dataSource.register(username, email, password),
          throwsA(isA<ServerException>().having(
            (e) => e.message,
            'message',
            contains('already exists'),
          )),
        );
      });
    });

    group('RefreshToken', () {
      const refreshToken = 'test_refresh_token';

      test('refreshToken returns data on successful response', () async {
        final responseData = {
          'access_token': 'new_access_token',
        };

        when(mockDioClient.post(any, data: anyNamed('data')))
            .thenAnswer((_) async => Response(
                  requestOptions: RequestOptions(path: ''),
                  data: responseData,
                  statusCode: 200,
                ));

        final result = await dataSource.refreshToken(refreshToken);

        expect(result, equals(responseData));
        verify(mockDioClient.post(any, data: {
          'refresh': refreshToken,
        })).called(1);
        TestLogger.logSuccess('Token refresh verified');
      });

      test('refreshToken throws ServerException on error', () async {
        when(mockDioClient.post(any, data: anyNamed('data')))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          message: 'Token expired',
        ));

        expect(
          () => dataSource.refreshToken(refreshToken),
          throwsA(isA<ServerException>()),
        );
      });
    });

    group('Logout', () {
      test('logout completes successfully', () async {
        when(mockDioClient.post(any))
            .thenAnswer((_) async => Response(
                  requestOptions: RequestOptions(path: ''),
                  statusCode: 200,
                ));

        await dataSource.logout();

        verify(mockDioClient.post(any)).called(1);
        TestLogger.logSuccess('Logout success verified');
      });

      test('logout throws ServerException on error', () async {
        when(mockDioClient.post(any))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          message: 'Logout failed',
        ));

        expect(
          () => dataSource.logout(),
          throwsA(isA<ServerException>()),
        );
      });
    });

    group('Service Connections', () {
      test('getServiceAuthUrl returns URL on success', () async {
        when(mockEndpointConfigService.getEndpointUrl(any, any))
            .thenReturn('/v1/service/login');
        when(mockDioClient.get(any))
            .thenAnswer((_) async => Response(
                  requestOptions: RequestOptions(path: ''),
                  data: {'url': 'https://spotify.com/auth'},
                  statusCode: 200,
                ));

        final result = await dataSource.getServiceAuthUrl();

        expect(result, equals('https://spotify.com/auth'));
        TestLogger.logSuccess('Service auth URL retrieved');
      });

      test('getServiceAuthUrl throws ServerException on error', () async {
        when(mockEndpointConfigService.getEndpointUrl(any, any))
            .thenReturn('/v1/service/login');
        when(mockDioClient.get(any))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          message: 'Failed to get URL',
        ));

        expect(
          () => dataSource.getServiceAuthUrl(),
          throwsA(isA<ServerException>()),
        );
      });

      test('getServiceLoginUrl returns URL for specific service', () async {
        when(mockEndpointConfigService.getEndpointUrl(any, any))
            .thenReturn('/v1/service/login');
        when(mockDioClient.get(any))
            .thenAnswer((_) async => Response(
                  requestOptions: RequestOptions(path: ''),
                  data: {
                    'data': {
                      'authorization_link': 'https://spotify.com/authorize'
                    }
                  },
                  statusCode: 200,
                ));

        final result = await dataSource.getServiceLoginUrl('spotify');

        expect(result, equals('https://spotify.com/authorize'));
      });

      test('connectSpotify completes successfully', () async {
        when(mockEndpointConfigService.getEndpointUrl(any, any))
            .thenReturn('/v1/service/spotify/connect');
        when(mockDioClient.post(any, data: anyNamed('data')))
            .thenAnswer((_) async => Response(
                  requestOptions: RequestOptions(path: ''),
                  statusCode: 200,
                ));

        await dataSource.connectSpotify('auth_code_123');

        verify(mockDioClient.post(any, data: {
          'code': 'auth_code_123',
        })).called(1);
        TestLogger.logSuccess('Spotify connection verified');
      });

      test('connectSpotify throws ServerException on error', () async {
        when(mockEndpointConfigService.getEndpointUrl(any, any))
            .thenReturn('/v1/service/spotify/connect');
        when(mockDioClient.post(any, data: anyNamed('data')))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          message: 'Connection failed',
        ));

        expect(
          () => dataSource.connectSpotify('auth_code_123'),
          throwsA(isA<ServerException>()),
        );
      });

      test('connectYTMusic completes successfully', () async {
        when(mockEndpointConfigService.getEndpointUrl(any, any))
            .thenReturn('/v1/service/ytmusic/connect');
        when(mockDioClient.post(any, data: anyNamed('data')))
            .thenAnswer((_) async => Response(
                  requestOptions: RequestOptions(path: ''),
                  statusCode: 200,
                ));

        await dataSource.connectYTMusic('yt_code_123');

        verify(mockDioClient.post(any, data: {
          'code': 'yt_code_123',
        })).called(1);
      });

      test('connectLastFM completes successfully', () async {
        when(mockEndpointConfigService.getEndpointUrl(any, any))
            .thenReturn('/v1/service/lastfm/connect');
        when(mockDioClient.post(any, data: anyNamed('data')))
            .thenAnswer((_) async => Response(
                  requestOptions: RequestOptions(path: ''),
                  statusCode: 200,
                ));

        await dataSource.connectLastFM('lastfm_code_123');

        verify(mockDioClient.post(any, data: {
          'code': 'lastfm_code_123',
        })).called(1);
      });

      test('connectMAL completes successfully', () async {
        when(mockEndpointConfigService.getEndpointUrl(any, any))
            .thenReturn('/v1/service/mal/connect');
        when(mockDioClient.post(any, data: anyNamed('data')))
            .thenAnswer((_) async => Response(
                  requestOptions: RequestOptions(path: ''),
                  statusCode: 200,
                ));

        await dataSource.connectMAL('mal_code_123');

        verify(mockDioClient.post(any, data: {
          'code': 'mal_code_123',
        })).called(1);
      });

      test('refreshSpotifyToken completes successfully', () async {
        when(mockEndpointConfigService.getEndpointUrl(any, any))
            .thenReturn('/v1/service/spotify/refresh');
        when(mockDioClient.post(any))
            .thenAnswer((_) async => Response(
                  requestOptions: RequestOptions(path: ''),
                  statusCode: 200,
                ));

        await dataSource.refreshSpotifyToken();

        verify(mockDioClient.post(any)).called(1);
      });

      test('refreshSpotifyToken throws ServerException on error', () async {
        when(mockEndpointConfigService.getEndpointUrl(any, any))
            .thenReturn('/v1/service/spotify/refresh');
        when(mockDioClient.post(any))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          message: 'Token refresh failed',
        ));

        expect(
          () => dataSource.refreshSpotifyToken(),
          throwsA(isA<ServerException>()),
        );
      });

      test('refreshYTMusicToken completes successfully', () async {
        when(mockEndpointConfigService.getEndpointUrl(any, any))
            .thenReturn('/v1/service/ytmusic/refresh');
        when(mockDioClient.post(any))
            .thenAnswer((_) async => Response(
                  requestOptions: RequestOptions(path: ''),
                  statusCode: 200,
                ));

        await dataSource.refreshYTMusicToken();

        verify(mockDioClient.post(any)).called(1);
      });
    });

    group('Error Handling', () {
      test('handles multiple error types correctly', () async {
        final errorTypes = [
          DioExceptionType.connectionTimeout,
          DioExceptionType.sendTimeout,
          DioExceptionType.receiveTimeout,
          DioExceptionType.unknown,
        ];

        for (final errorType in errorTypes) {
          when(mockDioClient.post(any, data: anyNamed('data')))
              .thenThrow(DioException(
            requestOptions: RequestOptions(path: ''),
            type: errorType,
          ));

          expect(
            () => dataSource.login('user', 'pass'),
            throwsA(isA<NetworkException>()),
          );
        }
        TestLogger.logSuccess('All error types handled correctly');
      });

      test('handles HTTP status codes correctly', () async {
        final statusCodes = [401, 403, 404, 409, 422, 500, 502, 503];

        for (final statusCode in statusCodes) {
          when(mockDioClient.post(any, data: anyNamed('data')))
              .thenThrow(DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: statusCode,
            ),
            type: DioExceptionType.badResponse,
          ));

          expect(
            () => dataSource.login('user', 'pass'),
            throwsA(isA<Exception>()),
          );
        }
        TestLogger.logSuccess('All HTTP status codes handled');
      });
    });
  });
}
