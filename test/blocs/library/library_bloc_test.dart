/// Comprehensive LibraryBloc Tests

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:musicbud_flutter/blocs/library/library_bloc.dart';
import 'package:musicbud_flutter/blocs/library/library_event.dart';
import 'package:musicbud_flutter/blocs/library/library_state.dart';
import 'package:musicbud_flutter/domain/repositories/content_repository.dart';
import '../../test_config.dart';

@GenerateMocks([ContentRepository])
import 'library_bloc_test.mocks.dart';

void main() {
  group('LibraryBloc Tests', () {
    late LibraryBloc libraryBloc;
    late MockContentRepository mockRepository;

    setUp(() {
      TestLogger.log('Setting up LibraryBloc test');
      mockRepository = MockContentRepository();
      libraryBloc = LibraryBloc(contentRepository: mockRepository);
    });

    tearDown(() {
      TestLogger.log('Tearing down LibraryBloc test');
      libraryBloc.close();
    });

    test('initial state is LibraryInitial', () {
      expect(libraryBloc.state, isA<LibraryInitial>());
      TestLogger.logSuccess('Initial state verified');
    });

    group('LibraryItemsRequested', () {
      blocTest<LibraryBloc, LibraryState>(
        'emits [Loading, Loaded] when library loads successfully',
        build: () {
          when(mockRepository.getLikedTracks())
              .thenAnswer((_) async => TestDataGenerator.generateTracks(20));
          return libraryBloc;
        },
        act: (bloc) => bloc.add(const LibraryItemsRequested(type: 'tracks')),
        expect: () => [
          isA<LibraryLoading>(),
          isA<LibraryLoaded>(),
        ],
        verify: (_) {
          verify(mockRepository.getLikedTracks()).called(1);
          TestLogger.logSuccess('Library loaded successfully');
        },
      );

      blocTest<LibraryBloc, LibraryState>(
        'emits [Loading, Error] when loading fails',
        build: () {
          when(mockRepository.getLikedTracks())
              .thenThrow(Exception('Failed to load library'));
          return libraryBloc;
        },
        act: (bloc) => bloc.add(const LibraryItemsRequested(type: 'tracks')),
        expect: () => [
          isA<LibraryLoading>(),
          isA<LibraryError>(),
        ],
      );

      blocTest<LibraryBloc, LibraryState>(
        'handles empty library',
        build: () {
          when(mockRepository.getLikedTracks())
              .thenAnswer((_) async => []);
          return libraryBloc;
        },
        act: (bloc) => bloc.add(const LibraryItemsRequested(type: 'tracks')),
        expect: () => [
          isA<LibraryLoading>(),
          isA<LibraryLoaded>(),
        ],
      );
    });

    group('LibraryItemToggleLiked', () {
      blocTest<LibraryBloc, LibraryState>(
        'toggles item like status successfully',
        build: () {
          when(mockRepository.toggleLike(any, any))
              .thenAnswer((_) async => Future.value());
          return libraryBloc;
        },
        act: (bloc) => bloc.add(const LibraryItemToggleLiked(
          itemId: 'item_id',
          type: 'track',
        )),
        expect: () => [
          isA<LibraryActionSuccess>(),
        ],
      );

      blocTest<LibraryBloc, LibraryState>(
        'handles toggle like failure',
        build: () {
          when(mockRepository.toggleLike(any, any))
              .thenThrow(Exception('Failed to toggle like'));
          return libraryBloc;
        },
        act: (bloc) => bloc.add(const LibraryItemToggleLiked(
          itemId: 'item_id',
          type: 'track',
        )),
        expect: () => [
          isA<LibraryActionFailure>(),
        ],
      );
    });

    group('LibraryPlaylistCreated', () {
      blocTest<LibraryBloc, LibraryState>(
        'creates playlist successfully',
        build: () {
          when(mockRepository.createPlaylist(
            name: anyNamed('name'),
            description: anyNamed('description'),
            isPrivate: anyNamed('isPrivate'),
          )).thenAnswer((_) async => Future.value());
          return libraryBloc;
        },
        act: (bloc) => bloc.add(const LibraryPlaylistCreated(
          name: 'My Playlist',
          description: 'Test playlist',
        )),
        expect: () => [
          isA<LibraryActionSuccess>(),
        ],
      );
    });

    group('LibraryPlaylistDeleted', () {
      blocTest<LibraryBloc, LibraryState>(
        'deletes playlist successfully',
        build: () {
          when(mockRepository.deletePlaylist(any))
              .thenAnswer((_) async => Future.value());
          return libraryBloc;
        },
        act: (bloc) => bloc.add(const LibraryPlaylistDeleted(
          playlistId: 'playlist_id',
        )),
        expect: () => [
          isA<LibraryActionSuccess>(),
        ],
      );
    });

    TestLogger.logSuccess('All LibraryBloc tests completed');
  });
}
