import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/content_repository.dart';
import '../../domain/repositories/bud_repository.dart';
import 'genre_event.dart';
import 'genre_state.dart';

class GenreBloc extends Bloc<GenreEvent, GenreState> {
  final ContentRepository _contentRepository;
  final BudRepository _budRepository;

  GenreBloc({
    required ContentRepository contentRepository,
    required BudRepository budRepository,
  })  : _contentRepository = contentRepository,
        _budRepository = budRepository,
        super(GenreInitial()) {
    on<GenreDetailsRequested>(_onGenreDetailsRequested);
    on<GenreBudsRequested>(_onGenreBudsRequested);
    on<GenreLikeToggled>(_onGenreLikeToggled);
  }

  Future<void> _onGenreDetailsRequested(
    GenreDetailsRequested event,
    Emitter<GenreState> emit,
  ) async {
    emit(GenreLoading());
    try {
      final genre = await _contentRepository.getGenreDetails(event.genreId);
      final buds = await _budRepository.getBudsByGenre(event.genreId);
      emit(GenreDetailsLoaded(genre: genre, buds: buds));
    } catch (e) {
      emit(GenreFailure(e.toString()));
    }
  }

  Future<void> _onGenreBudsRequested(
    GenreBudsRequested event,
    Emitter<GenreState> emit,
  ) async {
    emit(GenreLoading());
    try {
      final buds = await _budRepository.getBudsByGenre(event.genreId);
      if (state is GenreDetailsLoaded) {
        final currentState = state as GenreDetailsLoaded;
        emit(GenreDetailsLoaded(genre: currentState.genre, buds: buds));
      }
    } catch (e) {
      emit(GenreFailure(e.toString()));
    }
  }

  Future<void> _onGenreLikeToggled(
    GenreLikeToggled event,
    Emitter<GenreState> emit,
  ) async {
    try {
      await _contentRepository.toggleGenreLike(event.genreId);
      if (state is GenreDetailsLoaded) {
        final currentState = state as GenreDetailsLoaded;
        final updatedGenre =
            currentState.genre.copyWith(isLiked: !currentState.genre.isLiked);
        emit(GenreLikeStatusChanged(!currentState.genre.isLiked));
        emit(GenreDetailsLoaded(genre: updatedGenre, buds: currentState.buds));
      }
    } catch (e) {
      emit(GenreFailure(e.toString()));
    }
  }
}
