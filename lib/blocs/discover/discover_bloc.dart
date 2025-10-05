import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/discover_repository.dart';
import 'discover_event.dart';
import 'discover_state.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final DiscoverRepository repository;

  DiscoverBloc({required this.repository}) : super(const DiscoverInitial()) {
    on<DiscoverPageLoaded>(_onPageLoaded);
    on<DiscoverCategorySelected>(_onCategorySelected);
    on<DiscoverRefreshRequested>(_onRefreshRequested);
    on<DiscoverItemInteracted>(_onItemInteracted);
  }

  Future<void> _onPageLoaded(
    DiscoverPageLoaded event,
    Emitter<DiscoverState> emit,
  ) async {
    try {
      emit(const DiscoverLoading());
      
      final categories = await repository.getCategories();
      if (categories.isEmpty) {
        emit(const DiscoverError('No categories available'));
        return;
      }

      final items = await repository.getDiscoverItems(categories.first);
      
      emit(DiscoverLoaded(
        items: items,
        categories: categories,
        selectedCategory: categories.first,
      ));
    } catch (e) {
      emit(DiscoverError(e.toString()));
    }
  }

  Future<void> _onCategorySelected(
    DiscoverCategorySelected event,
    Emitter<DiscoverState> emit,
  ) async {
    if (state is! DiscoverLoaded) return;
    final currentState = state as DiscoverLoaded;

    try {
      emit(currentState.copyWith(isRefreshing: true));
      
      final items = await repository.getDiscoverItems(event.categoryId);
      
      emit(currentState.copyWith(
        items: items,
        selectedCategory: event.categoryId,
        isRefreshing: false,
      ));
    } catch (e) {
      emit(DiscoverError(e.toString()));
    }
  }

  Future<void> _onRefreshRequested(
    DiscoverRefreshRequested event,
    Emitter<DiscoverState> emit,
  ) async {
    if (state is! DiscoverLoaded) return;
    final currentState = state as DiscoverLoaded;

    try {
      emit(currentState.copyWith(isRefreshing: true));
      
      final items = await repository.getDiscoverItems(currentState.selectedCategory);
      
      emit(currentState.copyWith(
        items: items,
        isRefreshing: false,
      ));
    } catch (e) {
      emit(DiscoverError(e.toString()));
    }
  }

  Future<void> _onItemInteracted(
    DiscoverItemInteracted event,
    Emitter<DiscoverState> emit,
  ) async {
    try {
      await repository.trackInteraction(
        itemId: event.itemId,
        type: event.type,
        action: event.action,
      );
    } catch (e) {
      // Silently handle interaction tracking errors
      debugPrint('Failed to track interaction: ${e.toString()}');
    }
  }
}
