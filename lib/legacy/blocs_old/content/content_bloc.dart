import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/content_repository.dart';
import 'content_event.dart';
import 'content_state.dart';

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  final ContentRepository _contentRepository;

  ContentBloc({required ContentRepository contentRepository})
      : _contentRepository = contentRepository,
        super(ContentInitial()) {
    on<LoadTopContent>(_onLoadTopContent);
    on<LoadLikedContent>(_onLoadLikedContent);
    on<LoadPlayedTracks>(_onLoadPlayedTracks);
    on<LikeItem>(_onLikeItem);
    on<UnlikeItem>(_onUnlikeItem);
    on<SearchContent>(_onSearchContent);
  }

  Future<void> _onLoadTopContent(
    LoadTopContent event,
    Emitter<ContentState> emit,
  ) async {
    try {
      emit(ContentLoading());
      final topTracks = await _contentRepository.getTopTracks();
      final topArtists = await _contentRepository.getTopArtists();
      final topGenres = await _contentRepository.getTopGenres();
      final topAnime = await _contentRepository.getTopAnime();
      final topManga = await _contentRepository.getTopManga();

      emit(ContentLoaded(
        topTracks: topTracks,
        topArtists: topArtists,
        topGenres: topGenres,
        topAnime: topAnime,
        topManga: topManga,
      ));
    } catch (e) {
      emit(ContentError(e.toString()));
    }
  }

  Future<void> _onLoadLikedContent(
    LoadLikedContent event,
    Emitter<ContentState> emit,
  ) async {
    try {
      emit(ContentLoading());
      final likedTracks = await _contentRepository.getLikedTracks();
      final likedArtists = await _contentRepository.getLikedArtists();
      final likedAlbums = await _contentRepository.getLikedAlbums();
      final likedGenres = await _contentRepository.getLikedGenres();

      if (state is ContentLoaded) {
        emit((state as ContentLoaded).copyWith(
          likedTracks: likedTracks,
          likedArtists: likedArtists,
          likedAlbums: likedAlbums,
          likedGenres: likedGenres,
        ));
      } else {
        emit(ContentLoaded(
          topTracks: const [],
          topArtists: const [],
          topGenres: const [],
          topAnime: const [],
          topManga: const [],
          likedTracks: likedTracks,
          likedArtists: likedArtists,
          likedAlbums: likedAlbums,
          likedGenres: likedGenres,
        ));
      }
    } catch (e) {
      emit(ContentError(e.toString()));
    }
  }

  Future<void> _onLoadPlayedTracks(
    LoadPlayedTracks event,
    Emitter<ContentState> emit,
  ) async {
    try {
      emit(ContentLoading());
      final playedTracks = await _contentRepository.getPlayedTracks();

      if (state is ContentLoaded) {
        emit((state as ContentLoaded).copyWith(playedTracks: playedTracks));
      } else {
        emit(ContentLoaded(
          playedTracks: playedTracks,
          topTracks: const [],
          topArtists: const [],
          topGenres: const [],
          topAnime: const [],
          topManga: const [],
        ));
      }
    } catch (e) {
      emit(ContentError(e.toString()));
    }
  }

  Future<void> _onLikeItem(
    LikeItem event,
    Emitter<ContentState> emit,
  ) async {
    try {
      switch (event.type) {
        case 'track':
          await _contentRepository.likeTrack(event.id);
          break;
        case 'artist':
          await _contentRepository.likeArtist(event.id);
          break;
        case 'album':
          await _contentRepository.likeAlbum(event.id);
          break;
        case 'genre':
          await _contentRepository.likeGenre(event.id);
          break;
        case 'anime':
          await _contentRepository.likeAnime(event.id);
          break;
        case 'manga':
          await _contentRepository.likeManga(event.id);
          break;
      }
      emit(const ContentSuccess());
    } catch (e) {
      emit(ContentError(e.toString()));
    }
  }

  Future<void> _onUnlikeItem(
    UnlikeItem event,
    Emitter<ContentState> emit,
  ) async {
    try {
      switch (event.type) {
        case 'track':
          await _contentRepository.unlikeTrack(event.id);
          break;
        case 'artist':
          await _contentRepository.unlikeArtist(event.id);
          break;
        case 'album':
          await _contentRepository.unlikeAlbum(event.id);
          break;
        case 'genre':
          await _contentRepository.unlikeGenre(event.id);
          break;
        case 'anime':
          await _contentRepository.unlikeAnime(event.id);
          break;
        case 'manga':
          await _contentRepository.unlikeManga(event.id);
          break;
      }
      emit(const ContentSuccess());
    } catch (e) {
      emit(ContentError(e.toString()));
    }
  }

  Future<void> _onSearchContent(
    SearchContent event,
    Emitter<ContentState> emit,
  ) async {
    try {
      emit(ContentLoading());
      switch (event.type) {
        case 'track':
          final tracks = await _contentRepository.searchTracks(event.query);
          emit(ContentLoaded(
            topTracks: tracks,
            topArtists: const [],
            topGenres: const [],
            topAnime: const [],
            topManga: const [],
          ));
          break;
        case 'artist':
          final artists = await _contentRepository.searchArtists(event.query);
          emit(ContentLoaded(
            topArtists: artists,
            topTracks: const [],
            topGenres: const [],
            topAnime: const [],
            topManga: const [],
          ));
          break;
        case 'album':
          final albums = await _contentRepository.searchAlbums(event.query);
          emit(ContentLoaded(
            likedAlbums: albums,
            topTracks: const [],
            topArtists: const [],
            topGenres: const [],
            topAnime: const [],
            topManga: const [],
          ));
          break;
        case 'genre':
          final genres = await _contentRepository.searchGenres(event.query);
          emit(ContentLoaded(
            topGenres: genres,
            topTracks: const [],
            topArtists: const [],
            topAnime: const [],
            topManga: const [],
          ));
          break;
        case 'anime':
          final anime = await _contentRepository.searchAnime(event.query);
          emit(ContentLoaded(
            topAnime: anime,
            topTracks: const [],
            topArtists: const [],
            topGenres: const [],
            topManga: const [],
          ));
          break;
        case 'manga':
          final manga = await _contentRepository.searchManga(event.query);
          emit(ContentLoaded(
            topManga: manga,
            topTracks: const [],
            topArtists: const [],
            topGenres: const [],
            topAnime: const [],
          ));
          break;
      }
    } catch (e) {
      emit(ContentError(e.toString()));
    }
  }
}
