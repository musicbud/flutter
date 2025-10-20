/// Comprehensive UserBloc Tests
/// 
/// Tests for user state management, profile loading, and updates

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:musicbud_flutter/blocs/user/user_bloc.dart';
import 'package:musicbud_flutter/blocs/user/user_event.dart';
import 'package:musicbud_flutter/blocs/user/user_state.dart';
import 'package:musicbud_flutter/domain/repositories/user_repository.dart';
import '../../test_config.dart';
import '../../helpers/test_helpers.dart';

@GenerateMocks([UserRepository])
import 'user_bloc_test.mocks.dart';

void main() {
  group('UserBloc Tests', () {
    late UserBloc userBloc;
    late MockUserRepository mockUserRepository;

    setUp(() {
      TestLogger.log('Setting up UserBloc test');
      mockUserRepository = MockUserRepository();
      userBloc = UserBloc(userRepository: mockUserRepository);
    });

    tearDown(() {
      TestLogger.log('Tearing down UserBloc test');
      userBloc.close();
    });

    test('initial state is UserInitial', () {
      expect(userBloc.state, isA<UserInitial>());
      TestLogger.logSuccess('Initial state verified');
    });

    group('LoadMyProfile', () {
      final mockProfile = TestData.createMockProfile();

      blocTest<UserBloc, UserState>(
        'emits [UserLoading, ProfileLoaded] when loading profile succeeds',
        build: () {
          when(mockUserRepository.getUserProfile())
              .thenAnswer((_) async => mockProfile);
          return userBloc;
        },
        act: (bloc) => bloc.add(LoadMyProfile()),
        expect: () => [
          isA<UserLoading>(),
          isA<ProfileLoaded>(),
        ],
        verify: (_) {
          verify(mockUserRepository.getUserProfile()).called(1);
          TestLogger.logSuccess('Profile loading verified');
        },
      );

      blocTest<UserBloc, UserState>(
        'emits [UserLoading, UserError] when loading profile fails',
        build: () {
          when(mockUserRepository.getUserProfile())
              .thenThrow(ErrorSimulator.networkError());
          return userBloc;
        },
        act: (bloc) => bloc.add(LoadMyProfile()),
        expect: () => [
          isA<UserLoading>(),
          isA<UserError>().having(
            (s) => s.message,
            'message',
            contains('Failed to load user profile'),
          ),
        ],
      );
    });

    group('LoadLikedItems', () {
      final mockArtists = TestData.createList(
        (i) => TestData.createMockArtist(id: 'artist$i'),
        3,
      );
      final mockTracks = TestData.createList(
        (i) => TestData.createMockTrack(id: 'track$i'),
        5,
      );
      final mockAlbums = TestData.createList(
        (i) => TestData.createMockAlbum(id: 'album$i'),
        2,
      );
      final mockGenres = TestData.createList(
        (i) => TestData.createMockGenre(id: 'genre$i'),
        4,
      );

      blocTest<UserBloc, UserState>(
        'emits [UserLoading, LikedItemsLoaded] when loading liked items succeeds',
        build: () {
          when(mockUserRepository.getLikedArtists())
              .thenAnswer((_) async => mockArtists);
          when(mockUserRepository.getLikedTracks())
              .thenAnswer((_) async => mockTracks);
          when(mockUserRepository.getLikedAlbums())
              .thenAnswer((_) async => mockAlbums);
          when(mockUserRepository.getLikedGenres())
              .thenAnswer((_) async => mockGenres);
          return userBloc;
        },
        act: (bloc) => bloc.add(LoadLikedItems()),
        expect: () => [
          isA<UserLoading>(),
          isA<LikedItemsLoaded>()
              .having((s) => s.likedArtists.length, 'artists count', 3)
              .having((s) => s.likedTracks.length, 'tracks count', 5)
              .having((s) => s.likedAlbums.length, 'albums count', 2)
              .having((s) => s.likedGenres.length, 'genres count', 4),
        ],
        verify: (_) {
          verify(mockUserRepository.getLikedArtists()).called(1);
          verify(mockUserRepository.getLikedTracks()).called(1);
          verify(mockUserRepository.getLikedAlbums()).called(1);
          verify(mockUserRepository.getLikedGenres()).called(1);
          TestLogger.logSuccess('Liked items loading verified');
        },
      );

      blocTest<UserBloc, UserState>(
        'emits [UserLoading, UserError] when loading liked items fails',
        build: () {
          when(mockUserRepository.getLikedArtists())
              .thenThrow(ErrorSimulator.networkError());
          return userBloc;
        },
        act: (bloc) => bloc.add(LoadLikedItems()),
        expect: () => [
          isA<UserLoading>(),
          isA<UserError>(),
        ],
      );
    });

    group('LoadTopItems', () {
      final mockTopArtists = TestData.createList(
        (i) => TestData.createMockArtist(id: 'top_artist$i'),
        5,
      );
      final mockTopTracks = TestData.createList(
        (i) => TestData.createMockTrack(id: 'top_track$i'),
        10,
      );
      final mockTopGenres = TestData.createList(
        (i) => TestData.createMockGenre(id: 'top_genre$i'),
        3,
      );

      blocTest<UserBloc, UserState>(
        'emits [UserLoading, TopItemsLoaded] when loading top items succeeds',
        build: () {
          when(mockUserRepository.getTopArtists())
              .thenAnswer((_) async => mockTopArtists);
          when(mockUserRepository.getTopTracks())
              .thenAnswer((_) async => mockTopTracks);
          when(mockUserRepository.getTopGenres())
              .thenAnswer((_) async => mockTopGenres);
          when(mockUserRepository.getTopAnime())
              .thenAnswer((_) async => []);
          when(mockUserRepository.getTopManga())
              .thenAnswer((_) async => []);
          return userBloc;
        },
        act: (bloc) => bloc.add(LoadTopItems()),
        expect: () => [
          isA<UserLoading>(),
          isA<TopItemsLoaded>()
              .having((s) => s.topArtists.length, 'top artists count', 5)
              .having((s) => s.topTracks.length, 'top tracks count', 10)
              .having((s) => s.topGenres.length, 'top genres count', 3),
        ],
        verify: (_) {
          verify(mockUserRepository.getTopArtists()).called(1);
          verify(mockUserRepository.getTopTracks()).called(1);
          verify(mockUserRepository.getTopGenres()).called(1);
          TestLogger.logSuccess('Top items loading verified');
        },
      );

      blocTest<UserBloc, UserState>(
        'emits [UserLoading, UserError] when loading top items fails',
        build: () {
          when(mockUserRepository.getTopArtists())
              .thenThrow(ErrorSimulator.timeoutError());
          return userBloc;
        },
        act: (bloc) => bloc.add(LoadTopItems()),
        expect: () => [
          isA<UserLoading>(),
          isA<UserError>(),
        ],
      );
    });

    group('LoadPlayedTracks', () {
      final mockPlayedTracks = TestData.createList(
        (i) => TestData.createMockTrack(id: 'played_track$i'),
        20,
      );

      blocTest<UserBloc, UserState>(
        'emits [UserLoading, PlayedTracksLoaded] when loading played tracks succeeds',
        build: () {
          when(mockUserRepository.getPlayedTracks())
              .thenAnswer((_) async => mockPlayedTracks);
          return userBloc;
        },
        act: (bloc) => bloc.add(LoadPlayedTracks()),
        expect: () => [
          isA<UserLoading>(),
          isA<PlayedTracksLoaded>()
              .having((s) => s.tracks.length, 'tracks count', 20),
        ],
        verify: (_) {
          verify(mockUserRepository.getPlayedTracks()).called(1);
          TestLogger.logSuccess('Played tracks loading verified');
        },
      );

      blocTest<UserBloc, UserState>(
        'emits [UserLoading, UserError] when loading played tracks fails',
        build: () {
          when(mockUserRepository.getPlayedTracks())
              .thenThrow(ErrorSimulator.notFoundError());
          return userBloc;
        },
        act: (bloc) => bloc.add(LoadPlayedTracks()),
        expect: () => [
          isA<UserLoading>(),
          isA<UserError>(),
        ],
      );
    });

    group('UpdateMyProfile', () {
      final mockProfile = TestData.createMockProfile();

      blocTest<UserBloc, UserState>(
        'emits [UserLoading, ProfileLoaded] when updating profile succeeds',
        build: () {
          when(mockUserRepository.updateMyProfile(any))
              .thenAnswer((_) async => Future.value());
          return userBloc;
        },
        act: (bloc) => bloc.add(UpdateMyProfile(mockProfile)),
        expect: () => [
          isA<UserLoading>(),
          isA<ProfileLoaded>(),
        ],
        verify: (_) {
          verify(mockUserRepository.updateMyProfile(mockProfile)).called(1);
          TestLogger.logSuccess('Profile update verified');
        },
      );

      blocTest<UserBloc, UserState>(
        'emits [UserLoading, UserError] when updating profile fails',
        build: () {
          when(mockUserRepository.updateMyProfile(any))
              .thenThrow(ErrorSimulator.validationError('username'));
          return userBloc;
        },
        act: (bloc) => bloc.add(UpdateMyProfile(mockProfile)),
        expect: () => [
          isA<UserLoading>(),
          isA<UserError>().having(
            (s) => s.message,
            'message',
            contains('Failed to update profile'),
          ),
        ],
      );
    });

    group('State Transitions', () {
      final mockProfile = TestData.createMockProfile();

      blocTest<UserBloc, UserState>(
        'handles multiple sequential events correctly',
        build: () {
          when(mockUserRepository.getUserProfile())
              .thenAnswer((_) async => mockProfile);
          when(mockUserRepository.getPlayedTracks())
              .thenAnswer((_) async => []);
          return userBloc;
        },
        act: (bloc) {
          bloc.add(LoadMyProfile());
          bloc.add(LoadPlayedTracks());
        },
        expect: () => [
          isA<UserLoading>(),
          isA<ProfileLoaded>(),
          isA<UserLoading>(),
          isA<PlayedTracksLoaded>(),
        ],
      );
    });

    group('Edge Cases', () {
      blocTest<UserBloc, UserState>(
        'handles empty liked items list',
        build: () {
          when(mockUserRepository.getLikedArtists())
              .thenAnswer((_) async => []);
          when(mockUserRepository.getLikedTracks())
              .thenAnswer((_) async => []);
          when(mockUserRepository.getLikedAlbums())
              .thenAnswer((_) async => []);
          when(mockUserRepository.getLikedGenres())
              .thenAnswer((_) async => []);
          return userBloc;
        },
        act: (bloc) => bloc.add(LoadLikedItems()),
        expect: () => [
          isA<UserLoading>(),
          isA<LikedItemsLoaded>()
              .having((s) => s.likedArtists, 'artists', isEmpty)
              .having((s) => s.likedTracks, 'tracks', isEmpty),
        ],
      );

      blocTest<UserBloc, UserState>(
        'handles large number of items',
        build: () {
          final largeList = TestData.createList(
            (i) => TestData.createMockTrack(id: 'track$i'),
            1000,
          );
          when(mockUserRepository.getPlayedTracks())
              .thenAnswer((_) async => largeList);
          return userBloc;
        },
        act: (bloc) => bloc.add(LoadPlayedTracks()),
        expect: () => [
          isA<UserLoading>(),
          isA<PlayedTracksLoaded>()
              .having((s) => s.tracks.length, 'tracks count', 1000),
        ],
      );
    });

    group('Error Recovery', () {
      final mockProfile = TestData.createMockProfile();

      blocTest<UserBloc, UserState>(
        'recovers from error state on successful retry',
        build: () {
          var callCount = 0;
          when(mockUserRepository.getUserProfile()).thenAnswer((_) async {
            callCount++;
            if (callCount == 1) {
              throw ErrorSimulator.networkError();
            }
            return mockProfile;
          });
          return userBloc;
        },
        act: (bloc) {
          bloc.add(LoadMyProfile());
          bloc.add(LoadMyProfile()); // Retry
        },
        expect: () => [
          isA<UserLoading>(),
          isA<UserError>(),
          isA<UserLoading>(),
          isA<ProfileLoaded>(),
        ],
      );
    });
  });
}
