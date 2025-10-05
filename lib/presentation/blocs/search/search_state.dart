import 'package:equatable/equatable.dart';
import '../../../domain/models/search.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchResultsLoaded extends SearchState {
  final SearchResults results;
  final String query;
  final List<String>? selectedTypes;
  final Map<String, dynamic>? activeFilters;

  const SearchResultsLoaded({
    required this.results,
    required this.query,
    this.selectedTypes,
    this.activeFilters,
  });

  @override
  List<Object?> get props => [results, query, selectedTypes, activeFilters];

  SearchResultsLoaded copyWith({
    SearchResults? results,
    String? query,
    List<String>? selectedTypes,
    Map<String, dynamic>? activeFilters,
  }) {
    return SearchResultsLoaded(
      results: results ?? this.results,
      query: query ?? this.query,
      selectedTypes: selectedTypes ?? this.selectedTypes,
      activeFilters: activeFilters ?? this.activeFilters,
    );
  }
}

class SearchSuggestionsLoaded extends SearchState {
  final List<String> suggestions;
  final String query;

  const SearchSuggestionsLoaded({
    required this.suggestions,
    required this.query,
  });

  @override
  List<Object?> get props => [suggestions, query];
}

class RecentSearchesLoaded extends SearchState {
  final List<String> searches;

  const RecentSearchesLoaded(this.searches);

  @override
  List<Object?> get props => [searches];
}

class TrendingSearchesLoaded extends SearchState {
  final List<String> searches;

  const TrendingSearchesLoaded(this.searches);

  @override
  List<Object?> get props => [searches];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}

class SearchEmpty extends SearchState {
  final String query;

  const SearchEmpty(this.query);

  @override
  List<Object?> get props => [query];
}
