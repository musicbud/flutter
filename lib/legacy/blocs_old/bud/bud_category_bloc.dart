import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/content_repository.dart';
import 'bud_category_event.dart';
import 'bud_category_state.dart';

class BudCategoryBloc extends Bloc<BudCategoryEvent, BudCategoryState> {
  final ContentRepository _contentRepository;

  BudCategoryBloc({
    required ContentRepository contentRepository,
  })  : _contentRepository = contentRepository,
        super(BudCategoryInitial()) {
    on<BudCategoriesRequested>(_onBudCategoriesRequested);
    on<BudCategoriesRefreshRequested>(_onBudCategoriesRefreshRequested);
    on<BudCategorySelected>(_onBudCategorySelected);
  }

  Future<void> _onBudCategoriesRequested(
    BudCategoriesRequested event,
    Emitter<BudCategoryState> emit,
  ) async {
    emit(BudCategoryLoading());
    try {
      final categories = await _getAvailableCategories();
      emit(BudCategoryLoaded(categories: categories));
    } catch (e) {
      emit(BudCategoryFailure(e.toString()));
    }
  }

  Future<void> _onBudCategoriesRefreshRequested(
    BudCategoriesRefreshRequested event,
    Emitter<BudCategoryState> emit,
  ) async {
    try {
      final categories = await _getAvailableCategories();
      if (state is BudCategoryLoaded) {
        final currentState = state as BudCategoryLoaded;
        emit(currentState.copyWith(categories: categories));
      } else {
        emit(BudCategoryLoaded(categories: categories));
      }
    } catch (e) {
      emit(BudCategoryFailure(e.toString()));
    }
  }

  void _onBudCategorySelected(
    BudCategorySelected event,
    Emitter<BudCategoryState> emit,
  ) {
    if (state is BudCategoryLoaded) {
      final currentState = state as BudCategoryLoaded;
      emit(currentState.copyWith(
        selectedCategory: event.category,
        selectedIndex: event.index,
      ));
    }
  }

  Future<List<String>> _getAvailableCategories() async {
    final categories = <String>[];

    try {
      // Check if music services are connected by trying to get top tracks
      await _contentRepository.getTopTracks();

      // If we get here, music services are connected
      categories.addAll([
        'liked/artists',
        'liked/tracks',
        'liked/genres',
        'liked/aio',
        'top/artists',
        'top/tracks',
        'top/genres',
      ]);

      // Check if location tracking is available by trying to get played tracks
      try {
        await _contentRepository.getTopTracks();
        categories.add('played/tracks');
      } catch (_) {
        // Location tracking not available, skip adding played/tracks
      }
    } catch (_) {
      // Music services not connected, don't add any categories
    }

    return categories;
  }
}
