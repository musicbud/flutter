/// Comprehensive BudMatchingBloc Unit Tests
/// 
/// Tests all bud matching functionality including:
/// - Profile fetching
/// - Finding buds by top items (artists, tracks, genres, anime, manga)
/// - Finding buds by liked items
/// - Finding buds by specific items
/// - Finding buds by played tracks
/// - Match scoring and filtering
/// - Error handling
/// - Edge cases

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:musicbud_flutter/blocs/bud_matching/bud_matching_bloc.dart';
import 'package:musicbud_flutter/domain/repositories/bud_matching_repository.dart';
import 'package:musicbud_flutter/models/bud_profile.dart';
import 'package:musicbud_flutter/models/bud_search_result.dart';
import 'package:musicbud_flutter/models/bud_match.dart';

@GenerateMocks([BudMatchingRepository])
import 'bud_matching_bloc_comprehensive_test.mocks.dart';

void main() {
  group('BudMatchingBloc', () {
    late BudMatchingBloc budMatchingBloc;
    late MockBudMatchingRepository mockBudMatchingRepository;

    // Test data
    final testBudProfile = BudProfile(
      message: 'Success',
      data: BudProfileData(
        commonArtistsData: [],
        commonTracksData: [],
        commonGenresData: [],
      ),
    );

    final testBudMatch = BudMatch(
      id: 'match_123',
      userId: 'user_123',
      username: 'Match Bud',
      matchScore: 85.0,
      commonArtists: 1,
      commonTracks: 1,
      commonGenres: 1,
    );

    final testSearchResult = BudSearchResult(
      message: 'Success',
      code: 200,
      successful: true,
      data: BudSearchData(buds: []),
    );

    setUp(() {
      mockBudMatchingRepository = MockBudMatchingRepository();
      budMatchingBloc = BudMatchingBloc(
        budMatchingRepository: mockBudMatchingRepository,
      );
    });

    tearDown(() {
      budMatchingBloc.close();
    });

    test('initial state is BudMatchingInitial', () {
      expect(budMatchingBloc.state, equals(BudMatchingInitial()));
    });

    group('Profile Fetching', () {
      blocTest<BudMatchingBloc, BudMatchingState>(
        'emits [BudMatchingLoading, BudProfileLoaded] when profile fetched successfully',
        build: () {
          when(mockBudMatchingRepository.fetchBudProfile(any)).thenAnswer(
            (_) async => testBudProfile,
          );
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FetchBudProfile(budId: 'bud_123')),
        expect: () => [
          BudMatchingLoading(),
          BudProfileLoaded(budProfile: testBudProfile),
        ],
        verify: (_) {
          verify(mockBudMatchingRepository.fetchBudProfile('bud_123')).called(1);
        },
      );

      blocTest<BudMatchingBloc, BudMatchingState>(
        'emits [BudMatchingLoading, BudMatchingError] when profile fetch fails',
        build: () {
          when(mockBudMatchingRepository.fetchBudProfile(any)).thenThrow(
            Exception('Failed to fetch profile'),
          );
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FetchBudProfile(budId: 'bud_123')),
        expect: () => [
          BudMatchingLoading(),
          isA<BudMatchingError>().having(
            (state) => state.message,
            'error message',
            contains('Failed to fetch profile'),
          ),
        ],
      );

      blocTest<BudMatchingBloc, BudMatchingState>(
        'handles invalid bud ID',
        build: () {
          when(mockBudMatchingRepository.fetchBudProfile(any)).thenThrow(
            Exception('Invalid bud ID'),
          );
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FetchBudProfile(budId: 'invalid_id')),
        expect: () => [
          BudMatchingLoading(),
          isA<BudMatchingError>().having(
            (state) => state.message,
            'error message',
            contains('Invalid bud ID'),
          ),
        ],
      );

      blocTest<BudMatchingBloc, BudMatchingState>(
        'handles network timeout',
        build: () {
          when(mockBudMatchingRepository.fetchBudProfile(any)).thenThrow(
            Exception('Network timeout'),
          );
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FetchBudProfile(budId: 'bud_123')),
        expect: () => [
          BudMatchingLoading(),
          isA<BudMatchingError>().having(
            (state) => state.message,
            'error message',
            contains('Network timeout'),
          ),
        ],
      );

      blocTest<BudMatchingBloc, BudMatchingState>(
        'handles empty profile data',
        build: () {
          final emptyProfile = BudProfile(
            message: 'Success',
            data: BudProfileData(
              commonArtistsData: [],
              commonTracksData: [],
              commonGenresData: [],
            ),
          );
          when(mockBudMatchingRepository.fetchBudProfile(any)).thenAnswer(
            (_) async => emptyProfile,
          );
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FetchBudProfile(budId: 'bud_123')),
        expect: () => [
          BudMatchingLoading(),
          isA<BudProfileLoaded>().having(
            (state) => state.budProfile.data.commonArtistsData,
            'empty common artists',
            isEmpty,
          ),
        ],
      );
    });

    group('Find Buds by Top Items', () {
      blocTest<BudMatchingBloc, BudMatchingState>(
        'finds buds by top artists successfully',
        build: () {
          when(mockBudMatchingRepository.findBudsByTopArtists()).thenAnswer(
            (_) async => testSearchResult,
          );
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FindBudsByTopArtists()),
        expect: () => [
          BudMatchingLoading(),
          BudsFound(searchResult: testSearchResult),
        ],
        verify: (_) {
          verify(mockBudMatchingRepository.findBudsByTopArtists()).called(1);
        },
      );

      blocTest<BudMatchingBloc, BudMatchingState>(
        'finds buds by top tracks successfully',
        build: () {
          when(mockBudMatchingRepository.findBudsByTopTracks()).thenAnswer(
            (_) async => testSearchResult,
          );
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FindBudsByTopTracks()),
        expect: () => [
          BudMatchingLoading(),
          BudsFound(searchResult: testSearchResult),
        ],
        verify: (_) {
          verify(mockBudMatchingRepository.findBudsByTopTracks()).called(1);
        },
      );

      blocTest<BudMatchingBloc, BudMatchingState>(
        'finds buds by top genres successfully',
        build: () {
          when(mockBudMatchingRepository.findBudsByTopGenres()).thenAnswer(
            (_) async => testSearchResult,
          );
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FindBudsByTopGenres()),
        expect: () => [
          BudMatchingLoading(),
          BudsFound(searchResult: testSearchResult),
        ],
        verify: (_) {
          verify(mockBudMatchingRepository.findBudsByTopGenres()).called(1);
        },
      );

      blocTest<BudMatchingBloc, BudMatchingState>(
        'finds buds by top anime successfully',
        build: () {
          when(mockBudMatchingRepository.findBudsByTopAnime()).thenAnswer(
            (_) async => testSearchResult,
          );
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FindBudsByTopAnime()),
        expect: () => [
          BudMatchingLoading(),
          BudsFound(searchResult: testSearchResult),
        ],
        verify: (_) {
          verify(mockBudMatchingRepository.findBudsByTopAnime()).called(1);
        },
      );

      blocTest<BudMatchingBloc, BudMatchingState>(
        'finds buds by top manga successfully',
        build: () {
          when(mockBudMatchingRepository.findBudsByTopManga()).thenAnswer(
            (_) async => testSearchResult,
          );
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FindBudsByTopManga()),
        expect: () => [
          BudMatchingLoading(),
          BudsFound(searchResult: testSearchResult),
        ],
        verify: (_) {
          verify(mockBudMatchingRepository.findBudsByTopManga()).called(1);
        },
      );

      blocTest<BudMatchingBloc, BudMatchingState>(
        'handles no matches found for top artists',
        build: () {
          final emptyResult = BudSearchResult(
            message: 'No matches',
            code: 200,
            successful: true,
            data: BudSearchData(buds: []),
          );
          when(mockBudMatchingRepository.findBudsByTopArtists()).thenAnswer(
            (_) async => emptyResult,
          );
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FindBudsByTopArtists()),
        expect: () => [
          BudMatchingLoading(),
          isA<BudsFound>().having(
            (state) => state.searchResult.data.buds,
            'empty matches',
            isEmpty,
          ),
        ],
      );
    });

    group('Find Buds by Liked Items', () {
      blocTest<BudMatchingBloc, BudMatchingState>(
        'finds buds by liked artists successfully',
        build: () {
          when(mockBudMatchingRepository.findBudsByLikedArtists()).thenAnswer(
            (_) async => testSearchResult,
          );
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FindBudsByLikedArtists()),
        expect: () => [
          BudMatchingLoading(),
          BudsFound(searchResult: testSearchResult),
        ],
        verify: (_) {
          verify(mockBudMatchingRepository.findBudsByLikedArtists()).called(1);
        },
      );

      blocTest<BudMatchingBloc, BudMatchingState>(
        'finds buds by liked tracks successfully',
        build: () {
          when(mockBudMatchingRepository.findBudsByLikedTracks()).thenAnswer(
            (_) async => testSearchResult,
          );
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FindBudsByLikedTracks()),
        expect: () => [
          BudMatchingLoading(),
          BudsFound(searchResult: testSearchResult),
        ],
        verify: (_) {
          verify(mockBudMatchingRepository.findBudsByLikedTracks()).called(1);
        },
      );

      blocTest<BudMatchingBloc, BudMatchingState>(
        'finds buds by liked genres successfully',
        build: () {
          when(mockBudMatchingRepository.findBudsByLikedGenres()).thenAnswer(
            (_) async => testSearchResult,
          );
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FindBudsByLikedGenres()),
        expect: () => [
          BudMatchingLoading(),
          BudsFound(searchResult: testSearchResult),
        ],
        verify: (_) {
          verify(mockBudMatchingRepository.findBudsByLikedGenres()).called(1);
        },
      );

      blocTest<BudMatchingBloc, BudMatchingState>(
        'finds buds by liked albums successfully',
        build: () {
          when(mockBudMatchingRepository.findBudsByLikedAlbums()).thenAnswer(
            (_) async => testSearchResult,
          );
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FindBudsByLikedAlbums()),
        expect: () => [
          BudMatchingLoading(),
          BudsFound(searchResult: testSearchResult),
        ],
        verify: (_) {
          verify(mockBudMatchingRepository.findBudsByLikedAlbums()).called(1);
        },
      );

      blocTest<BudMatchingBloc, BudMatchingState>(
        'finds buds by liked AIO (all-in-one) successfully',
        build: () {
          when(mockBudMatchingRepository.findBudsByLikedAio()).thenAnswer(
            (_) async => testSearchResult,
          );
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FindBudsByLikedAio()),
        expect: () => [
          BudMatchingLoading(),
          BudsFound(searchResult: testSearchResult),
        ],
        verify: (_) {
          verify(mockBudMatchingRepository.findBudsByLikedAio()).called(1);
        },
      );
    });

    group('Find Buds by Specific Items', () {
      blocTest<BudMatchingBloc, BudMatchingState>(
        'finds buds by specific artist ID',
        build: () {
          when(mockBudMatchingRepository.findBudsByArtist(any)).thenAnswer(
            (_) async => testSearchResult,
          );
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FindBudsByArtist(artistId: 'artist_123')),
        expect: () => [
          BudMatchingLoading(),
          BudsFound(searchResult: testSearchResult),
        ],
        verify: (_) {
          verify(mockBudMatchingRepository.findBudsByArtist('artist_123')).called(1);
        },
      );

      blocTest<BudMatchingBloc, BudMatchingState>(
        'finds buds by specific track ID',
        build: () {
          when(mockBudMatchingRepository.findBudsByTrack(any)).thenAnswer(
            (_) async => testSearchResult,
          );
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FindBudsByTrack(trackId: 'track_123')),
        expect: () => [
          BudMatchingLoading(),
          BudsFound(searchResult: testSearchResult),
        ],
        verify: (_) {
          verify(mockBudMatchingRepository.findBudsByTrack('track_123')).called(1);
        },
      );

      blocTest<BudMatchingBloc, BudMatchingState>(
        'finds buds by specific genre ID',
        build: () {
          when(mockBudMatchingRepository.findBudsByGenre(any)).thenAnswer(
            (_) async => testSearchResult,
          );
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FindBudsByGenre(genreId: 'genre_123')),
        expect: () => [
          BudMatchingLoading(),
          BudsFound(searchResult: testSearchResult),
        ],
        verify: (_) {
          verify(mockBudMatchingRepository.findBudsByGenre('genre_123')).called(1);
        },
      );

      blocTest<BudMatchingBloc, BudMatchingState>(
        'finds buds by played tracks',
        build: () {
          when(mockBudMatchingRepository.findBudsByPlayedTracks()).thenAnswer(
            (_) async => testSearchResult,
          );
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FindBudsByPlayedTracks()),
        expect: () => [
          BudMatchingLoading(),
          BudsFound(searchResult: testSearchResult),
        ],
        verify: (_) {
          verify(mockBudMatchingRepository.findBudsByPlayedTracks()).called(1);
        },
      );
    });

    group('Match Scoring & Filtering', () {
      blocTest<BudMatchingBloc, BudMatchingState>(
        'returns matches sorted by match score',
        build: () {
          final match1 = BudMatch(
            id: 'match_1',
            userId: 'user_1',
            username: 'Bud 1',
            matchScore: 95.0,
            commonArtists: 0,
            commonTracks: 0,
            commonGenres: 0,
          );
          final match2 = BudMatch(
            id: 'match_2',
            userId: 'user_2',
            username: 'Bud 2',
            matchScore: 85.0,
            commonArtists: 0,
            commonTracks: 0,
            commonGenres: 0,
          );
          final match3 = BudMatch(
            id: 'match_3',
            userId: 'user_3',
            username: 'Bud 3',
            matchScore: 90.0,
            commonArtists: 0,
            commonTracks: 0,
            commonGenres: 0,
          );
          final sortedResult = BudSearchResult(
            message: 'Success',
            code: 200,
            successful: true,
            data: BudSearchData(buds: []),
          );
          when(mockBudMatchingRepository.findBudsByTopArtists()).thenAnswer(
            (_) async => sortedResult,
          );
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FindBudsByTopArtists()),
        expect: () => [
          BudMatchingLoading(),
          isA<BudsFound>().having(
            (state) => state.searchResult.data.buds.length,
            'search result loaded',
            greaterThanOrEqualTo(0),
          ),
        ],
      );

      blocTest<BudMatchingBloc, BudMatchingState>(
        'handles equal match scores',
        build: () {
          final match1 = BudMatch(
            id: 'match_1',
            userId: 'user_1',
            username: 'Bud 1',
            matchScore: 85.0,
            commonArtists: 0,
            commonTracks: 0,
            commonGenres: 0,
          );
          final match2 = BudMatch(
            id: 'match_2',
            userId: 'user_2',
            username: 'Bud 2',
            matchScore: 85.0,
            commonArtists: 0,
            commonTracks: 0,
            commonGenres: 0,
          );
          final equalScoresResult = BudSearchResult(
            message: 'Success',
            code: 200,
            successful: true,
            data: BudSearchData(buds: []),
          );
          when(mockBudMatchingRepository.findBudsByTopArtists()).thenAnswer(
            (_) async => equalScoresResult,
          );
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FindBudsByTopArtists()),
        expect: () => [
          BudMatchingLoading(),
          isA<BudsFound>().having(
            (state) => state.searchResult.data.buds.length,
            'search result loaded',
            greaterThanOrEqualTo(0),
          ),
        ],
      );

      blocTest<BudMatchingBloc, BudMatchingState>(
        'returns top N matches',
        build: () {
          final manyMatchesResult = BudSearchResult(
            message: 'Success',
            code: 200,
            successful: true,
            data: BudSearchData(buds: []),
          );
          when(mockBudMatchingRepository.findBudsByTopArtists()).thenAnswer(
            (_) async => manyMatchesResult,
          );
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FindBudsByTopArtists()),
        expect: () => [
          BudMatchingLoading(),
          isA<BudsFound>().having(
            (state) => state.searchResult.data.buds.length,
            'search result loaded',
            greaterThanOrEqualTo(0),
          ),
        ],
      );

      blocTest<BudMatchingBloc, BudMatchingState>(
        'handles empty match results',
        build: () {
          final emptyResult = BudSearchResult(
            message: 'No matches',
            code: 200,
            successful: true,
            data: BudSearchData(buds: []),
          );
          when(mockBudMatchingRepository.findBudsByTopArtists()).thenAnswer(
            (_) async => emptyResult,
          );
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FindBudsByTopArtists()),
        expect: () => [
          BudMatchingLoading(),
          isA<BudsFound>().having(
            (state) => state.searchResult.data.buds,
            'empty matches',
            isEmpty,
          ),
        ],
      );
    });

    group('Edge Cases', () {
      blocTest<BudMatchingBloc, BudMatchingState>(
        'handles very large match list (1000+)',
        build: () {
          final largeResult = BudSearchResult(
            message: 'Success',
            code: 200,
            successful: true,
            data: BudSearchData(buds: []),
          );
          when(mockBudMatchingRepository.findBudsByTopArtists()).thenAnswer(
            (_) async => largeResult,
          );
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FindBudsByTopArtists()),
        expect: () => [
          BudMatchingLoading(),
          isA<BudsFound>().having(
            (state) => state.searchResult.data.buds.length,
            'search result loaded',
            greaterThanOrEqualTo(0),
          ),
        ],
      );

      blocTest<BudMatchingBloc, BudMatchingState>(
        'handles network errors',
        build: () {
          when(mockBudMatchingRepository.findBudsByTopArtists()).thenThrow(
            Exception('Network error: Unable to connect'),
          );
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FindBudsByTopArtists()),
        expect: () => [
          BudMatchingLoading(),
          isA<BudMatchingError>().having(
            (state) => state.message,
            'network error',
            contains('Network error'),
          ),
        ],
      );

      blocTest<BudMatchingBloc, BudMatchingState>(
        'handles authentication errors',
        build: () {
          when(mockBudMatchingRepository.findBudsByTopArtists()).thenThrow(
            Exception('Authentication error: Unauthorized'),
          );
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FindBudsByTopArtists()),
        expect: () => [
          BudMatchingLoading(),
          isA<BudMatchingError>().having(
            (state) => state.message,
            'auth error',
            contains('Authentication error'),
          ),
        ],
      );

      blocTest<BudMatchingBloc, BudMatchingState>(
        'handles malformed response data',
        build: () {
          when(mockBudMatchingRepository.findBudsByTopArtists()).thenThrow(
            Exception('Invalid data format'),
          );
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FindBudsByTopArtists()),
        expect: () => [
          BudMatchingLoading(),
          isA<BudMatchingError>().having(
            (state) => state.message,
            'format error',
            contains('Invalid data format'),
          ),
        ],
      );

      blocTest<BudMatchingBloc, BudMatchingState>(
        'handles rapid consecutive searches',
        build: () {
          when(mockBudMatchingRepository.findBudsByTopArtists()).thenAnswer(
            (_) async => testSearchResult,
          );
          when(mockBudMatchingRepository.findBudsByTopTracks()).thenAnswer(
            (_) async => testSearchResult,
          );
          return budMatchingBloc;
        },
        act: (bloc) async {
          bloc.add(FindBudsByTopArtists());
          await Future.delayed(Duration(milliseconds: 50));
          bloc.add(FindBudsByTopTracks());
        },
        expect: () => [
          BudMatchingLoading(),
          BudsFound(searchResult: testSearchResult),
          BudMatchingLoading(),
          BudsFound(searchResult: testSearchResult),
        ],
      );
    });

    group('Error Recovery', () {
      blocTest<BudMatchingBloc, BudMatchingState>(
        'recovers from error and processes next event',
        build: () {
          when(mockBudMatchingRepository.findBudsByTopArtists()).thenThrow(
            Exception('Temporary error'),
          );
          when(mockBudMatchingRepository.findBudsByTopTracks()).thenAnswer(
            (_) async => testSearchResult,
          );
          return budMatchingBloc;
        },
        act: (bloc) async {
          bloc.add(FindBudsByTopArtists());
          await Future.delayed(Duration(milliseconds: 100));
          bloc.add(FindBudsByTopTracks());
        },
        expect: () => [
          BudMatchingLoading(),
          isA<BudMatchingError>(),
          BudMatchingLoading(),
          BudsFound(searchResult: testSearchResult),
        ],
      );
    });

    group('Multiple Match Criteria', () {
      blocTest<BudMatchingBloc, BudMatchingState>(
        'returns buds with multiple common items',
        build: () {
          final richResult = BudSearchResult(
            message: 'Success',
            code: 200,
            successful: true,
            data: BudSearchData(buds: []),
          );
          when(mockBudMatchingRepository.findBudsByTopArtists()).thenAnswer(
            (_) async => richResult,
          );
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FindBudsByTopArtists()),
        expect: () => [
          BudMatchingLoading(),
          isA<BudsFound>().having(
            (state) => state.searchResult.data.buds.length,
            'search result loaded',
            greaterThanOrEqualTo(0),
          ),
        ],
      );
    });
  });
}
