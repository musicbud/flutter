import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/common_items_repository.dart';
import 'common_event.dart';
import 'common_state.dart';

class CommonBloc extends Bloc<CommonEvent, CommonState> {
  final CommonItemsRepository _repository;

  CommonBloc({required CommonItemsRepository repository})
      : _repository = repository,
        super(CommonInitial()) {
    on<CommonLikedTracksRequested>(_onCommonLikedTracksRequested);
    on<CommonLikedArtistsRequested>(_onCommonLikedArtistsRequested);
    on<CommonLikedAlbumsRequested>(_onCommonLikedAlbumsRequested);
    on<CommonPlayedTracksRequested>(_onCommonPlayedTracksRequested);
    on<CommonTopArtistsRequested>(_onCommonTopArtistsRequested);
    on<CommonTopGenresRequested>(_onCommonTopGenresRequested);
    on<CommonTopAnimeRequested>(_onCommonTopAnimeRequested);
    on<CommonTopMangaRequested>(_onCommonTopMangaRequested);
    on<CommonTracksRequested>(_onCommonTracksRequested);
    on<CommonArtistsRequested>(_onCommonArtistsRequested);
    on<CommonGenresRequested>(_onCommonGenresRequested);
    on<CategorizedCommonItemsRequested>(_onCategorizedCommonItemsRequested);
  }

  Future<void> _onCommonLikedTracksRequested(
    CommonLikedTracksRequested event,
    Emitter<CommonState> emit,
  ) async {
    emit(CommonLoading());
    final result = await _repository.getCommonLikedTracks(event.username);
    result.fold(
      (failure) => emit(CommonFailure(failure.message)),
      (tracks) => emit(CommonLikedTracksLoaded(tracks)),
    );
  }

  Future<void> _onCommonLikedArtistsRequested(
    CommonLikedArtistsRequested event,
    Emitter<CommonState> emit,
  ) async {
    emit(CommonLoading());
    final result = await _repository.getCommonLikedArtists(event.username);
    result.fold(
      (failure) => emit(CommonFailure(failure.message)),
      (artists) => emit(CommonLikedArtistsLoaded(artists)),
    );
  }

  Future<void> _onCommonLikedAlbumsRequested(
    CommonLikedAlbumsRequested event,
    Emitter<CommonState> emit,
  ) async {
    emit(CommonLoading());
    final result = await _repository.getCommonLikedAlbums(event.username);
    result.fold(
      (failure) => emit(CommonFailure(failure.message)),
      (albums) => emit(CommonLikedAlbumsLoaded(albums)),
    );
  }

  Future<void> _onCommonPlayedTracksRequested(
    CommonPlayedTracksRequested event,
    Emitter<CommonState> emit,
  ) async {
    emit(CommonLoading());
    final result = await _repository.getCommonPlayedTracks(event.identifier,
        page: event.page);
    result.fold(
      (failure) => emit(CommonFailure(failure.message)),
      (tracks) => emit(CommonPlayedTracksLoaded(tracks)),
    );
  }

  Future<void> _onCommonTopArtistsRequested(
    CommonTopArtistsRequested event,
    Emitter<CommonState> emit,
  ) async {
    emit(CommonLoading());
    final result = await _repository.getCommonTopArtists(event.username);
    result.fold(
      (failure) => emit(CommonFailure(failure.message)),
      (artists) => emit(CommonTopArtistsLoaded(artists)),
    );
  }

  Future<void> _onCommonTopGenresRequested(
    CommonTopGenresRequested event,
    Emitter<CommonState> emit,
  ) async {
    emit(CommonLoading());
    final result = await _repository.getCommonTopGenres(event.username);
    result.fold(
      (failure) => emit(CommonFailure(failure.message)),
      (genres) => emit(CommonTopGenresLoaded(genres)),
    );
  }

  Future<void> _onCommonTopAnimeRequested(
    CommonTopAnimeRequested event,
    Emitter<CommonState> emit,
  ) async {
    emit(CommonLoading());
    final result = await _repository.getCommonTopAnime(event.username);
    result.fold(
      (failure) => emit(CommonFailure(failure.message)),
      (anime) => emit(CommonTopAnimeLoaded(anime)),
    );
  }

  Future<void> _onCommonTopMangaRequested(
    CommonTopMangaRequested event,
    Emitter<CommonState> emit,
  ) async {
    emit(CommonLoading());
    final result = await _repository.getCommonTopManga(event.username);
    result.fold(
      (failure) => emit(CommonFailure(failure.message)),
      (manga) => emit(CommonTopMangaLoaded(manga)),
    );
  }

  Future<void> _onCommonTracksRequested(
    CommonTracksRequested event,
    Emitter<CommonState> emit,
  ) async {
    emit(CommonLoading());
    final result = await _repository.getCommonTracks(event.budUid);
    result.fold(
      (failure) => emit(CommonFailure(failure.message)),
      (tracks) => emit(CommonTracksLoaded(tracks)),
    );
  }

  Future<void> _onCommonArtistsRequested(
    CommonArtistsRequested event,
    Emitter<CommonState> emit,
  ) async {
    emit(CommonLoading());
    final result = await _repository.getCommonArtists(event.budUid);
    result.fold(
      (failure) => emit(CommonFailure(failure.message)),
      (artists) => emit(CommonArtistsLoaded(artists)),
    );
  }

  Future<void> _onCommonGenresRequested(
    CommonGenresRequested event,
    Emitter<CommonState> emit,
  ) async {
    emit(CommonLoading());
    final result = await _repository.getCommonGenres(event.budUid);
    result.fold(
      (failure) => emit(CommonFailure(failure.message)),
      (genres) => emit(CommonGenresLoaded(genres)),
    );
  }

  Future<void> _onCategorizedCommonItemsRequested(
    CategorizedCommonItemsRequested event,
    Emitter<CommonState> emit,
  ) async {
    emit(CommonLoading());
    final result = await _repository.getCategorizedCommonItems(event.username);
    result.fold(
      (failure) => emit(CommonFailure(failure.message)),
      (items) => emit(CategorizedCommonItemsLoaded(items)),
    );
  }
}
