import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/content_repository.dart';
import 'genre_event.dart';
import 'genre_state.dart';

class GenreBloc extends Bloc<GenreEvent, GenreState> {
  final ContentRepository _contentRepository;

  GenreBloc({required ContentRepository contentRepository})
      : _contentRepository = contentRepository,
        super(GenreInitial()) {
    // Top content
    on<TopGenresRequested>(_onTopGenresRequested);

    // Liked content
    on<LikedGenresRequested>(_onLikedGenresRequested);

    // Like/Unlike operations
    on<GenreLiked>(_onGenreLiked);
    on<GenreUnliked>(_onGenreUnliked);

    // Search operations
    on<GenresSearched>(_onGenresSearched);
  }

  Future<void> _onTopGenresRequested(
    TopGenresRequested event,
    Emitter<GenreState> emit,
  ) async {
    try {
      emit(GenreLoading());
      final genres = await _contentRepository.getTopGenres();
      emit(TopGenresLoaded(genres));
    } catch (error) {
      emit(GenreFailure(error.toString()));
    }
  }

  Future<void> _onLikedGenresRequested(
    LikedGenresRequested event,
    Emitter<GenreState> emit,
  ) async {
    try {
      emit(GenreLoading());
      final genres = await _contentRepository.getLikedGenres();
      emit(LikedGenresLoaded(genres));
    } catch (error) {
      emit(GenreFailure(error.toString()));
    }
  }

  Future<void> _onGenreLiked(
    GenreLiked event,
    Emitter<GenreState> emit,
  ) async {
    try {
      emit(GenreLoading());
      await _contentRepository.likeGenre(event.id);
      emit(GenreLikeSuccess());
    } catch (error) {
      emit(GenreFailure(error.toString()));
    }
  }

  Future<void> _onGenreUnliked(
    GenreUnliked event,
    Emitter<GenreState> emit,
  ) async {
    try {
      emit(GenreLoading());
      await _contentRepository.unlikeGenre(event.id);
      emit(GenreUnlikeSuccess());
    } catch (error) {
      emit(GenreFailure(error.toString()));
    }
  }

  Future<void> _onGenresSearched(
    GenresSearched event,
    Emitter<GenreState> emit,
  ) async {
    try {
      emit(GenreLoading());
      final genres = await _contentRepository.searchGenres(event.query);
      emit(GenresSearchResultLoaded(genres));
    } catch (error) {
      emit(GenreFailure(error.toString()));
    }
  }
}
