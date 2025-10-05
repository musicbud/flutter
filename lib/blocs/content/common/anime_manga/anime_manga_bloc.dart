import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/repositories/common_items_repository.dart';
import 'anime_manga_event.dart';
import 'anime_manga_state.dart';

class CommonAnimeMangaBloc extends Bloc<AnimeMangaEvent, AnimeMangaState> {
  final CommonItemsRepository _repository;

  CommonAnimeMangaBloc({required CommonItemsRepository repository})
      : _repository = repository,
        super(AnimeMangaInitial()) {
    on<CommonTopAnimeRequested>(_onCommonTopAnimeRequested);
    on<CommonTopMangaRequested>(_onCommonTopMangaRequested);
  }

  Future<void> _onCommonTopAnimeRequested(
    CommonTopAnimeRequested event,
    Emitter<AnimeMangaState> emit,
  ) async {
    emit(AnimeMangaLoading());
    final result = await _repository.getCommonTopAnime(event.username);
    result.fold(
      (failure) => emit(AnimeMangaFailure(failure.message)),
      (anime) => emit(CommonTopAnimeLoaded(anime)),
    );
  }

  Future<void> _onCommonTopMangaRequested(
    CommonTopMangaRequested event,
    Emitter<AnimeMangaState> emit,
  ) async {
    emit(AnimeMangaLoading());
    final result = await _repository.getCommonTopManga(event.username);
    result.fold(
      (failure) => emit(AnimeMangaFailure(failure.message)),
      (manga) => emit(CommonTopMangaLoaded(manga)),
    );
  }
}
