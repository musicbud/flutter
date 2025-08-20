import 'package:flutter_bloc/flutter_bloc.dart';
import 'common_items_event.dart';
import 'common_items_state.dart';

class CommonItemsBloc<T> extends Bloc<CommonItemsEvent, CommonItemsState<T>> {
  final Future<List<T>> Function(int page, String? query) fetchItems;
  static const int _pageSize = 20;

  CommonItemsBloc({
    required this.fetchItems,
  }) : super(CommonItemsInitial<T>()) {
    on<CommonItemsRequested>(_onCommonItemsRequested);
    on<CommonItemsLoadMoreRequested>(_onCommonItemsLoadMoreRequested);
    on<CommonItemsRefreshRequested>(_onCommonItemsRefreshRequested);
    on<CommonItemsSearchRequested>(_onCommonItemsSearchRequested);
  }

  Future<void> _onCommonItemsRequested(
    CommonItemsRequested event,
    Emitter<CommonItemsState<T>> emit,
  ) async {
    emit(CommonItemsLoading<T>());
    try {
      final items = await fetchItems(event.page, null);
      final hasReachedEnd = items.length < _pageSize;
      emit(CommonItemsLoaded<T>(
        items: items,
        hasReachedEnd: hasReachedEnd,
        currentPage: event.page,
      ));
    } catch (e) {
      emit(CommonItemsFailure<T>(e.toString()));
    }
  }

  Future<void> _onCommonItemsLoadMoreRequested(
    CommonItemsLoadMoreRequested event,
    Emitter<CommonItemsState<T>> emit,
  ) async {
    if (state is CommonItemsLoaded<T>) {
      final currentState = state as CommonItemsLoaded<T>;
      if (currentState.hasReachedEnd) return;

      emit(CommonItemsLoadingMore<T>(currentState.items));
      try {
        final nextPage = currentState.currentPage + 1;
        final moreItems = await fetchItems(nextPage, currentState.searchQuery);
        final hasReachedEnd = moreItems.length < _pageSize;

        emit(currentState.copyWith(
          items: [...currentState.items, ...moreItems],
          hasReachedEnd: hasReachedEnd,
          currentPage: nextPage,
        ));
      } catch (e) {
        emit(CommonItemsFailure<T>(e.toString()));
      }
    }
  }

  Future<void> _onCommonItemsRefreshRequested(
    CommonItemsRefreshRequested event,
    Emitter<CommonItemsState<T>> emit,
  ) async {
    try {
      final items = await fetchItems(1, null);
      final hasReachedEnd = items.length < _pageSize;
      emit(CommonItemsLoaded<T>(
        items: items,
        hasReachedEnd: hasReachedEnd,
        currentPage: 1,
      ));
    } catch (e) {
      emit(CommonItemsFailure<T>(e.toString()));
    }
  }

  Future<void> _onCommonItemsSearchRequested(
    CommonItemsSearchRequested event,
    Emitter<CommonItemsState<T>> emit,
  ) async {
    emit(CommonItemsLoading<T>());
    try {
      final items = await fetchItems(1, event.query);
      final hasReachedEnd = items.length < _pageSize;
      emit(CommonItemsLoaded<T>(
        items: items,
        hasReachedEnd: hasReachedEnd,
        currentPage: 1,
        searchQuery: event.query,
      ));
    } catch (e) {
      emit(CommonItemsFailure<T>(e.toString()));
    }
  }
}
