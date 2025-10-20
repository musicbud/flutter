/// Comprehensive DiscoverBloc Tests

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:musicbud_flutter/blocs/discover/discover_bloc.dart';
import 'package:musicbud_flutter/domain/repositories/discover_repository.dart';
import '../../test_config.dart';

@GenerateMocks([DiscoverRepository])
import 'discover_bloc_test.mocks.dart';

void main() {
  group('DiscoverBloc Tests', () {
    late DiscoverBloc discoverBloc;
    late MockDiscoverRepository mockRepository;

    setUp(() {
      TestLogger.log('Setting up DiscoverBloc test');
      mockRepository = MockDiscoverRepository();
      discoverBloc = DiscoverBloc(repository: mockRepository);
    });

    tearDown(() {
      TestLogger.log('Tearing down DiscoverBloc test');
      discoverBloc.close();
    });

    test('initial state is DiscoverInitial', () {
      expect(discoverBloc.state, isA<DiscoverInitial>());
      TestLogger.logSuccess('Initial state verified');
    });

    group('LoadDiscoverContent', () {
      blocTest<DiscoverBloc, DiscoverState>(
        'emits [Loading, Loaded] when content loads successfully',
        build: () {
          when(mockRepository.getDiscoverContent())
              .thenAnswer((_) async => TestDataGenerator.generateContentList(10));
          return discoverBloc;
        },
        act: (bloc) => bloc.add(LoadDiscoverContent()),
        expect: () => [
          isA<DiscoverLoading>(),
          isA<DiscoverLoaded>(),
        ],
        verify: (_) {
          verify(mockRepository.getDiscoverContent()).called(1);
          TestLogger.logSuccess('Discover content loaded');
        },
      );

      blocTest<DiscoverBloc, DiscoverState>(
        'emits [Loading, Error] when loading fails',
        build: () {
          when(mockRepository.getDiscoverContent())
              .thenThrow(Exception('Failed to load'));
          return discoverBloc;
        },
        act: (bloc) => bloc.add(LoadDiscoverContent()),
        expect: () => [
          isA<DiscoverLoading>(),
          isA<DiscoverError>(),
        ],
      );
    });

    group('RefreshDiscoverContent', () {
      blocTest<DiscoverBloc, DiscoverState>(
        'refreshes content successfully',
        build: () {
          when(mockRepository.getDiscoverContent())
              .thenAnswer((_) async => TestDataGenerator.generateContentList(10));
          return discoverBloc;
        },
        act: (bloc) => bloc.add(RefreshDiscoverContent()),
        expect: () => [
          isA<DiscoverLoading>(),
          isA<DiscoverLoaded>(),
        ],
      );
    });

    group('SearchContent', () {
      blocTest<DiscoverBloc, DiscoverState>(
        'searches content successfully',
        build: () {
          when(mockRepository.searchContent(any))
              .thenAnswer((_) async => TestDataGenerator.generateContentList(5));
          return discoverBloc;
        },
        act: (bloc) => bloc.add(const SearchContent('test query')),
        expect: () => [
          isA<DiscoverLoading>(),
          isA<DiscoverLoaded>(),
        ],
        verify: (_) {
          verify(mockRepository.searchContent('test query')).called(1);
        },
      );

      blocTest<DiscoverBloc, DiscoverState>(
        'handles empty search query',
        build: () => discoverBloc,
        act: (bloc) => bloc.add(const SearchContent('')),
        expect: () => [
          isA<DiscoverError>(),
        ],
      );
    });

    TestLogger.logSuccess('All DiscoverBloc tests completed');
  });
}
