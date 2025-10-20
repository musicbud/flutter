/// Comprehensive BudMatchingBloc Tests

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:musicbud_flutter/blocs/bud_matching/bud_matching_bloc.dart';
import 'package:musicbud_flutter/domain/repositories/bud_matching_repository.dart';
import '../../test_config.dart';

@GenerateMocks([BudMatchingRepository])
import 'bud_matching_bloc_test.mocks.dart';

void main() {
  group('BudMatchingBloc Tests', () {
    late BudMatchingBloc budMatchingBloc;
    late MockBudMatchingRepository mockRepository;

    setUp(() {
      TestLogger.log('Setting up BudMatchingBloc test');
      mockRepository = MockBudMatchingRepository();
      budMatchingBloc = BudMatchingBloc(budMatchingRepository: mockRepository);
    });

    tearDown(() {
      TestLogger.log('Tearing down BudMatchingBloc test');
      budMatchingBloc.close();
    });

    test('initial state is BudMatchingInitial', () {
      expect(budMatchingBloc.state, isA<BudMatchingInitial>());
      TestLogger.logSuccess('Initial state verified');
    });

    group('FindBudsByTopArtists', () {
      blocTest<BudMatchingBloc, BudMatchingState>(
        'emits [Loading, BudsFound] when buds found successfully',
        build: () {
          when(mockRepository.findBudsByTopArtists())
              .thenAnswer((_) async => TestDataGenerator.generateBudSearchResult(10));
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FindBudsByTopArtists()),
        expect: () => [
          isA<BudMatchingLoading>(),
          isA<BudsFound>(),
        ],
        verify: (_) {
          verify(mockRepository.findBudsByTopArtists()).called(1);
          TestLogger.logSuccess('Buds found by top artists');
        },
      );

      blocTest<BudMatchingBloc, BudMatchingState>(
        'emits [Loading, Error] when finding fails',
        build: () {
          when(mockRepository.findBudsByTopArtists())
              .thenThrow(Exception('Failed to find buds'));
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FindBudsByTopArtists()),
        expect: () => [
          isA<BudMatchingLoading>(),
          isA<BudMatchingError>(),
        ],
      );
    });

    group('FetchBudProfile', () {
      blocTest<BudMatchingBloc, BudMatchingState>(
        'fetches bud profile successfully',
        build: () {
          when(mockRepository.fetchBudProfile(any))
              .thenAnswer((_) async => TestDataGenerator.generateBudProfile());
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(const FetchBudProfile(budId: 'bud_id')),
        expect: () => [
          isA<BudMatchingLoading>(),
          isA<BudProfileLoaded>(),
        ],
        verify: (_) {
          verify(mockRepository.fetchBudProfile('bud_id')).called(1);
        },
      );

      blocTest<BudMatchingBloc, BudMatchingState>(
        'handles fetch profile failure',
        build: () {
          when(mockRepository.fetchBudProfile(any))
              .thenThrow(Exception('Failed to fetch profile'));
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(const FetchBudProfile(budId: 'bud_id')),
        expect: () => [
          isA<BudMatchingLoading>(),
          isA<BudMatchingError>(),
        ],
      );
    });

    group('FindBudsByTopTracks', () {
      blocTest<BudMatchingBloc, BudMatchingState>(
        'finds buds by top tracks successfully',
        build: () {
          when(mockRepository.findBudsByTopTracks())
              .thenAnswer((_) async => TestDataGenerator.generateBudSearchResult(5));
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FindBudsByTopTracks()),
        expect: () => [
          isA<BudMatchingLoading>(),
          isA<BudsFound>(),
        ],
      );
    });

    group('FindBudsByTopGenres', () {
      blocTest<BudMatchingBloc, BudMatchingState>(
        'finds buds by top genres successfully',
        build: () {
          when(mockRepository.findBudsByTopGenres())
              .thenAnswer((_) async => TestDataGenerator.generateBudSearchResult(8));
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(FindBudsByTopGenres()),
        expect: () => [
          isA<BudMatchingLoading>(),
          isA<BudsFound>(),
        ],
      );
    });

    group('FindBudsByArtist', () {
      blocTest<BudMatchingBloc, BudMatchingState>(
        'finds buds by specific artist',
        build: () {
          when(mockRepository.findBudsByArtist(any))
              .thenAnswer((_) async => TestDataGenerator.generateBudSearchResult(3));
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(const FindBudsByArtist(artistId: 'artist_123')),
        expect: () => [
          isA<BudMatchingLoading>(),
          isA<BudsFound>(),
        ],
      );
    });

    group('FindBudsByGenre', () {
      blocTest<BudMatchingBloc, BudMatchingState>(
        'finds buds by specific genre',
        build: () {
          when(mockRepository.findBudsByGenre(any))
              .thenAnswer((_) async => TestDataGenerator.generateBudSearchResult(6));
          return budMatchingBloc;
        },
        act: (bloc) => bloc.add(const FindBudsByGenre(genreId: 'rock')),
        expect: () => [
          isA<BudMatchingLoading>(),
          isA<BudsFound>(),
        ],
      );
    });

    TestLogger.logSuccess('All BudMatchingBloc tests completed');
  });
}
