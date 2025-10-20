/// Comprehensive ProfileBloc Unit Tests
/// 
/// Tests all profile functionality including:
/// - Profile loading
/// - Profile updating
/// - Avatar management
/// - Top items loading (tracks, artists, genres)
/// - Liked items loading
/// - Authentication checks
/// - Logout functionality
/// - Connected services
/// - Validation errors
/// - Edge cases

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musicbud_flutter/blocs/profile/profile_bloc.dart';
import 'package:musicbud_flutter/blocs/profile/profile_event.dart';
import 'package:musicbud_flutter/blocs/profile/profile_state.dart';
import 'package:musicbud_flutter/domain/repositories/user_profile_repository.dart';
import 'package:musicbud_flutter/domain/repositories/content_repository.dart';
import 'package:musicbud_flutter/domain/repositories/user_repository.dart';
import 'package:musicbud_flutter/models/user_profile.dart';

@GenerateMocks([UserProfileRepository, ContentRepository, UserRepository])
import 'profile_bloc_comprehensive_test.mocks.dart';

void main() {
  group('ProfileBloc', () {
    late ProfileBloc profileBloc;
    late MockUserProfileRepository mockUserProfileRepository;
    late MockContentRepository mockContentRepository;
    late MockUserRepository mockUserRepository;

    // Test data
    final testUserProfile = UserProfile(
      id: 'user_123',
      username: 'testuser',
      email: 'test@example.com',
      displayName: 'Test User',
      bio: 'Test bio',
      avatarUrl: 'https://example.com/avatar.jpg',
      isActive: true,
      isAuthenticated: true,
    );

    final testTracks = [
      {'id': 'track1', 'title': 'Track 1', 'artist': 'Artist 1'},
      {'id': 'track2', 'title': 'Track 2', 'artist': 'Artist 2'},
    ];

    final testArtists = [
      {'id': 'artist1', 'name': 'Artist 1'},
      {'id': 'artist2', 'name': 'Artist 2'},
    ];

    final testGenres = [
      {'id': 'genre1', 'name': 'Rock'},
      {'id': 'genre2', 'name': 'Pop'},
    ];

    setUp(() {
      mockUserProfileRepository = MockUserProfileRepository();
      mockContentRepository = MockContentRepository();
      mockUserRepository = MockUserRepository();
      profileBloc = ProfileBloc(
        userProfileRepository: mockUserProfileRepository,
        contentRepository: mockContentRepository,
        userRepository: mockUserRepository,
      );
    });

    tearDown(() {
      profileBloc.close();
    });

    test('initial state is ProfileInitial', () {
      expect(profileBloc.state, equals(ProfileInitial()));
    });

    group('Profile Loading', () {
      blocTest<ProfileBloc, ProfileState>(
        'emits [ProfileLoading, ProfileLoaded] when profile loaded successfully',
        build: () {
          when(mockUserRepository.getUserProfile()).thenAnswer(
            (_) async => testUserProfile,
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(ProfileRequested()),
        expect: () => [
          ProfileLoading(),
          ProfileLoaded(profile: testUserProfile),
        ],
        verify: (_) {
          verify(mockUserRepository.getUserProfile()).called(1);
        },
      );

      blocTest<ProfileBloc, ProfileState>(
        'emits [ProfileLoading, ProfileFailure] when profile load fails',
        build: () {
          when(mockUserRepository.getUserProfile()).thenThrow(
            Exception('Failed to load profile'),
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(ProfileRequested()),
        expect: () => [
          ProfileLoading(),
          isA<ProfileFailure>().having(
            (state) => state.error,
            'error message',
            contains('Failed to load profile'),
          ),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'handles network timeout',
        build: () {
          when(mockUserRepository.getUserProfile()).thenThrow(
            Exception('Network timeout'),
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(ProfileRequested()),
        expect: () => [
          ProfileLoading(),
          isA<ProfileFailure>().having(
            (state) => state.error,
            'error message',
            contains('Network timeout'),
          ),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'handles unauthorized access',
        build: () {
          when(mockUserRepository.getUserProfile()).thenThrow(
            Exception('Unauthorized'),
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(ProfileRequested()),
        expect: () => [
          ProfileLoading(),
          isA<ProfileFailure>().having(
            (state) => state.error,
            'error message',
            contains('Unauthorized'),
          ),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'GetProfile event loads profile successfully',
        build: () {
          when(mockUserRepository.getUserProfile()).thenAnswer(
            (_) async => testUserProfile,
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(GetProfile()),
        expect: () => [
          ProfileLoading(),
          ProfileLoaded(profile: testUserProfile),
        ],
      );
    });

    group('Profile Updates', () {
      blocTest<ProfileBloc, ProfileState>(
        'updates profile successfully',
        build: () {
          when(mockUserProfileRepository.updateProfile(any)).thenAnswer(
            (_) async => testUserProfile,
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(
          ProfileUpdateRequested({
            'first_name': 'Updated',
            'last_name': 'User',
            'bio': 'Updated bio',
          }),
        ),
        expect: () => [
          ProfileUpdateSuccess(profile: testUserProfile),
        ],
        verify: (_) {
          verify(mockUserProfileRepository.updateProfile(any)).called(1);
        },
      );

      blocTest<ProfileBloc, ProfileState>(
        'handles profile update failure',
        build: () {
          when(mockUserProfileRepository.updateProfile(any)).thenThrow(
            Exception('Update failed'),
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(
          ProfileUpdateRequested({
            'first_name': 'Updated',
            'last_name': 'User',
          }),
        ),
        expect: () => [
          isA<ProfileFailure>().having(
            (state) => state.error,
            'error message',
            contains('Update failed'),
          ),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'updates first name',
        build: () {
          final updatedProfile = testUserProfile.copyWith(
            displayName: 'NewName User',
          );
          when(mockUserProfileRepository.updateProfile(any)).thenAnswer(
            (_) async => updatedProfile,
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(
          ProfileUpdateRequested({
            'first_name': 'NewName',
          }),
        ),
        expect: () => [
          isA<ProfileUpdateSuccess>().having(
            (state) => state.profile.displayName,
            'updated display name',
            'NewName User',
          ),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'updates last name',
        build: () {
          when(mockUserProfileRepository.updateProfile(any)).thenAnswer(
            (_) async => testUserProfile,
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(
          ProfileUpdateRequested({
            'last_name': 'NewLastName',
          }),
        ),
        expect: () => [
          ProfileUpdateSuccess(profile: testUserProfile),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'updates birthday',
        build: () {
          when(mockUserProfileRepository.updateProfile(any)).thenAnswer(
            (_) async => testUserProfile,
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(
          ProfileUpdateRequested({
            'birthday': '1990-01-01',
          }),
        ),
        expect: () => [
          ProfileUpdateSuccess(profile: testUserProfile),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'updates gender',
        build: () {
          when(mockUserProfileRepository.updateProfile(any)).thenAnswer(
            (_) async => testUserProfile,
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(
          ProfileUpdateRequested({
            'gender': 'non-binary',
          }),
        ),
        expect: () => [
          ProfileUpdateSuccess(profile: testUserProfile),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'updates bio and interests',
        build: () {
          when(mockUserProfileRepository.updateProfile(any)).thenAnswer(
            (_) async => testUserProfile,
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(
          ProfileUpdateRequested({
            'bio': 'New bio text',
            'interests': ['music', 'anime', 'gaming'],
          }),
        ),
        expect: () => [
          ProfileUpdateSuccess(profile: testUserProfile),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'handles validation errors',
        build: () {
          when(mockUserProfileRepository.updateProfile(any)).thenThrow(
            Exception('Validation error: Bio too long'),
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(
          ProfileUpdateRequested({
            'bio': 'x' * 10000, // Very long bio
          }),
        ),
        expect: () => [
          isA<ProfileFailure>().having(
            (state) => state.error,
            'validation error',
            contains('Validation error'),
          ),
        ],
      );
    });

    group('Avatar Management', () {
      blocTest<ProfileBloc, ProfileState>(
        'avatar update returns not implemented error',
        build: () => profileBloc,
        act: (bloc) => bloc.add(
          ProfileAvatarUpdateRequested(
            XFile('path/to/image.jpg'),
          ),
        ),
        expect: () => [
          isA<ProfileFailure>().having(
            (state) => state.error,
            'not implemented',
            contains('not implemented'),
          ),
        ],
      );
    });

    group('Top Items Loading', () {
      blocTest<ProfileBloc, ProfileState>(
        'loads top tracks successfully',
        build: () {
          when(mockContentRepository.getTopItems('tracks')).thenAnswer(
            (_) async => testTracks,
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(TopTracksRequested()),
        expect: () => [
          ProfileLoading(),
          TopTracksLoaded(tracks: testTracks),
        ],
        verify: (_) {
          verify(mockContentRepository.getTopItems('tracks')).called(1);
        },
      );

      blocTest<ProfileBloc, ProfileState>(
        'loads top artists successfully',
        build: () {
          when(mockContentRepository.getTopItems('artists')).thenAnswer(
            (_) async => testArtists,
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(TopArtistsRequested()),
        expect: () => [
          ProfileLoading(),
          TopArtistsLoaded(artists: testArtists),
        ],
        verify: (_) {
          verify(mockContentRepository.getTopItems('artists')).called(1);
        },
      );

      blocTest<ProfileBloc, ProfileState>(
        'loads top genres successfully',
        build: () {
          when(mockContentRepository.getTopItems('genres')).thenAnswer(
            (_) async => testGenres,
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(TopGenresRequested()),
        expect: () => [
          ProfileLoading(),
          TopGenresLoaded(genres: testGenres),
        ],
        verify: (_) {
          verify(mockContentRepository.getTopItems('genres')).called(1);
        },
      );

      blocTest<ProfileBloc, ProfileState>(
        'handles empty top items',
        build: () {
          when(mockContentRepository.getTopItems('tracks')).thenAnswer(
            (_) async => [],
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(TopTracksRequested()),
        expect: () => [
          ProfileLoading(),
          isA<TopTracksLoaded>().having(
            (state) => state.tracks,
            'empty tracks',
            isEmpty,
          ),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'uses ProfileTopItemsRequested with category',
        build: () {
          when(mockContentRepository.getTopItems('tracks')).thenAnswer(
            (_) async => testTracks,
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(ProfileTopItemsRequested('tracks')),
        expect: () => [
          ProfileTopItemsLoaded(items: testTracks, category: 'tracks'),
        ],
      );
    });

    group('Liked Items Loading', () {
      blocTest<ProfileBloc, ProfileState>(
        'loads liked tracks successfully',
        build: () {
          when(mockContentRepository.getLikedItems('tracks')).thenAnswer(
            (_) async => testTracks,
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(LikedTracksRequested()),
        expect: () => [
          ProfileLoading(),
          LikedTracksLoaded(tracks: testTracks),
        ],
        verify: (_) {
          verify(mockContentRepository.getLikedItems('tracks')).called(1);
        },
      );

      blocTest<ProfileBloc, ProfileState>(
        'loads liked artists successfully',
        build: () {
          when(mockContentRepository.getLikedItems('artists')).thenAnswer(
            (_) async => testArtists,
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(LikedArtistsRequested()),
        expect: () => [
          ProfileLoading(),
          LikedArtistsLoaded(artists: testArtists),
        ],
        verify: (_) {
          verify(mockContentRepository.getLikedItems('artists')).called(1);
        },
      );

      blocTest<ProfileBloc, ProfileState>(
        'loads liked genres successfully',
        build: () {
          when(mockContentRepository.getLikedItems('genres')).thenAnswer(
            (_) async => testGenres,
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(LikedGenresRequested()),
        expect: () => [
          ProfileLoading(),
          LikedGenresLoaded(genres: testGenres),
        ],
        verify: (_) {
          verify(mockContentRepository.getLikedItems('genres')).called(1);
        },
      );

      blocTest<ProfileBloc, ProfileState>(
        'handles empty liked items',
        build: () {
          when(mockContentRepository.getLikedItems('tracks')).thenAnswer(
            (_) async => [],
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(LikedTracksRequested()),
        expect: () => [
          ProfileLoading(),
          isA<LikedTracksLoaded>().having(
            (state) => state.tracks,
            'empty tracks',
            isEmpty,
          ),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'uses ProfileLikedItemsRequested with category',
        build: () {
          when(mockContentRepository.getLikedItems('tracks')).thenAnswer(
            (_) async => testTracks,
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(ProfileLikedItemsRequested('tracks')),
        expect: () => [
          ProfileLikedItemsLoaded(items: testTracks, category: 'tracks'),
        ],
      );
    });

    group('Authentication & Session', () {
      blocTest<ProfileBloc, ProfileState>(
        'checks authentication status',
        build: () => profileBloc,
        act: (bloc) => bloc.add(ProfileAuthenticationChecked()),
        expect: () => [
          ProfileAuthenticationStatus(isAuthenticated: true),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'handles logout request',
        build: () => profileBloc,
        act: (bloc) => bloc.add(ProfileLogoutRequested()),
        expect: () => [
          ProfileLogoutSuccess(),
        ],
      );
    });

    group('Connected Services', () {
      blocTest<ProfileBloc, ProfileState>(
        'loads connected services list',
        build: () => profileBloc,
        act: (bloc) => bloc.add(ProfileConnectedServicesRequested()),
        expect: () => [
          ProfileConnectedServicesLoaded(services: const []),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'handles empty services',
        build: () => profileBloc,
        act: (bloc) => bloc.add(ProfileConnectedServicesRequested()),
        expect: () => [
          isA<ProfileConnectedServicesLoaded>().having(
            (state) => state.services,
            'empty services',
            isEmpty,
          ),
        ],
      );
    });

    group('Buds Loading', () {
      blocTest<ProfileBloc, ProfileState>(
        'loads buds by category',
        build: () => profileBloc,
        act: (bloc) => bloc.add(ProfileBudsRequested('liked/artists')),
        expect: () => [
          ProfileBudsLoaded(buds: const [], category: 'liked/artists'),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'handles empty buds list',
        build: () => profileBloc,
        act: (bloc) => bloc.add(ProfileBudsRequested('top/tracks')),
        expect: () => [
          isA<ProfileBudsLoaded>().having(
            (state) => state.buds,
            'empty buds',
            isEmpty,
          ),
        ],
      );
    });

    group('Edge Cases', () {
      blocTest<ProfileBloc, ProfileState>(
        'handles profile update successfully',
        build: () {
          when(mockUserProfileRepository.updateProfile(any)).thenAnswer(
            (_) async => testUserProfile,
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(
          ProfileUpdateRequested({'first_name': 'Updated'}),
        ),
        expect: () => [
          ProfileUpdateSuccess(profile: testUserProfile),
        ],
        verify: (_) {
          verify(mockUserProfileRepository.updateProfile(any)).called(1);
        },
      );

      blocTest<ProfileBloc, ProfileState>(
        'handles malformed profile data',
        build: () {
          when(mockUserRepository.getUserProfile()).thenThrow(
            Exception('Invalid data format'),
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(ProfileRequested()),
        expect: () => [
          ProfileLoading(),
          isA<ProfileFailure>().having(
            (state) => state.error,
            'format error',
            contains('Invalid data format'),
          ),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'handles very long bio text',
        build: () {
          final longBioProfile = testUserProfile.copyWith(
            bio: 'x' * 5000,
          );
          when(mockUserProfileRepository.updateProfile(any)).thenAnswer(
            (_) async => longBioProfile,
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(
          ProfileUpdateRequested({
            'bio': 'x' * 5000,
          }),
        ),
        expect: () => [
          isA<ProfileUpdateSuccess>().having(
            (state) => state.profile.bio?.length,
            'bio length',
            5000,
          ),
        ],
      );
    });

    group('Error Handling', () {
      blocTest<ProfileBloc, ProfileState>(
        'handles top tracks loading error',
        build: () {
          when(mockContentRepository.getTopItems('tracks')).thenThrow(
            Exception('Failed to load tracks'),
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(TopTracksRequested()),
        expect: () => [
          ProfileLoading(),
          isA<ProfileError>().having(
            (state) => state.message,
            'error message',
            contains('Failed to load tracks'),
          ),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'handles liked items loading error',
        build: () {
          when(mockContentRepository.getLikedItems('tracks')).thenThrow(
            Exception('Failed to load liked tracks'),
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(LikedTracksRequested()),
        expect: () => [
          ProfileLoading(),
          isA<ProfileError>().having(
            (state) => state.message,
            'error message',
            contains('Failed to load liked tracks'),
          ),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'handles top items request with category error',
        build: () {
          when(mockContentRepository.getTopItems('invalid')).thenThrow(
            Exception('Invalid category'),
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(ProfileTopItemsRequested('invalid')),
        expect: () => [
          isA<ProfileFailure>().having(
            (state) => state.error,
            'invalid category',
            contains('Invalid category'),
          ),
        ],
      );
    });

    group('Multiple Sequential Events', () {
      blocTest<ProfileBloc, ProfileState>(
        'handles loading profile then updating it',
        build: () {
          when(mockUserRepository.getUserProfile()).thenAnswer(
            (_) async => testUserProfile,
          );
          when(mockUserProfileRepository.updateProfile(any)).thenAnswer(
            (_) async => testUserProfile.copyWith(bio: 'Updated'),
          );
          return profileBloc;
        },
        act: (bloc) async {
          bloc.add(ProfileRequested());
          await Future.delayed(Duration(milliseconds: 100));
          bloc.add(ProfileUpdateRequested({'bio': 'Updated'}));
        },
        expect: () => [
          ProfileLoading(),
          ProfileLoaded(profile: testUserProfile),
          ProfileUpdateSuccess(profile: testUserProfile.copyWith(bio: 'Updated')),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'handles loading top items then liked items',
        build: () {
          when(mockContentRepository.getTopItems('tracks')).thenAnswer(
            (_) async => testTracks,
          );
          when(mockContentRepository.getLikedItems('tracks')).thenAnswer(
            (_) async => testTracks,
          );
          return profileBloc;
        },
        act: (bloc) async {
          bloc.add(TopTracksRequested());
          await Future.delayed(Duration(milliseconds: 100));
          bloc.add(LikedTracksRequested());
        },
        expect: () => [
          ProfileLoading(),
          TopTracksLoaded(tracks: testTracks),
          ProfileLoading(),
          LikedTracksLoaded(tracks: testTracks),
        ],
      );
    });
  });
}
