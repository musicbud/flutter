import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/content_repository.dart';
import 'top_genres_event.dart';
import 'top_genres_state.dart';

class TopGenresBloc extends Bloc<TopGenresEvent, TopGenresState> {
  final ContentRepository _contentRepository;
  static const int _pageSize = 20;

  TopGenresBloc({
    required ContentRepository contentRepository,
  })  : _contentRepository = contentRepository,
        super(TopGenresInitial()) {
    on<TopGenresRequested>(_onTopGenresRequested);
    on<TopGenresLoadMoreRequested>(_onTopGenresLoadMoreRequested);
    on<TopGenresRefreshRequested>(_onTopGenresRefreshRequested);
    on<TopGenreLikeToggled>(_onTopGenreLikeToggled);
    on<TopGenreSelected>(_onTopGenreSelected);
  }

  Future<void> _onTopGenresRequested(
    TopGenresRequested event,
    Emitter<TopGenresState> emit,
  ) async {
    emit(TopGenresLoading());
    try {
      final genres = await _contentRepository.getTopGenres();
      final hasReachedEnd = genres.length < _pageSize;
      emit(TopGenresLoaded(
        genres: genres,
        hasReachedEnd: hasReachedEnd,
        currentPage: event.page,
      ));
    } catch (e) {
      emit(TopGenresFailure(e.toString()));
    }
  }

  Future<void> _onTopGenresLoadMoreRequested(
    TopGenresLoadMoreRequested event,
    Emitter<TopGenresState> emit,
  ) async {
    if (state is TopGenresLoaded) {
      final currentState = state as TopGenresLoaded;
      if (currentState.hasReachedEnd) return;

      emit(TopGenresLoadingMore(currentState.genres));
      try {
        final nextPage = currentState.currentPage + 1;
        final moreGenres = await _contentRepository.getTopGenres();
        final hasReachedEnd = moreGenres.length < _pageSize;

        emit(currentState.copyWith(
          genres: [...currentState.genres, ...moreGenres],
          hasReachedEnd: hasReachedEnd,
          currentPage: nextPage,
        ));
      } catch (e) {
        emit(TopGenresFailure(e.toString()));
      }
    }
  }

  Future<void> _onTopGenresRefreshRequested(
    TopGenresRefreshRequested event,
    Emitter<TopGenresState> emit,
  ) async {
    try {
      final genres = await _contentRepository.getTopGenres();
      final hasReachedEnd = genres.length < _pageSize;
      emit(TopGenresLoaded(
        genres: genres,
        hasReachedEnd: hasReachedEnd,
        currentPage: 1,
      ));
    } catch (e) {
      emit(TopGenresFailure(e.toString()));
    }
  }

  Future<void> _onTopGenreLikeToggled(
    TopGenreLikeToggled event,
    Emitter<TopGenresState> emit,
  ) async {
    if (state is TopGenresLoaded) {
      final currentState = state as TopGenresLoaded;
      final genreIndex =
          currentState.genres.indexWhere((g) => g.id == event.genreId);
      if (genreIndex == -1) return;

      final genre = currentState.genres[genreIndex];
      try {
        if (genre.isLiked) {
          await _contentRepository.unlikeGenre(event.genreId);
        } else {
          await _contentRepository.likeGenre(event.genreId);
        }

        emit(TopGenreLikeStatusChanged(
          genreId: event.genreId,
          isLiked: !genre.isLiked,
        ));

        final updatedGenres = List.of(currentState.genres);
        updatedGenres[genreIndex] = genre.copyWith(isLiked: !genre.isLiked);

        emit(currentState.copyWith(genres: updatedGenres));
      } catch (e) {
        emit(TopGenresFailure(e.toString()));
      }
    }
  }

  void _onTopGenreSelected(
    TopGenreSelected event,
    Emitter<TopGenresState> emit,
  ) {
    if (state is TopGenresLoaded) {
      final currentState = state as TopGenresLoaded;
      emit(currentState.copyWith(selectedGenreId: event.genreId));
    }
  }
}
