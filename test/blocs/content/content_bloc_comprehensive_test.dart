/// Comprehensive ContentBloc Unit Tests
/// 
/// Tests all content functionality including:
/// - Loading top content (tracks, artists, genres, anime, manga)
/// - Loading liked content
/// - Loading played tracks
/// - Like/Unlike operations
/// - Search functionality
/// - Error handling
/// - Edge cases

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:musicbud_flutter/blocs/content/content_bloc.dart';
import 'package:musicbud_flutter/blocs/content/content_event.dart';
import 'package:musicbud_flutter/blocs/content/content_state.dart';
import 'package:musicbud_flutter/domain/repositories/content_repository.dart';

@GenerateMocks([ContentRepository])
import 'content_bloc_comprehensive_test.mocks.dart';

void main() {
  group('ContentBloc', () {
    late ContentBloc contentBloc;
    late MockContentRepository mockContentRepository;

    setUp(() {
      mockContentRepository = MockContentRepository();
      contentBloc = ContentBloc(contentRepository: mockContentRepository);
    });

    tearDown(() {
      contentBloc.close();
    });

    test('initial state is ContentInitial', () {
      expect(contentBloc.state, equals(ContentInitial()));
    });

    group('Load Top Content', () {
      blocTest<ContentBloc, ContentState>(
        'emits [ContentLoading, ContentLoaded] when top content loaded successfully',
        build: () {
          when(mockContentRepository.getTopTracks()).thenAnswer(
            (_) async => [
              {'id': 'track1', 'title': 'Track 1', 'artist': 'Artist 1'},
              {'id': 'track2', 'title': 'Track 2', 'artist': 'Artist 2'},
            ],
          );
          when(mockContentRepository.getTopArtists()).thenAnswer(
            (_) async => [
              {'id': 'artist1', 'name': 'Artist 1'},
              {'id': 'artist2', 'name': 'Artist 2'},
            ],
          );
          when(mockContentRepository.getTopGenres()).thenAnswer(
            (_) async => [
              {'id': 'genre1', 'name': 'Rock'},
              {'id': 'genre2', 'name': 'Pop'},
            ],
          );
          when(mockContentRepository.getTopAnime()).thenAnswer(
            (_) async => [
              {'id': 'anime1', 'title': 'Anime 1'},
            ],
          );
          when(mockContentRepository.getTopManga()).thenAnswer(
            (_) async => [
              {'id': 'manga1', 'title': 'Manga 1'},
            ],
          );
          return contentBloc;
        },
        act: (bloc) => bloc.add(LoadTopContent()),
        expect: () => [
          ContentLoading(),
          isA<ContentLoaded>()
              .having((state) => state.topTracks.length, 'tracks count', 2)
              .having((state) => state.topArtists.length, 'artists count', 2)
              .having((state) => state.topGenres.length, 'genres count', 2)
              .having((state) => state.topAnime.length, 'anime count', 1)
              .having((state) => state.topManga.length, 'manga count', 1),
        ],
        verify: (_) {
          verify(mockContentRepository.getTopTracks()).called(1);
          verify(mockContentRepository.getTopArtists()).called(1);
          verify(mockContentRepository.getTopGenres()).called(1);
          verify(mockContentRepository.getTopAnime()).called(1);
          verify(mockContentRepository.getTopManga()).called(1);
        },
      );

      blocTest<ContentBloc, ContentState>(
        'emits [ContentLoading, ContentError] when loading top content fails',
        build: () {
          when(mockContentRepository.getTopTracks()).thenThrow(
            Exception('Failed to load top tracks'),
          );
          return contentBloc;
        },
        act: (bloc) => bloc.add(LoadTopContent()),
        expect: () => [
          ContentLoading(),
          isA<ContentError>().having(
            (state) => state.message,
            'error message',
            contains('Failed to load top tracks'),
          ),
        ],
      );

      blocTest<ContentBloc, ContentState>(
        'loads individual top tracks successfully',
        build: () {
          when(mockContentRepository.getTopTracks()).thenAnswer(
            (_) async => [
              {'id': 'track1', 'title': 'Top Track 1'},
              {'id': 'track2', 'title': 'Top Track 2'},
              {'id': 'track3', 'title': 'Top Track 3'},
            ],
          );
          return contentBloc;
        },
        act: (bloc) => bloc.add(LoadTopTracks()),
        expect: () => [
          ContentLoading(),
          isA<ContentLoaded>().having(
            (state) => state.topTracks.length,
            'top tracks count',
            3,
          ),
        ],
      );

      blocTest<ContentBloc, ContentState>(
        'loads individual top artists successfully',
        build: () {
          when(mockContentRepository.getTopArtists()).thenAnswer(
            (_) async => [
              {'id': 'artist1', 'name': 'Artist 1'},
              {'id': 'artist2', 'name': 'Artist 2'},
            ],
          );
          return contentBloc;
        },
        act: (bloc) => bloc.add(LoadTopArtists()),
        expect: () => [
          ContentLoading(),
          isA<ContentLoaded>().having(
            (state) => state.topArtists.length,
            'top artists count',
            2,
          ),
        ],
      );

      blocTest<ContentBloc, ContentState>(
        'loads individual top genres successfully',
        build: () {
          when(mockContentRepository.getTopGenres()).thenAnswer(
            (_) async => [
              {'id': 'genre1', 'name': 'Rock'},
              {'id': 'genre2', 'name': 'Jazz'},
              {'id': 'genre3', 'name': 'Classical'},
            ],
          );
          return contentBloc;
        },
        act: (bloc) => bloc.add(LoadTopGenres()),
        expect: () => [
          ContentLoading(),
          isA<ContentLoaded>().having(
            (state) => state.topGenres.length,
            'top genres count',
            3,
          ),
        ],
      );

      blocTest<ContentBloc, ContentState>(
        'loads individual top anime successfully',
        build: () {
          when(mockContentRepository.getTopAnime()).thenAnswer(
            (_) async => [
              {'id': 'anime1', 'title': 'Anime 1'},
              {'id': 'anime2', 'title': 'Anime 2'},
            ],
          );
          return contentBloc;
        },
        act: (bloc) => bloc.add(LoadTopAnime()),
        expect: () => [
          ContentLoading(),
          isA<ContentLoaded>().having(
            (state) => state.topAnime.length,
            'top anime count',
            2,
          ),
        ],
      );

      blocTest<ContentBloc, ContentState>(
        'loads individual top manga successfully',
        build: () {
          when(mockContentRepository.getTopManga()).thenAnswer(
            (_) async => [
              {'id': 'manga1', 'title': 'Manga 1'},
            ],
          );
          return contentBloc;
        },
        act: (bloc) => bloc.add(LoadTopManga()),
        expect: () => [
          ContentLoading(),
          isA<ContentLoaded>().having(
            (state) => state.topManga.length,
            'top manga count',
            1,
          ),
        ],
      );
    });

    group('Load Liked Content', () {
      blocTest<ContentBloc, ContentState>(
        'emits [ContentLoading, ContentLoaded] with liked content',
        build: () {
          when(mockContentRepository.getLikedTracks()).thenAnswer(
            (_) async => [
              {'id': 'liked_track1', 'title': 'Liked Track 1'},
            ],
          );
          when(mockContentRepository.getLikedArtists()).thenAnswer(
            (_) async => [
              {'id': 'liked_artist1', 'name': 'Liked Artist 1'},
            ],
          );
          when(mockContentRepository.getLikedAlbums()).thenAnswer(
            (_) async => [
              {'id': 'liked_album1', 'title': 'Liked Album 1'},
            ],
          );
          when(mockContentRepository.getLikedGenres()).thenAnswer(
            (_) async => [
              {'id': 'liked_genre1', 'name': 'Rock'},
            ],
          );
          return contentBloc;
        },
        act: (bloc) => bloc.add(LoadLikedContent()),
        expect: () => [
          ContentLoading(),
          isA<ContentLoaded>()
              .having((state) => state.likedTracks?.length, 'liked tracks', 1)
              .having((state) => state.likedArtists?.length, 'liked artists', 1)
              .having((state) => state.likedAlbums?.length, 'liked albums', 1)
              .having((state) => state.likedGenres?.length, 'liked genres', 1),
        ],
      );

      blocTest<ContentBloc, ContentState>(
        'loads individual liked tracks successfully',
        build: () {
          when(mockContentRepository.getLikedTracks()).thenAnswer(
            (_) async => [
              {'id': 'track1', 'title': 'Liked Track 1'},
              {'id': 'track2', 'title': 'Liked Track 2'},
            ],
          );
          return contentBloc;
        },
        act: (bloc) => bloc.add(LoadLikedTracks()),
        expect: () => [
          ContentLoading(),
          isA<ContentLoaded>().having(
            (state) => state.likedTracks?.length,
            'liked tracks count',
            2,
          ),
        ],
      );

      blocTest<ContentBloc, ContentState>(
        'loads individual liked artists successfully',
        build: () {
          when(mockContentRepository.getLikedArtists()).thenAnswer(
            (_) async => [
              {'id': 'artist1', 'name': 'Liked Artist 1'},
            ],
          );
          return contentBloc;
        },
        act: (bloc) => bloc.add(LoadLikedArtists()),
        expect: () => [
          ContentLoading(),
          isA<ContentLoaded>().having(
            (state) => state.likedArtists?.length,
            'liked artists count',
            1,
          ),
        ],
      );

      blocTest<ContentBloc, ContentState>(
        'handles empty liked content',
        build: () {
          when(mockContentRepository.getLikedTracks()).thenAnswer(
            (_) async => [],
          );
          when(mockContentRepository.getLikedArtists()).thenAnswer(
            (_) async => [],
          );
          when(mockContentRepository.getLikedAlbums()).thenAnswer(
            (_) async => [],
          );
          when(mockContentRepository.getLikedGenres()).thenAnswer(
            (_) async => [],
          );
          return contentBloc;
        },
        act: (bloc) => bloc.add(LoadLikedContent()),
        expect: () => [
          ContentLoading(),
          isA<ContentLoaded>()
              .having((state) => state.likedTracks, 'empty liked tracks', isEmpty)
              .having((state) => state.likedArtists, 'empty liked artists', isEmpty),
        ],
      );
    });

    group('Load Played Tracks', () {
      blocTest<ContentBloc, ContentState>(
        'emits [ContentLoading, ContentLoaded] with played tracks',
        build: () {
          when(mockContentRepository.getPlayedTracks()).thenAnswer(
            (_) async => [
              {
                'id': 'played1',
                'title': 'Played Track 1',
                'played_at': DateTime.now().toIso8601String(),
              },
              {
                'id': 'played2',
                'title': 'Played Track 2',
                'played_at': DateTime.now().toIso8601String(),
              },
            ],
          );
          return contentBloc;
        },
        act: (bloc) => bloc.add(LoadPlayedTracks()),
        expect: () => [
          ContentLoading(),
          isA<ContentLoaded>().having(
            (state) => state.playedTracks?.length,
            'played tracks count',
            2,
          ),
        ],
      );

      blocTest<ContentBloc, ContentState>(
        'handles empty played tracks',
        build: () {
          when(mockContentRepository.getPlayedTracks()).thenAnswer(
            (_) async => [],
          );
          return contentBloc;
        },
        act: (bloc) => bloc.add(LoadPlayedTracks()),
        expect: () => [
          ContentLoading(),
          isA<ContentLoaded>().having(
            (state) => state.playedTracks,
            'empty played tracks',
            isEmpty,
          ),
        ],
      );
    });

    group('Like/Unlike Operations', () {
      blocTest<ContentBloc, ContentState>(
        'emits ContentSuccess when item liked successfully',
        build: () {
          when(mockContentRepository.toggleLike(any, any)).thenAnswer(
            (_) async => {},
          );
          return contentBloc;
        },
        act: (bloc) => bloc.add(LikeItem(id: 'track1', type: 'track')),
        expect: () => [
          isA<ContentSuccess>(),
        ],
        verify: (_) {
          verify(mockContentRepository.toggleLike('track1', 'track')).called(1);
        },
      );

      blocTest<ContentBloc, ContentState>(
        'emits ContentSuccess when item unliked successfully',
        build: () {
          when(mockContentRepository.toggleLike(any, any)).thenAnswer(
            (_) async => {},
          );
          return contentBloc;
        },
        act: (bloc) => bloc.add(UnlikeItem(id: 'track1', type: 'track')),
        expect: () => [
          isA<ContentSuccess>(),
        ],
        verify: (_) {
          verify(mockContentRepository.toggleLike('track1', 'track')).called(1);
        },
      );

      blocTest<ContentBloc, ContentState>(
        'handles like operation failure',
        build: () {
          when(mockContentRepository.toggleLike(any, any)).thenThrow(
            Exception('Failed to like item'),
          );
          return contentBloc;
        },
        act: (bloc) => bloc.add(LikeItem(id: 'track1', type: 'track')),
        expect: () => [
          isA<ContentError>().having(
            (state) => state.message,
            'error message',
            contains('Failed to like item'),
          ),
        ],
      );

      blocTest<ContentBloc, ContentState>(
        'toggles track like successfully',
        build: () {
          when(mockContentRepository.toggleLike(any, any)).thenAnswer(
            (_) async => {},
          );
          return contentBloc;
        },
        act: (bloc) => bloc.add(ToggleTrackLike(trackId: 'track123')),
        expect: () => [
          ContentLoading(),
          isA<ContentSuccess>(),
        ],
      );
    });

    group('Search Content', () {
      blocTest<ContentBloc, ContentState>(
        'searches tracks successfully',
        build: () {
          when(mockContentRepository.getLikedTracks()).thenAnswer(
            (_) async => [
              {'id': 'track1', 'title': 'Search Result Track'},
            ],
          );
          return contentBloc;
        },
        act: (bloc) => bloc.add(
          SearchContent(query: 'rock', type: 'track'),
        ),
        expect: () => [
          ContentLoading(),
          isA<ContentLoaded>().having(
            (state) => state.topTracks.length,
            'search results',
            1,
          ),
        ],
      );

      blocTest<ContentBloc, ContentState>(
        'searches artists successfully',
        build: () {
          when(mockContentRepository.getLikedArtists()).thenAnswer(
            (_) async => [
              {'id': 'artist1', 'name': 'Search Result Artist'},
            ],
          );
          return contentBloc;
        },
        act: (bloc) => bloc.add(
          SearchContent(query: 'artist', type: 'artist'),
        ),
        expect: () => [
          ContentLoading(),
          isA<ContentLoaded>().having(
            (state) => state.topArtists.length,
            'search results',
            1,
          ),
        ],
      );

      blocTest<ContentBloc, ContentState>(
        'searches albums successfully',
        build: () {
          when(mockContentRepository.getLikedAlbums()).thenAnswer(
            (_) async => [
              {'id': 'album1', 'title': 'Search Result Album'},
            ],
          );
          return contentBloc;
        },
        act: (bloc) => bloc.add(
          SearchContent(query: 'album', type: 'album'),
        ),
        expect: () => [
          ContentLoading(),
          isA<ContentLoaded>(),
        ],
      );

      blocTest<ContentBloc, ContentState>(
        'handles empty search results',
        build: () {
          when(mockContentRepository.getLikedTracks()).thenAnswer(
            (_) async => [],
          );
          return contentBloc;
        },
        act: (bloc) => bloc.add(
          SearchContent(query: 'nonexistent', type: 'track'),
        ),
        expect: () => [
          ContentLoading(),
          isA<ContentLoaded>().having(
            (state) => state.topTracks,
            'empty results',
            isEmpty,
          ),
        ],
      );
    });

    group('Tracking Events', () {
      blocTest<ContentBloc, ContentState>(
        'saves played track successfully',
        build: () {
          when(mockContentRepository.savePlayedTrack(any)).thenAnswer(
            (_) async => {},
          );
          return contentBloc;
        },
        act: (bloc) => bloc.add(
          SavePlayedTrack(trackId: 'track123'),
        ),
        expect: () => [
          ContentLoading(),
          isA<ContentSuccess>(),
        ],
      );

      blocTest<ContentBloc, ContentState>(
        'saves track location successfully',
        build: () {
          when(mockContentRepository.saveTrackLocation(
            any,
            latitude: anyNamed('latitude'),
            longitude: anyNamed('longitude'),
          )).thenAnswer(
            (_) async => {},
          );
          return contentBloc;
        },
        act: (bloc) => bloc.add(
          SaveTrackLocation(
            trackId: 'track123',
            latitude: 37.7749,
            longitude: -122.4194,
          ),
        ),
        expect: () => [
          ContentLoading(),
          isA<ContentSuccess>(),
        ],
      );

      blocTest<ContentBloc, ContentState>(
        'loads played tracks with location',
        build: () {
          when(mockContentRepository.getPlayedTracksWithLocation()).thenAnswer(
            (_) async => [
              {
                'id': 'track1',
                'title': 'Track 1',
                'latitude': 37.7749,
                'longitude': -122.4194,
              },
            ],
          );
          return contentBloc;
        },
        act: (bloc) => bloc.add(LoadPlayedTracksWithLocation()),
        expect: () => [
          ContentLoading(),
          isA<ContentLoaded>(),
        ],
      );
    });

    group('Edge Cases', () {
      blocTest<ContentBloc, ContentState>(
        'handles very large dataset',
        build: () {
          final largeTrackList = List.generate(
            1000,
            (i) => {'id': 'track_$i', 'title': 'Track $i'},
          );
          when(mockContentRepository.getTopTracks()).thenAnswer(
            (_) async => largeTrackList,
          );
          when(mockContentRepository.getTopArtists()).thenAnswer(
            (_) async => [],
          );
          when(mockContentRepository.getTopGenres()).thenAnswer(
            (_) async => [],
          );
          when(mockContentRepository.getTopAnime()).thenAnswer(
            (_) async => [],
          );
          when(mockContentRepository.getTopManga()).thenAnswer(
            (_) async => [],
          );
          return contentBloc;
        },
        act: (bloc) => bloc.add(LoadTopContent()),
        expect: () => [
          ContentLoading(),
          isA<ContentLoaded>().having(
            (state) => state.topTracks.length,
            'large dataset',
            1000,
          ),
        ],
      );

      blocTest<ContentBloc, ContentState>(
        'handles network timeout',
        build: () {
          when(mockContentRepository.getTopTracks()).thenThrow(
            Exception('Network timeout'),
          );
          return contentBloc;
        },
        act: (bloc) => bloc.add(LoadTopContent()),
        expect: () => [
          ContentLoading(),
          isA<ContentError>().having(
            (state) => state.message,
            'timeout error',
            contains('Network timeout'),
          ),
        ],
      );

      blocTest<ContentBloc, ContentState>(
        'handles malformed data',
        build: () {
          when(mockContentRepository.getTopTracks()).thenAnswer(
            (_) async => [
              {'invalid': 'data'},
            ],
          );
          when(mockContentRepository.getTopArtists()).thenAnswer(
            (_) async => [],
          );
          when(mockContentRepository.getTopGenres()).thenAnswer(
            (_) async => [],
          );
          when(mockContentRepository.getTopAnime()).thenAnswer(
            (_) async => [],
          );
          when(mockContentRepository.getTopManga()).thenAnswer(
            (_) async => [],
          );
          return contentBloc;
        },
        act: (bloc) => bloc.add(LoadTopContent()),
        expect: () => [
          ContentLoading(),
          isA<ContentLoaded>(),
        ],
      );
    });

    group('State Preservation', () {
      blocTest<ContentBloc, ContentState>(
        'preserves existing state when loading liked content',
        build: () {
          when(mockContentRepository.getTopTracks()).thenAnswer(
            (_) async => [
              {'id': 'track1', 'title': 'Track 1'},
            ],
          );
          when(mockContentRepository.getTopArtists()).thenAnswer(
            (_) async => [],
          );
          when(mockContentRepository.getTopGenres()).thenAnswer(
            (_) async => [],
          );
          when(mockContentRepository.getTopAnime()).thenAnswer(
            (_) async => [],
          );
          when(mockContentRepository.getTopManga()).thenAnswer(
            (_) async => [],
          );
          when(mockContentRepository.getLikedTracks()).thenAnswer(
            (_) async => [
              {'id': 'liked1', 'title': 'Liked Track 1'},
            ],
          );
          when(mockContentRepository.getLikedArtists()).thenAnswer(
            (_) async => [],
          );
          when(mockContentRepository.getLikedAlbums()).thenAnswer(
            (_) async => [],
          );
          when(mockContentRepository.getLikedGenres()).thenAnswer(
            (_) async => [],
          );
          return contentBloc;
        },
        act: (bloc) async {
          bloc.add(LoadTopContent());
          await Future.delayed(Duration(milliseconds: 100));
          bloc.add(LoadLikedContent());
        },
        expect: () => [
          ContentLoading(),
          isA<ContentLoaded>()
              .having((state) => state.topTracks.length, 'top tracks', 1),
          ContentLoading(),
          isA<ContentLoaded>()
              .having((state) => state.topTracks.length, 'top tracks preserved', 1)
              .having((state) => state.likedTracks?.length, 'liked tracks added', 1),
        ],
      );
    });
  });
}
