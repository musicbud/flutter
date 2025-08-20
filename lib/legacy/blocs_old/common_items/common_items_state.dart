import 'package:equatable/equatable.dart';

abstract class CommonItemsState<T> extends Equatable {
  const CommonItemsState();

  @override
  List<Object?> get props => [];
}

class CommonItemsInitial<T> extends CommonItemsState<T> {}

class CommonItemsLoading<T> extends CommonItemsState<T> {}

class CommonItemsLoadingMore<T> extends CommonItemsState<T> {
  final List<T> currentItems;

  const CommonItemsLoadingMore(this.currentItems);

  @override
  List<Object> get props => [currentItems];
}

class CommonItemsLoaded<T> extends CommonItemsState<T> {
  final List<T> items;
  final bool hasReachedEnd;
  final int currentPage;
  final String? searchQuery;

  const CommonItemsLoaded({
    required this.items,
    this.hasReachedEnd = false,
    this.currentPage = 1,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [items, hasReachedEnd, currentPage, searchQuery];

  CommonItemsLoaded<T> copyWith({
    List<T>? items,
    bool? hasReachedEnd,
    int? currentPage,
    String? searchQuery,
  }) {
    return CommonItemsLoaded<T>(
      items: items ?? this.items,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class CommonItemsFailure<T> extends CommonItemsState<T> {
  final String error;

  const CommonItemsFailure(this.error);

  @override
  List<Object> get props => [error];
}
