import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/repositories/common_items_repository.dart';
import 'genre_event.dart';
import 'genre_state.dart';

class CommonGenreBloc extends Bloc<GenreEvent, GenreState> {
  final CommonItemsRepository _repository;

  CommonGenreBloc({required CommonItemsRepository repository})
      : _repository = repository,
        super(GenreInitial()) {
    on<CommonTopGenresRequested>(_onCommonTopGenresRequested);
    on<CommonGenresRequested>(_onCommonGenresRequested);
  }

  Future<void> _onCommonTopGenresRequested(
    CommonTopGenresRequested event,
    Emitter<GenreState> emit,
  ) async {
    emit(GenreLoading());
    final result = await _repository.getCommonTopGenres(event.username);
    result.fold(
      (failure) => emit(GenreFailure(failure.message)),
      (genres) => emit(CommonTopGenresLoaded(genres)),
    );
  }

  Future<void> _onCommonGenresRequested(
    CommonGenresRequested event,
    Emitter<GenreState> emit,
  ) async {
    emit(GenreLoading());
    final result = await _repository.getCommonGenres(event.budUid);
    result.fold(
      (failure) => emit(GenreFailure(failure.message)),
      (genres) => emit(CommonGenresLoaded(genres)),
    );
  }
}
