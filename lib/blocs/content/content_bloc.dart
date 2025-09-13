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
      emit(const ContentLoading());
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
      emit(const ContentLoading());
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
      emit(const ContentLoading());
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
      await _contentRepository.toggleLike(event.id, event.type);
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
      // Unlike is handled by the same toggle method
      await _contentRepository.toggleLike(event.id, event.type);
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
      emit(const ContentLoading());
      // Search functionality is not directly supported by the API endpoints
      // We'll use the existing content loading methods
      switch (event.type) {
        case 'track':
          final tracks = await _contentRepository.getLikedTracks();
          emit(ContentLoaded(
            topTracks: tracks,
            topArtists: const [],
            topGenres: const [],
            topAnime: const [],
            topManga: const [],
          ));
          break;
        case 'artist':
          final artists = await _contentRepository.getLikedArtists();
          emit(ContentLoaded(
            topArtists: artists,
            topTracks: const [],
            topGenres: const [],
            topAnime: const [],
            topManga: const [],
          ));
          break;
        case 'album':
          final albums = await _contentRepository.getLikedAlbums();
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
          final genres = await _contentRepository.getLikedGenres();
          emit(ContentLoaded(
            topGenres: genres,
            topTracks: const [],
            topArtists: const [],
            topAnime: const [],
            topManga: const [],
          ));
          break;
        case 'anime':
          // Anime search is not supported by the API
          emit(const ContentError('Anime search not supported by API'));
          break;
        case 'manga':
          // Manga search is not supported by the API
          emit(const ContentError('Manga search not supported by API'));
          break;
      }
    } catch (e) {
      emit(ContentError(e.toString()));
    }
  }
}
