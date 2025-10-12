import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class PerformSearch extends SearchEvent {
  final String query;
  final List<String>? types;
  final Map<String, dynamic>? filters;
  final int? page;
  final int? pageSize;
  final bool saveToRecent;

  const PerformSearch({
    required this.query,
    this.types,
    this.filters,
    this.page,
    this.pageSize,
    this.saveToRecent = true,
  });

  @override
  List<Object?> get props => [query, types, filters, page, pageSize, saveToRecent];
}

class GetSearchSuggestions extends SearchEvent {
  final String query;
  final int? limit;

  const GetSearchSuggestions({
    required this.query,
    this.limit,
  });

  @override
  List<Object?> get props => [query, limit];
}

class GetRecentSearches extends SearchEvent {
  final int? limit;

  const GetRecentSearches({this.limit});

  @override
  List<Object?> get props => [limit];
}

class ClearRecentSearches extends SearchEvent {}

class RemoveRecentSearch extends SearchEvent {
  final String search;

  const RemoveRecentSearch(this.search);

  @override
  List<Object?> get props => [search];
}

class GetTrendingSearches extends SearchEvent {
  final int? limit;

  const GetTrendingSearches({this.limit});

  @override
  List<Object?> get props => [limit];
}

class ApplySearchFilters extends SearchEvent {
  final Map<String, dynamic> filters;

  const ApplySearchFilters(this.filters);

  @override
  List<Object?> get props => [filters];
}

class FilterByTypes extends SearchEvent {
  final List<String> types;

  const FilterByTypes(this.types);

  @override
  List<Object?> get props => [types];
}

class ResetSearch extends SearchEvent {}
