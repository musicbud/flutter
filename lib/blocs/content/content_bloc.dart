import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/content_repository.dart';
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
    on<ContentPlayRequested>(_onContentPlayRequested);
    on<ContentPlayedTracksRequested>(_onContentPlayedTracksRequested);

    // Enhanced events from legacy
    on<LoadTopTracks>(_onLoadTopTracks);
    on<LoadTopArtists>(_onLoadTopArtists);
    on<LoadTopGenres>(_onLoadTopGenres);
    on<LoadTopAnime>(_onLoadTopAnime);
    on<LoadTopManga>(_onLoadTopManga);
    on<LoadLikedTracks>(_onLoadLikedTracks);
    on<LoadLikedArtists>(_onLoadLikedArtists);
    on<LoadLikedGenres>(_onLoadLikedGenres);
    on<LoadLikedAlbums>(_onLoadLikedAlbums);
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
      emit(ContentLoading());
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
          emit(const ContentError('Anime search not supported by API'));
          break;
        case 'manga':
          emit(const ContentError('Manga search not supported by API'));
          break;
      }
    } catch (e) {
      emit(ContentError(e.toString()));
    }
  }

  Future<void> _onContentPlayRequested(
    ContentPlayRequested event,
    Emitter<ContentState> emit,
  ) async {
    // Playback functionality not implemented in current API
    emit(const ContentError('Playback not supported by current API'));
  }

  Future<void> _onContentPlayedTracksRequested(
    ContentPlayedTracksRequested event,
    Emitter<ContentState> emit,
  ) async {
    await _onLoadPlayedTracks(LoadPlayedTracks(), emit);
  }

  // Enhanced event handlers from legacy
  Future<void> _onLoadTopTracks(
    LoadTopTracks event,
    Emitter<ContentState> emit,
  ) async {
    try {
      emit(ContentLoading());
      final tracks = await _contentRepository.getTopTracks();
      emit(ContentTopTracksLoaded(tracks: tracks));
    } catch (e) {
      emit(ContentError(e.toString()));
    }
  }

  Future<void> _onLoadTopArtists(
    LoadTopArtists event,
    Emitter<ContentState> emit,
  ) async {
    try {
      emit(ContentLoading());
      final artists = await _contentRepository.getTopArtists();
      emit(ContentTopArtistsLoaded(artists: artists));
    } catch (e) {
      emit(ContentError(e.toString()));
    }
  }

  Future<void> _onLoadTopGenres(
    LoadTopGenres event,
    Emitter<ContentState> emit,
  ) async {
    try {
      emit(ContentLoading());
      final genres = await _contentRepository.getTopGenres();
      emit(ContentTopGenresLoaded(genres: genres));
    } catch (e) {
      emit(ContentError(e.toString()));
    }
  }

  Future<void> _onLoadTopAnime(
    LoadTopAnime event,
    Emitter<ContentState> emit,
  ) async {
    try {
      emit(ContentLoading());
      final anime = await _contentRepository.getTopAnime();
      emit(ContentLoaded(
        topTracks: const [],
        topArtists: const [],
        topGenres: const [],
        topAnime: anime,
        topManga: const [],
      ));
    } catch (e) {
      emit(ContentError(e.toString()));
    }
  }

  Future<void> _onLoadTopManga(
    LoadTopManga event,
    Emitter<ContentState> emit,
  ) async {
    try {
      emit(ContentLoading());
      final manga = await _contentRepository.getTopManga();
      emit(ContentLoaded(
        topTracks: const [],
        topArtists: const [],
        topGenres: const [],
        topAnime: const [],
        topManga: manga,
      ));
    } catch (e) {
      emit(ContentError(e.toString()));
    }
  }

  Future<void> _onLoadLikedTracks(
    LoadLikedTracks event,
    Emitter<ContentState> emit,
  ) async {
    try {
      emit(ContentLoading());
      final tracks = await _contentRepository.getLikedTracks();
      emit(ContentLikedTracksLoaded(tracks: tracks));
    } catch (e) {
      emit(ContentError(e.toString()));
    }
  }

  Future<void> _onLoadLikedArtists(
    LoadLikedArtists event,
    Emitter<ContentState> emit,
  ) async {
    try {
      emit(ContentLoading());
      final artists = await _contentRepository.getLikedArtists();
      emit(ContentLikedArtistsLoaded(artists: artists));
    } catch (e) {
      emit(ContentError(e.toString()));
    }
  }

  Future<void> _onLoadLikedGenres(
    LoadLikedGenres event,
    Emitter<ContentState> emit,
  ) async {
    try {
      emit(ContentLoading());
      final genres = await _contentRepository.getLikedGenres();
      emit(ContentLikedGenresLoaded(genres: genres));
    } catch (e) {
      emit(ContentError(e.toString()));
    }
  }

  Future<void> _onLoadLikedAlbums(
    LoadLikedAlbums event,
    Emitter<ContentState> emit,
  ) async {
    try {
      emit(ContentLoading());
      final albums = await _contentRepository.getLikedAlbums();
      emit(ContentLikedAlbumsLoaded(albums: albums));
    } catch (e) {
      emit(ContentError(e.toString()));
    }
  }
}
