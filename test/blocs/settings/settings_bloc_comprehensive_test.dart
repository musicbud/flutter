/// Comprehensive SettingsBloc Unit Tests
/// 
/// Tests all settings functionality including:
/// - Settings loading
/// - Notification settings updates
/// - Privacy settings updates
/// - Theme and language settings
/// - Service connections (Spotify, YTMusic, Last.FM, MAL)
/// - Likes updates
/// - Service login URL retrieval
/// - Error handling
/// - Edge cases

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:musicbud_flutter/blocs/settings/settings_bloc.dart';
import 'package:musicbud_flutter/blocs/settings/settings_event.dart';
import 'package:musicbud_flutter/blocs/settings/settings_state.dart';
import 'package:musicbud_flutter/domain/repositories/settings_repository.dart';
import 'package:musicbud_flutter/domain/repositories/auth_repository.dart';
import 'package:musicbud_flutter/domain/repositories/user_profile_repository.dart';

@GenerateMocks([SettingsRepository, AuthRepository, UserProfileRepository])
import 'settings_bloc_comprehensive_test.mocks.dart';

void main() {
  group('SettingsBloc', () {
    late SettingsBloc settingsBloc;
    late MockSettingsRepository mockSettingsRepository;
    late MockAuthRepository mockAuthRepository;
    late MockUserProfileRepository mockUserProfileRepository;

    // Test data
    final testSettings = {
      'notifications': {
        'enabled': true,
        'push_enabled': true,
        'email_enabled': false,
        'sound_enabled': true,
      },
      'privacy': {
        'profile_visible': true,
        'location_visible': false,
        'activity_visible': true,
      },
      'theme': 'dark',
      'language_code': 'en',
    };

    final testNotificationSettings = const NotificationSettings(
      enabled: true,
      pushEnabled: true,
      emailEnabled: false,
      soundEnabled: true,
    );

    final testPrivacySettings = const PrivacySettings(
      profileVisible: true,
      locationVisible: false,
      activityVisible: true,
    );

    setUp(() {
      mockSettingsRepository = MockSettingsRepository();
      mockAuthRepository = MockAuthRepository();
      mockUserProfileRepository = MockUserProfileRepository();
      settingsBloc = SettingsBloc(
        settingsRepository: mockSettingsRepository,
        authRepository: mockAuthRepository,
        userProfileRepository: mockUserProfileRepository,
      );
    });

    tearDown(() {
      settingsBloc.close();
    });

    test('initial state is SettingsInitial', () {
      expect(settingsBloc.state, equals(SettingsInitial()));
    });

    group('Settings Loading', () {
      blocTest<SettingsBloc, SettingsState>(
        'emits [SettingsLoading, SettingsLoaded] when SettingsRequested succeeds',
        build: () {
          when(mockSettingsRepository.getSettings()).thenAnswer(
            (_) async => testSettings,
          );
          return settingsBloc;
        },
        act: (bloc) => bloc.add(SettingsRequested()),
        expect: () => [
          SettingsLoading(),
          SettingsLoaded(
            notifications: testNotificationSettings,
            privacy: testPrivacySettings,
            theme: 'dark',
            languageCode: 'en',
          ),
        ],
        verify: (_) {
          verify(mockSettingsRepository.getSettings()).called(1);
        },
      );

      blocTest<SettingsBloc, SettingsState>(
        'emits [SettingsLoading, SettingsLoaded] when LoadSettingsEvent succeeds',
        build: () {
          when(mockSettingsRepository.getSettings()).thenAnswer(
            (_) async => testSettings,
          );
          return settingsBloc;
        },
        act: (bloc) => bloc.add(LoadSettingsEvent()),
        expect: () => [
          SettingsLoading(),
          SettingsLoaded(
            notifications: testNotificationSettings,
            privacy: testPrivacySettings,
            theme: 'dark',
            languageCode: 'en',
          ),
        ],
      );

      blocTest<SettingsBloc, SettingsState>(
        'emits [SettingsLoading, SettingsFailure] when loading fails',
        build: () {
          when(mockSettingsRepository.getSettings()).thenThrow(
            Exception('Failed to load settings'),
          );
          return settingsBloc;
        },
        act: (bloc) => bloc.add(SettingsRequested()),
        expect: () => [
          SettingsLoading(),
          isA<SettingsFailure>().having(
            (state) => state.error,
            'error message',
            contains('Failed to load settings'),
          ),
        ],
      );

      blocTest<SettingsBloc, SettingsState>(
        'handles network timeout',
        build: () {
          when(mockSettingsRepository.getSettings()).thenThrow(
            Exception('Network timeout'),
          );
          return settingsBloc;
        },
        act: (bloc) => bloc.add(SettingsRequested()),
        expect: () => [
          SettingsLoading(),
          isA<SettingsFailure>().having(
            (state) => state.error,
            'timeout error',
            contains('Network timeout'),
          ),
        ],
      );
    });

    group('Notification Settings', () {
      blocTest<SettingsBloc, SettingsState>(
        'updates notification settings successfully',
        build: () {
          when(mockSettingsRepository.updateNotificationSettings(any))
              .thenAnswer((_) async => {});
          return settingsBloc;
        },
        seed: () => SettingsLoaded(
          notifications: testNotificationSettings,
          privacy: testPrivacySettings,
          theme: 'dark',
          languageCode: 'en',
        ),
        act: (bloc) => bloc.add(
          const NotificationSettingsUpdated(
            enabled: false,
            pushEnabled: false,
            emailEnabled: true,
            soundEnabled: false,
          ),
        ),
        expect: () => [
          isA<SettingsLoaded>().having(
            (state) => state.notifications.enabled,
            'notifications enabled',
            false,
          ),
        ],
        verify: (_) {
          verify(mockSettingsRepository.updateNotificationSettings(any))
              .called(1);
        },
      );

      blocTest<SettingsBloc, SettingsState>(
        'updates via UpdateNotificationSettingsEvent',
        build: () {
          when(mockSettingsRepository.updateNotificationSettings(any))
              .thenAnswer((_) async => {});
          return settingsBloc;
        },
        seed: () => SettingsLoaded(
          notifications: testNotificationSettings,
          privacy: testPrivacySettings,
          theme: 'dark',
          languageCode: 'en',
        ),
        act: (bloc) => bloc.add(
          const UpdateNotificationSettingsEvent(
            enabled: true,
            pushEnabled: false,
            emailEnabled: true,
            soundEnabled: true,
          ),
        ),
        expect: () => [
          isA<SettingsLoaded>().having(
            (state) => state.notifications.pushEnabled,
            'push enabled',
            false,
          ),
        ],
      );

      blocTest<SettingsBloc, SettingsState>(
        'handles notification settings update failure',
        build: () {
          when(mockSettingsRepository.updateNotificationSettings(any))
              .thenThrow(Exception('Update failed'));
          return settingsBloc;
        },
        seed: () => SettingsLoaded(
          notifications: testNotificationSettings,
          privacy: testPrivacySettings,
          theme: 'dark',
          languageCode: 'en',
        ),
        act: (bloc) => bloc.add(
          const NotificationSettingsUpdated(
            enabled: false,
            pushEnabled: false,
            emailEnabled: false,
            soundEnabled: false,
          ),
        ),
        expect: () => [
          isA<SettingsFailure>().having(
            (state) => state.error,
            'error message',
            contains('Update failed'),
          ),
        ],
      );

      blocTest<SettingsBloc, SettingsState>(
        'enables all notification settings',
        build: () {
          when(mockSettingsRepository.updateNotificationSettings(any))
              .thenAnswer((_) async => {});
          return settingsBloc;
        },
        seed: () => SettingsLoaded(
          notifications: const NotificationSettings(
            enabled: false,
            pushEnabled: false,
            emailEnabled: false,
            soundEnabled: false,
          ),
          privacy: testPrivacySettings,
          theme: 'dark',
          languageCode: 'en',
        ),
        act: (bloc) => bloc.add(
          const NotificationSettingsUpdated(
            enabled: true,
            pushEnabled: true,
            emailEnabled: true,
            soundEnabled: true,
          ),
        ),
        expect: () => [
          isA<SettingsLoaded>().having(
            (state) => state.notifications.enabled &&
                state.notifications.pushEnabled &&
                state.notifications.emailEnabled &&
                state.notifications.soundEnabled,
            'all enabled',
            true,
          ),
        ],
      );
    });

    group('Privacy Settings', () {
      blocTest<SettingsBloc, SettingsState>(
        'updates privacy settings successfully',
        build: () {
          when(mockSettingsRepository.updatePrivacySettings(any))
              .thenAnswer((_) async => {});
          return settingsBloc;
        },
        seed: () => SettingsLoaded(
          notifications: testNotificationSettings,
          privacy: testPrivacySettings,
          theme: 'dark',
          languageCode: 'en',
        ),
        act: (bloc) => bloc.add(
          const PrivacySettingsUpdated(
            profileVisible: false,
            locationVisible: true,
            activityVisible: false,
          ),
        ),
        expect: () => [
          isA<SettingsLoaded>().having(
            (state) => state.privacy.profileVisible,
            'profile visible',
            false,
          ),
        ],
        verify: (_) {
          verify(mockSettingsRepository.updatePrivacySettings(any)).called(1);
        },
      );

      blocTest<SettingsBloc, SettingsState>(
        'updates via UpdatePrivacySettingsEvent',
        build: () {
          when(mockSettingsRepository.updatePrivacySettings(any))
              .thenAnswer((_) async => {});
          return settingsBloc;
        },
        seed: () => SettingsLoaded(
          notifications: testNotificationSettings,
          privacy: testPrivacySettings,
          theme: 'dark',
          languageCode: 'en',
        ),
        act: (bloc) => bloc.add(
          const UpdatePrivacySettingsEvent(
            profileVisible: true,
            locationVisible: true,
            activityVisible: true,
          ),
        ),
        expect: () => [
          isA<SettingsLoaded>().having(
            (state) => state.privacy.locationVisible,
            'location visible',
            true,
          ),
        ],
      );

      blocTest<SettingsBloc, SettingsState>(
        'handles privacy settings update failure',
        build: () {
          when(mockSettingsRepository.updatePrivacySettings(any))
              .thenThrow(Exception('Privacy update failed'));
          return settingsBloc;
        },
        seed: () => SettingsLoaded(
          notifications: testNotificationSettings,
          privacy: testPrivacySettings,
          theme: 'dark',
          languageCode: 'en',
        ),
        act: (bloc) => bloc.add(
          const PrivacySettingsUpdated(
            profileVisible: false,
            locationVisible: false,
            activityVisible: false,
          ),
        ),
        expect: () => [
          isA<SettingsFailure>().having(
            (state) => state.error,
            'error message',
            contains('Privacy update failed'),
          ),
        ],
      );

      blocTest<SettingsBloc, SettingsState>(
        'makes all privacy settings private',
        build: () {
          when(mockSettingsRepository.updatePrivacySettings(any))
              .thenAnswer((_) async => {});
          return settingsBloc;
        },
        seed: () => SettingsLoaded(
          notifications: testNotificationSettings,
          privacy: const PrivacySettings(
            profileVisible: true,
            locationVisible: true,
            activityVisible: true,
          ),
          theme: 'dark',
          languageCode: 'en',
        ),
        act: (bloc) => bloc.add(
          const PrivacySettingsUpdated(
            profileVisible: false,
            locationVisible: false,
            activityVisible: false,
          ),
        ),
        expect: () => [
          isA<SettingsLoaded>().having(
            (state) => !state.privacy.profileVisible &&
                !state.privacy.locationVisible &&
                !state.privacy.activityVisible,
            'all private',
            true,
          ),
        ],
      );
    });

    group('Theme Settings', () {
      blocTest<SettingsBloc, SettingsState>(
        'updates theme to light',
        build: () {
          when(mockSettingsRepository.updateTheme(any))
              .thenAnswer((_) async => {});
          return settingsBloc;
        },
        seed: () => SettingsLoaded(
          notifications: testNotificationSettings,
          privacy: testPrivacySettings,
          theme: 'dark',
          languageCode: 'en',
        ),
        act: (bloc) => bloc.add(const ThemeSettingUpdated('light')),
        expect: () => [
          isA<SettingsLoaded>().having(
            (state) => state.theme,
            'theme',
            'light',
          ),
        ],
        verify: (_) {
          verify(mockSettingsRepository.updateTheme('light')).called(1);
        },
      );

      blocTest<SettingsBloc, SettingsState>(
        'updates theme to system',
        build: () {
          when(mockSettingsRepository.updateTheme(any))
              .thenAnswer((_) async => {});
          return settingsBloc;
        },
        seed: () => SettingsLoaded(
          notifications: testNotificationSettings,
          privacy: testPrivacySettings,
          theme: 'dark',
          languageCode: 'en',
        ),
        act: (bloc) => bloc.add(const UpdateThemeEvent('system')),
        expect: () => [
          isA<SettingsLoaded>().having(
            (state) => state.theme,
            'theme',
            'system',
          ),
        ],
      );

      blocTest<SettingsBloc, SettingsState>(
        'handles theme update failure',
        build: () {
          when(mockSettingsRepository.updateTheme(any))
              .thenThrow(Exception('Theme update failed'));
          return settingsBloc;
        },
        seed: () => SettingsLoaded(
          notifications: testNotificationSettings,
          privacy: testPrivacySettings,
          theme: 'dark',
          languageCode: 'en',
        ),
        act: (bloc) => bloc.add(const ThemeSettingUpdated('light')),
        expect: () => [
          isA<SettingsFailure>().having(
            (state) => state.error,
            'error message',
            contains('Theme update failed'),
          ),
        ],
      );
    });

    group('Language Settings', () {
      blocTest<SettingsBloc, SettingsState>(
        'updates language successfully',
        build: () {
          when(mockSettingsRepository.updateLanguage(any))
              .thenAnswer((_) async => {});
          return settingsBloc;
        },
        seed: () => SettingsLoaded(
          notifications: testNotificationSettings,
          privacy: testPrivacySettings,
          theme: 'dark',
          languageCode: 'en',
        ),
        act: (bloc) => bloc.add(const LanguageSettingUpdated('es')),
        expect: () => [
          isA<SettingsLoaded>().having(
            (state) => state.languageCode,
            'language code',
            'es',
          ),
        ],
        verify: (_) {
          verify(mockSettingsRepository.updateLanguage('es')).called(1);
        },
      );

      blocTest<SettingsBloc, SettingsState>(
        'updates via UpdateLanguageEvent',
        build: () {
          when(mockSettingsRepository.updateLanguage(any))
              .thenAnswer((_) async => {});
          return settingsBloc;
        },
        seed: () => SettingsLoaded(
          notifications: testNotificationSettings,
          privacy: testPrivacySettings,
          theme: 'dark',
          languageCode: 'en',
        ),
        act: (bloc) => bloc.add(const UpdateLanguageEvent('fr')),
        expect: () => [
          isA<SettingsLoaded>().having(
            (state) => state.languageCode,
            'language code',
            'fr',
          ),
        ],
      );

      blocTest<SettingsBloc, SettingsState>(
        'handles language update failure',
        build: () {
          when(mockSettingsRepository.updateLanguage(any))
              .thenThrow(Exception('Language update failed'));
          return settingsBloc;
        },
        seed: () => SettingsLoaded(
          notifications: testNotificationSettings,
          privacy: testPrivacySettings,
          theme: 'dark',
          languageCode: 'en',
        ),
        act: (bloc) => bloc.add(const LanguageSettingUpdated('de')),
        expect: () => [
          isA<SettingsFailure>().having(
            (state) => state.error,
            'error message',
            contains('Language update failed'),
          ),
        ],
      );
    });

    group('Save Settings', () {
      blocTest<SettingsBloc, SettingsState>(
        'emits SettingsSaved',
        build: () => settingsBloc,
        act: (bloc) => bloc.add(SaveSettingsEvent()),
        expect: () => [
          SettingsSaved(),
        ],
      );
    });

    group('Service Connections', () {
      blocTest<SettingsBloc, SettingsState>(
        'connects Spotify successfully',
        build: () {
          when(mockAuthRepository.connectSpotify(any))
              .thenAnswer((_) async => {});
          return settingsBloc;
        },
        act: (bloc) => bloc.add(
          const ConnectSpotify(
            token: 'test_token',
            spotifyToken: 'spotify_token_123',
          ),
        ),
        expect: () => [
          const ServiceConnected('spotify'),
        ],
        verify: (_) {
          verify(mockAuthRepository.connectSpotify('spotify_token_123'))
              .called(1);
        },
      );

      blocTest<SettingsBloc, SettingsState>(
        'handles Spotify connection error',
        build: () {
          when(mockAuthRepository.connectSpotify(any))
              .thenThrow(Exception('Spotify connection failed'));
          return settingsBloc;
        },
        act: (bloc) => bloc.add(
          const ConnectSpotify(
            token: 'test_token',
            spotifyToken: 'invalid_token',
          ),
        ),
        expect: () => [
          isA<ServiceConnectionError>().having(
            (state) => state.service,
            'service',
            'spotify',
          ),
        ],
      );

      blocTest<SettingsBloc, SettingsState>(
        'connects YTMusic successfully',
        build: () {
          when(mockAuthRepository.connectYTMusic(any))
              .thenAnswer((_) async => {});
          return settingsBloc;
        },
        act: (bloc) => bloc.add(
          const ConnectYTMusic(
            token: 'test_token',
            ytmusicToken: 'ytmusic_token_123',
          ),
        ),
        expect: () => [
          const ServiceConnected('ytmusic'),
        ],
        verify: (_) {
          verify(mockAuthRepository.connectYTMusic('ytmusic_token_123'))
              .called(1);
        },
      );

      blocTest<SettingsBloc, SettingsState>(
        'connects LastFM successfully',
        build: () {
          when(mockAuthRepository.connectLastFM(any))
              .thenAnswer((_) async => {});
          return settingsBloc;
        },
        act: (bloc) => bloc.add(
          const ConnectLastFM(
            token: 'test_token',
            lastfmToken: 'lastfm_token_123',
          ),
        ),
        expect: () => [
          const ServiceConnected('lastfm'),
        ],
      );

      blocTest<SettingsBloc, SettingsState>(
        'connects MAL successfully',
        build: () {
          when(mockAuthRepository.connectMAL(any))
              .thenAnswer((_) async => {});
          return settingsBloc;
        },
        act: (bloc) => bloc.add(
          const ConnectMAL(
            token: 'test_token',
            malToken: 'mal_token_123',
          ),
        ),
        expect: () => [
          const ServiceConnected('mal'),
        ],
      );

      blocTest<SettingsBloc, SettingsState>(
        'handles YTMusic connection error',
        build: () {
          when(mockAuthRepository.connectYTMusic(any))
              .thenThrow(Exception('YTMusic connection failed'));
          return settingsBloc;
        },
        act: (bloc) => bloc.add(
          const ConnectYTMusic(
            token: 'test_token',
            ytmusicToken: 'invalid_token',
          ),
        ),
        expect: () => [
          isA<ServiceConnectionError>().having(
            (state) => state.service,
            'service',
            'ytmusic',
          ),
        ],
      );

      blocTest<SettingsBloc, SettingsState>(
        'handles LastFM connection error',
        build: () {
          when(mockAuthRepository.connectLastFM(any))
              .thenThrow(Exception('LastFM connection failed'));
          return settingsBloc;
        },
        act: (bloc) => bloc.add(
          const ConnectLastFM(
            token: 'test_token',
            lastfmToken: 'invalid_token',
          ),
        ),
        expect: () => [
          isA<ServiceConnectionError>().having(
            (state) => state.service,
            'service',
            'lastfm',
          ),
        ],
      );

      blocTest<SettingsBloc, SettingsState>(
        'handles MAL connection error',
        build: () {
          when(mockAuthRepository.connectMAL(any))
              .thenThrow(Exception('MAL connection failed'));
          return settingsBloc;
        },
        act: (bloc) => bloc.add(
          const ConnectMAL(
            token: 'test_token',
            malToken: 'invalid_token',
          ),
        ),
        expect: () => [
          isA<ServiceConnectionError>().having(
            (state) => state.service,
            'service',
            'mal',
          ),
        ],
      );
    });

    group('Likes Updates', () {
      blocTest<SettingsBloc, SettingsState>(
        'updates likes successfully',
        build: () {
          when(mockUserProfileRepository.updateLikes(any))
              .thenAnswer((_) async => {});
          return settingsBloc;
        },
        act: (bloc) => bloc.add(
          const UpdateLikes(
            service: 'spotify',
            token: 'spotify_token',
          ),
        ),
        expect: () => [
          const LikesUpdated('spotify'),
        ],
        verify: (_) {
          verify(mockUserProfileRepository.updateLikes(any)).called(1);
        },
      );

      blocTest<SettingsBloc, SettingsState>(
        'handles likes update error',
        build: () {
          when(mockUserProfileRepository.updateLikes(any))
              .thenThrow(Exception('Likes update failed'));
          return settingsBloc;
        },
        act: (bloc) => bloc.add(
          const UpdateLikes(
            service: 'spotify',
            token: 'invalid_token',
          ),
        ),
        expect: () => [
          isA<LikesUpdateError>().having(
            (state) => state.service,
            'service',
            'spotify',
          ),
        ],
      );

      blocTest<SettingsBloc, SettingsState>(
        'updates likes for multiple services',
        build: () {
          when(mockUserProfileRepository.updateLikes(any))
              .thenAnswer((_) async => {});
          return settingsBloc;
        },
        act: (bloc) async {
          bloc.add(const UpdateLikes(service: 'spotify', token: 'token1'));
          await Future.delayed(const Duration(milliseconds: 100));
          bloc.add(const UpdateLikes(service: 'lastfm', token: 'token2'));
        },
        expect: () => [
          const LikesUpdated('spotify'),
          const LikesUpdated('lastfm'),
        ],
        wait: const Duration(milliseconds: 300),
      );
    });

    group('Service Login URLs', () {
      blocTest<SettingsBloc, SettingsState>(
        'gets Spotify login URL successfully',
        build: () {
          when(mockAuthRepository.getServiceLoginUrl('spotify'))
              .thenAnswer((_) async => 'https://spotify.com/auth');
          return settingsBloc;
        },
        act: (bloc) => bloc.add(const GetServiceLoginUrl('spotify')),
        expect: () => [
          const ServiceLoginUrlReceived('spotify', 'https://spotify.com/auth'),
        ],
        verify: (_) {
          verify(mockAuthRepository.getServiceLoginUrl('spotify')).called(1);
        },
      );

      blocTest<SettingsBloc, SettingsState>(
        'handles login URL retrieval error',
        build: () {
          when(mockAuthRepository.getServiceLoginUrl('spotify'))
              .thenThrow(Exception('Failed to get URL'));
          return settingsBloc;
        },
        act: (bloc) => bloc.add(const GetServiceLoginUrl('spotify')),
        expect: () => [
          isA<ServiceLoginUrlError>().having(
            (state) => state.service,
            'service',
            'spotify',
          ),
        ],
      );

      blocTest<SettingsBloc, SettingsState>(
        'gets login URLs for multiple services',
        build: () {
          when(mockAuthRepository.getServiceLoginUrl('spotify'))
              .thenAnswer((_) async => 'https://spotify.com/auth');
          when(mockAuthRepository.getServiceLoginUrl('ytmusic'))
              .thenAnswer((_) async => 'https://ytmusic.com/auth');
          return settingsBloc;
        },
        act: (bloc) async {
          bloc.add(const GetServiceLoginUrl('spotify'));
          await Future.delayed(const Duration(milliseconds: 50));
          bloc.add(const GetServiceLoginUrl('ytmusic'));
        },
        expect: () => [
          const ServiceLoginUrlReceived('spotify', 'https://spotify.com/auth'),
          const ServiceLoginUrlReceived('ytmusic', 'https://ytmusic.com/auth'),
        ],
        wait: const Duration(milliseconds: 200),
      );
    });

    group('Edge Cases', () {
      blocTest<SettingsBloc, SettingsState>(
        'handles update when not in SettingsLoaded state',
        build: () => settingsBloc,
        act: (bloc) => bloc.add(
          const NotificationSettingsUpdated(
            enabled: true,
            pushEnabled: true,
            emailEnabled: true,
            soundEnabled: true,
          ),
        ),
        expect: () => [],
      );

      blocTest<SettingsBloc, SettingsState>(
        'handles malformed settings data',
        build: () {
          when(mockSettingsRepository.getSettings())
              .thenThrow(Exception('Malformed data'));
          return settingsBloc;
        },
        act: (bloc) => bloc.add(SettingsRequested()),
        expect: () => [
          SettingsLoading(),
          isA<SettingsFailure>().having(
            (state) => state.error,
            'error message',
            contains('Malformed data'),
          ),
        ],
      );

      blocTest<SettingsBloc, SettingsState>(
        'handles unauthorized access',
        build: () {
          when(mockSettingsRepository.getSettings())
              .thenThrow(Exception('Unauthorized'));
          return settingsBloc;
        },
        act: (bloc) => bloc.add(SettingsRequested()),
        expect: () => [
          SettingsLoading(),
          isA<SettingsFailure>().having(
            (state) => state.error,
            'error message',
            contains('Unauthorized'),
          ),
        ],
      );

      blocTest<SettingsBloc, SettingsState>(
        'handles sequential updates',
        build: () {
          when(mockSettingsRepository.updateTheme(any))
              .thenAnswer((_) async => {});
          when(mockSettingsRepository.updateLanguage(any))
              .thenAnswer((_) async => {});
          return settingsBloc;
        },
        seed: () => SettingsLoaded(
          notifications: testNotificationSettings,
          privacy: testPrivacySettings,
          theme: 'dark',
          languageCode: 'en',
        ),
        act: (bloc) async {
          bloc.add(const ThemeSettingUpdated('light'));
          await Future.delayed(const Duration(milliseconds: 50));
          bloc.add(const LanguageSettingUpdated('es'));
        },
        expect: () => [
          isA<SettingsLoaded>().having(
            (state) => state.theme,
            'theme',
            'light',
          ),
          isA<SettingsLoaded>().having(
            (state) => state.languageCode,
            'language',
            'es',
          ),
        ],
        wait: const Duration(milliseconds: 200),
      );
    });
  });
}
