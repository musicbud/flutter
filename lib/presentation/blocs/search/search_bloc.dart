import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/search_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository repository;
  Timer? _debounceTimer;
  static const _debounceDuration = Duration(milliseconds: 300);

  SearchBloc({required this.repository}) : super(SearchInitial()) {
    on<PerformSearch>(_onPerformSearch);
    on<GetSearchSuggestions>(_onGetSearchSuggestions);
    on<GetRecentSearches>(_onGetRecentSearches);
    on<ClearRecentSearches>(_onClearRecentSearches);
    on<GetTrendingSearches>(_onGetTrendingSearches);
    on<ApplySearchFilters>(_onApplySearchFilters);
    on<FilterByTypes>(_onFilterByTypes);
    on<ResetSearch>(_onResetSearch);
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }

  void _debounce(Function() action) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDuration, action);
  }

  Future<void> _onPerformSearch(
    PerformSearch event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SearchEmpty(event.query));
      return;
    }

    emit(SearchLoading());
    
    final result = await repository.search(
      query: event.query,
      types: event.types,
      filters: event.filters,
      page: event.page,
      pageSize: event.pageSize,
    );

    await result.fold(
      (failure) async => emit(const SearchError('Failed to perform search')),
      (searchResults) async {
        if (event.saveToRecent && searchResults.items.isNotEmpty) {
          await repository.saveRecentSearch(event.query);
        }
        
        if (searchResults.items.isEmpty) {
          emit(SearchEmpty(event.query));
        } else {
          emit(SearchResultsLoaded(
            results: searchResults,
            query: event.query,
            selectedTypes: event.types,
            activeFilters: event.filters,
          ));
        }
      },
    );
  }

  Future<void> _onGetSearchSuggestions(
    GetSearchSuggestions event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      return;
    }

    _debounce(() async {
      final result = await repository.getSuggestions(
        query: event.query,
        limit: event.limit,
      );

      result.fold(
        (failure) => emit(const SearchError('Failed to get suggestions')),
        (suggestions) => emit(SearchSuggestionsLoaded(
          suggestions: suggestions,
          query: event.query,
        )),
      );
    });
  }

  Future<void> _onGetRecentSearches(
    GetRecentSearches event,
    Emitter<SearchState> emit,
  ) async {
    final result = await repository.getRecentSearches(limit: event.limit);
    
    result.fold(
      (failure) => emit(const SearchError('Failed to get recent searches')),
      (searches) => emit(RecentSearchesLoaded(searches)),
    );
  }

  Future<void> _onClearRecentSearches(
    ClearRecentSearches event,
    Emitter<SearchState> emit,
  ) async {
    final result = await repository.clearRecentSearches();
    
    result.fold(
      (failure) => emit(const SearchError('Failed to clear recent searches')),
      (_) => emit(const RecentSearchesLoaded([])),
    );
  }

  Future<void> _onGetTrendingSearches(
    GetTrendingSearches event,
    Emitter<SearchState> emit,
  ) async {
    final result = await repository.getTrendingSearches(limit: event.limit);
    
    result.fold(
      (failure) => emit(const SearchError('Failed to get trending searches')),
      (searches) => emit(TrendingSearchesLoaded(searches)),
    );
  }

  Future<void> _onApplySearchFilters(
    ApplySearchFilters event,
    Emitter<SearchState> emit,
  ) async {
    final currentState = state;
    if (currentState is SearchResultsLoaded) {
      add(PerformSearch(
        query: currentState.query,
        types: currentState.selectedTypes,
        filters: event.filters,
        saveToRecent: false,
      ));
    }
  }

  Future<void> _onFilterByTypes(
    FilterByTypes event,
    Emitter<SearchState> emit,
  ) async {
    final currentState = state;
    if (currentState is SearchResultsLoaded) {
      add(PerformSearch(
        query: currentState.query,
        types: event.types,
        filters: currentState.activeFilters,
        saveToRecent: false,
      ));
    }
  }

  void _onResetSearch(
    ResetSearch event,
    Emitter<SearchState> emit,
  ) {
    emit(SearchInitial());
  }
}
