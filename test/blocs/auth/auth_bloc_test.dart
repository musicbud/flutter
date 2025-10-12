import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:musicbud_flutter/blocs/auth/auth_bloc.dart';
import 'package:musicbud_flutter/domain/repositories/auth_repository.dart';
import 'package:musicbud_flutter/data/providers/token_provider.dart';
import 'package:musicbud_flutter/core/error/failures.dart';
import 'package:musicbud_flutter/models/auth_response.dart';

@GenerateMocks([AuthRepository, TokenProvider])
import 'auth_bloc_test.mocks.dart';

void main() {
  group('AuthBloc Tests', () {
    late AuthBloc authBloc;
    late MockAuthRepository mockAuthRepository;
    late MockTokenProvider mockTokenProvider;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      mockTokenProvider = MockTokenProvider();
      authBloc = AuthBloc(
        authRepository: mockAuthRepository,
        tokenProvider: mockTokenProvider,
      );
    });

    tearDown(() {
      authBloc.close();
    });

    test('initial state is AuthInitial', () {
      expect(authBloc.state, AuthInitial());
    });

    group('LoginRequested', () {
      const username = 'testuser';
      const password = 'password123';
      const token = 'mock_token';

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, Authenticated] when login is successful',
        build: () {
          when(mockAuthRepository.login(username, password))
              .thenAnswer((_) async => const LoginResponse(accessToken: token, refreshToken: 'refresh_token'));
          when(mockTokenProvider.updateTokens(token, 'refresh_token'))
              .thenAnswer((_) async => {});
          return authBloc;
        },
        act: (bloc) => bloc.add(const LoginRequested(
          username: username,
          password: password,
        )),
        expect: () => [
          AuthLoading(),
          const Authenticated(token: token),
        ],
        verify: (_) {
          verify(mockAuthRepository.login(username, password))
              .called(1);
          verify(mockTokenProvider.updateTokens(token, 'refresh_token')).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when login fails',
        build: () {
          when(mockAuthRepository.login(username, password))
              .thenThrow(const ServerFailure(message: 'Invalid credentials'));
          return authBloc;
        },
        act: (bloc) => bloc.add(const LoginRequested(
          username: username,
          password: password,
        )),
        expect: () => [
          AuthLoading(),
          const AuthError('ServerFailure(Invalid credentials)'),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when login throws exception',
        build: () {
          when(mockAuthRepository.login(username, password))
              .thenThrow(Exception('Network error'));
          return authBloc;
        },
        act: (bloc) => bloc.add(const LoginRequested(
          username: username,
          password: password,
        )),
        expect: () => [
          AuthLoading(),
          const AuthError('Exception: Network error'),
        ],
      );
    });

    group('RegisterRequested', () {
      const email = 'test@example.com';
      const password = 'password123';
      const username = 'testuser';
      const token = 'mock_token';

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthSuccess] when registration is successful',
        build: () {
          when(mockAuthRepository.register(username, email, password))
              .thenAnswer((_) async => const RegisterResponse(message: 'Registration successful'));
          return authBloc;
        },
        act: (bloc) => bloc.add(const RegisterRequested(
          username: username,
          email: email,
          password: password,
        )),
        expect: () => [
          AuthLoading(),
          const AuthSuccess(),
        ],
        verify: (_) {
          verify(mockAuthRepository.register(username, email, password)).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when registration fails',
        build: () {
          when(mockAuthRepository.register(username, email, password))
              .thenThrow(const ServerFailure(message: 'Email already exists'));
          return authBloc;
        },
        act: (bloc) => bloc.add(const RegisterRequested(
          username: username,
          email: email,
          password: password,
        )),
        expect: () => [
          AuthLoading(),
          const AuthError('ServerFailure(Email already exists)'),
        ],
      );
    });

    group('LogoutRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, Unauthenticated] when logout is successful',
        build: () {
          when(mockAuthRepository.logout())
              .thenAnswer((_) async => {});
          when(mockTokenProvider.clearTokens())
              .thenAnswer((_) async => {});
          return authBloc;
        },
        act: (bloc) => bloc.add(LogoutRequested()),
        expect: () => [
          AuthLoading(),
          Unauthenticated(),
        ],
        verify: (_) {
          verify(mockAuthRepository.logout()).called(1);
          verify(mockTokenProvider.clearTokens()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when logout fails',
        build: () {
          when(mockAuthRepository.logout())
              .thenThrow(const ServerFailure(message: 'Logout failed'));
          return authBloc;
        },
        act: (bloc) => bloc.add(LogoutRequested()),
        expect: () => [
          AuthLoading(),
          Unauthenticated(),
        ],
      );
    });

    group('TokenRefreshRequested', () {
      const newToken = 'new_access_token';

      blocTest<AuthBloc, AuthState>(
        'emits [Authenticated] when token refresh is successful',
        build: () {
          when(mockAuthRepository.refreshToken())
              .thenAnswer((_) async => const TokenRefreshResponse(accessToken: newToken));
          when(mockTokenProvider.updateAccessToken(newToken))
              .thenAnswer((_) async => {});
          return authBloc;
        },
        act: (bloc) => bloc.add(TokenRefreshRequested()),
        expect: () => [
          AuthLoading(),
          const Authenticated(token: newToken),
        ],
        verify: (_) {
          verify(mockAuthRepository.refreshToken()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when token refresh fails',
        build: () {
          when(mockAuthRepository.refreshToken())
              .thenThrow(const ServerFailure(message: 'Token expired'));
          when(mockTokenProvider.clearTokens())
              .thenAnswer((_) async => {});
          return authBloc;
        },
        act: (bloc) => bloc.add(TokenRefreshRequested()),
        expect: () => [
          AuthLoading(),
          Unauthenticated(),
        ],
      );
    });

    // Add tests for remaining service-related events
    group('GetServiceAuthUrl', () {
      const service = 'spotify';
      const authUrl = 'https://accounts.spotify.com/authorize';

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, ServiceAuthUrlReceived] when service auth URL is requested',
        build: () {
          when(mockAuthRepository.getServiceAuthUrl())
              .thenAnswer((_) async => authUrl);
          return authBloc;
        },
        act: (bloc) => bloc.add(const GetServiceAuthUrl(service)),
        expect: () => [
          AuthLoading(),
          const ServiceAuthUrlReceived(service: service, url: authUrl),
        ],
      );
    });
    
    group('ConnectService', () {
      const service = 'spotify';
      const code = 'auth_code_123';

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading] when service connection is successful but user not authenticated',
        build: () {
          when(mockAuthRepository.connectSpotify(code))
              .thenAnswer((_) async => {});
          return authBloc;
        },
        act: (bloc) => bloc.add(const ConnectService(service: service, code: code)),
        expect: () => [
          AuthLoading(),
        ],
      );
    });
    
    group('RefreshServiceToken', () {
      const service = 'spotify';

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthSuccess] when service token refresh is successful',
        build: () {
          when(mockAuthRepository.refreshSpotifyToken())
              .thenAnswer((_) async => {});
          return authBloc;
        },
        act: (bloc) => bloc.add(const RefreshServiceToken(service)),
        expect: () => [
          AuthLoading(),
          const AuthSuccess(),
        ],
      );
    });
  });
}