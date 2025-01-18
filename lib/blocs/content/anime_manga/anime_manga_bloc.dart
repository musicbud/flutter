import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/content_repository.dart';
import 'anime_manga_event.dart';
import 'anime_manga_state.dart';

class AnimeMangaBloc extends Bloc<AnimeMangaEvent, AnimeMangaState> {
  final ContentRepository _contentRepository;

  AnimeMangaBloc({required ContentRepository contentRepository})
      : _contentRepository = contentRepository,
        super(AnimeMangaInitial()) {
    // Popular content
    on<PopularAnimeRequested>(_onPopularAnimeRequested);
    on<PopularMangaRequested>(_onPopularMangaRequested);

    // Top content
    on<TopAnimeRequested>(_onTopAnimeRequested);
    on<TopMangaRequested>(_onTopMangaRequested);

    // Like/Unlike operations
    on<AnimeLiked>(_onAnimeLiked);
    on<MangaLiked>(_onMangaLiked);
    on<AnimeUnliked>(_onAnimeUnliked);
    on<MangaUnliked>(_onMangaUnliked);

    // Search operations
    on<AnimeSearched>(_onAnimeSearched);
    on<MangaSearched>(_onMangaSearched);
  }

  Future<void> _onPopularAnimeRequested(
    PopularAnimeRequested event,
    Emitter<AnimeMangaState> emit,
  ) async {
    try {
      emit(AnimeMangaLoading());
      final anime =
          await _contentRepository.getPopularAnime(limit: event.limit);
      emit(PopularAnimeLoaded(anime));
    } catch (error) {
      emit(AnimeMangaFailure(error.toString()));
    }
  }

  Future<void> _onPopularMangaRequested(
    PopularMangaRequested event,
    Emitter<AnimeMangaState> emit,
  ) async {
    try {
      emit(AnimeMangaLoading());
      final manga =
          await _contentRepository.getPopularManga(limit: event.limit);
      emit(PopularMangaLoaded(manga));
    } catch (error) {
      emit(AnimeMangaFailure(error.toString()));
    }
  }

  Future<void> _onTopAnimeRequested(
    TopAnimeRequested event,
    Emitter<AnimeMangaState> emit,
  ) async {
    try {
      emit(AnimeMangaLoading());
      final anime = await _contentRepository.getTopAnime();
      emit(TopAnimeLoaded(anime));
    } catch (error) {
      emit(AnimeMangaFailure(error.toString()));
    }
  }

  Future<void> _onTopMangaRequested(
    TopMangaRequested event,
    Emitter<AnimeMangaState> emit,
  ) async {
    try {
      emit(AnimeMangaLoading());
      final manga = await _contentRepository.getTopManga();
      emit(TopMangaLoaded(manga));
    } catch (error) {
      emit(AnimeMangaFailure(error.toString()));
    }
  }

  Future<void> _onAnimeLiked(
    AnimeLiked event,
    Emitter<AnimeMangaState> emit,
  ) async {
    try {
      emit(AnimeMangaLoading());
      await _contentRepository.likeAnime(event.id);
      emit(AnimeLikeSuccess());
    } catch (error) {
      emit(AnimeMangaFailure(error.toString()));
    }
  }

  Future<void> _onMangaLiked(
    MangaLiked event,
    Emitter<AnimeMangaState> emit,
  ) async {
    try {
      emit(AnimeMangaLoading());
      await _contentRepository.likeManga(event.id);
      emit(MangaLikeSuccess());
    } catch (error) {
      emit(AnimeMangaFailure(error.toString()));
    }
  }

  Future<void> _onAnimeUnliked(
    AnimeUnliked event,
    Emitter<AnimeMangaState> emit,
  ) async {
    try {
      emit(AnimeMangaLoading());
      await _contentRepository.unlikeAnime(event.id);
      emit(AnimeUnlikeSuccess());
    } catch (error) {
      emit(AnimeMangaFailure(error.toString()));
    }
  }

  Future<void> _onMangaUnliked(
    MangaUnliked event,
    Emitter<AnimeMangaState> emit,
  ) async {
    try {
      emit(AnimeMangaLoading());
      await _contentRepository.unlikeManga(event.id);
      emit(MangaUnlikeSuccess());
    } catch (error) {
      emit(AnimeMangaFailure(error.toString()));
    }
  }

  Future<void> _onAnimeSearched(
    AnimeSearched event,
    Emitter<AnimeMangaState> emit,
  ) async {
    try {
      emit(AnimeMangaLoading());
      final anime = await _contentRepository.searchAnime(event.query);
      emit(AnimeSearchResultLoaded(anime));
    } catch (error) {
      emit(AnimeMangaFailure(error.toString()));
    }
  }

  Future<void> _onMangaSearched(
    MangaSearched event,
    Emitter<AnimeMangaState> emit,
  ) async {
    try {
      emit(AnimeMangaLoading());
      final manga = await _contentRepository.searchManga(event.query);
      emit(MangaSearchResultLoaded(manga));
    } catch (error) {
      emit(AnimeMangaFailure(error.toString()));
    }
  }
}
