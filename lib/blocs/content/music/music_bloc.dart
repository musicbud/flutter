import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/content_repository.dart';
import 'music_event.dart';
import 'music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  final ContentRepository _contentRepository;

  MusicBloc({required ContentRepository contentRepository})
      : _contentRepository = contentRepository,
        super(MusicInitial()) {
    // Popular content
    on<PopularTracksRequested>(_onPopularTracksRequested);
    on<PopularArtistsRequested>(_onPopularArtistsRequested);
    on<PopularAlbumsRequested>(_onPopularAlbumsRequested);

    // Top content
    on<TopTracksRequested>(_onTopTracksRequested);
    on<TopArtistsRequested>(_onTopArtistsRequested);

    // Liked content
    on<LikedTracksRequested>(_onLikedTracksRequested);
    on<LikedArtistsRequested>(_onLikedArtistsRequested);
    on<LikedAlbumsRequested>(_onLikedAlbumsRequested);

    // Like/Unlike operations
    on<TrackLiked>(_onTrackLiked);
    on<ArtistLiked>(_onArtistLiked);
    on<AlbumLiked>(_onAlbumLiked);
    on<TrackUnliked>(_onTrackUnliked);
    on<ArtistUnliked>(_onArtistUnliked);
    on<AlbumUnliked>(_onAlbumUnliked);

    // Search operations
    on<TracksSearched>(_onTracksSearched);
    on<ArtistsSearched>(_onArtistsSearched);
    on<AlbumsSearched>(_onAlbumsSearched);

    // Playback operations
    on<SpotifyDevicesRequested>(_onSpotifyDevicesRequested);
    on<TrackPlayRequested>(_onTrackPlayRequested);
    on<TrackPlayWithLocationRequested>(_onTrackPlayWithLocationRequested);
    on<PlayedTrackSaved>(_onPlayedTrackSaved);
  }

  Future<void> _onPopularTracksRequested(
    PopularTracksRequested event,
    Emitter<MusicState> emit,
  ) async {
    try {
      emit(MusicLoading());
      final tracks =
          await _contentRepository.getPopularTracks(limit: event.limit);
      emit(PopularTracksLoaded(tracks));
    } catch (error) {
      emit(MusicFailure(error.toString()));
    }
  }

  Future<void> _onPopularArtistsRequested(
    PopularArtistsRequested event,
    Emitter<MusicState> emit,
  ) async {
    try {
      emit(MusicLoading());
      final artists =
          await _contentRepository.getPopularArtists(limit: event.limit);
      emit(PopularArtistsLoaded(artists));
    } catch (error) {
      emit(MusicFailure(error.toString()));
    }
  }

  Future<void> _onPopularAlbumsRequested(
    PopularAlbumsRequested event,
    Emitter<MusicState> emit,
  ) async {
    try {
      emit(MusicLoading());
      final albums =
          await _contentRepository.getPopularAlbums(limit: event.limit);
      emit(PopularAlbumsLoaded(albums));
    } catch (error) {
      emit(MusicFailure(error.toString()));
    }
  }

  Future<void> _onTopTracksRequested(
    TopTracksRequested event,
    Emitter<MusicState> emit,
  ) async {
    try {
      emit(MusicLoading());
      final tracks = await _contentRepository.getTopTracks();
      emit(TopTracksLoaded(tracks));
    } catch (error) {
      emit(MusicFailure(error.toString()));
    }
  }

  Future<void> _onTopArtistsRequested(
    TopArtistsRequested event,
    Emitter<MusicState> emit,
  ) async {
    try {
      emit(MusicLoading());
      final artists = await _contentRepository.getTopArtists();
      emit(TopArtistsLoaded(artists));
    } catch (error) {
      emit(MusicFailure(error.toString()));
    }
  }

  Future<void> _onLikedTracksRequested(
    LikedTracksRequested event,
    Emitter<MusicState> emit,
  ) async {
    try {
      emit(MusicLoading());
      final tracks = await _contentRepository.getLikedTracks();
      emit(LikedTracksLoaded(tracks));
    } catch (error) {
      emit(MusicFailure(error.toString()));
    }
  }

  Future<void> _onLikedArtistsRequested(
    LikedArtistsRequested event,
    Emitter<MusicState> emit,
  ) async {
    try {
      emit(MusicLoading());
      final artists = await _contentRepository.getLikedArtists();
      emit(LikedArtistsLoaded(artists));
    } catch (error) {
      emit(MusicFailure(error.toString()));
    }
  }

  Future<void> _onLikedAlbumsRequested(
    LikedAlbumsRequested event,
    Emitter<MusicState> emit,
  ) async {
    try {
      emit(MusicLoading());
      final albums = await _contentRepository.getLikedAlbums();
      emit(LikedAlbumsLoaded(albums));
    } catch (error) {
      emit(MusicFailure(error.toString()));
    }
  }

  Future<void> _onTrackLiked(
    TrackLiked event,
    Emitter<MusicState> emit,
  ) async {
    try {
      emit(MusicLoading());
      await _contentRepository.likeTrack(event.id);
      emit(TrackLikeSuccess());
    } catch (error) {
      emit(MusicFailure(error.toString()));
    }
  }

  Future<void> _onArtistLiked(
    ArtistLiked event,
    Emitter<MusicState> emit,
  ) async {
    try {
      emit(MusicLoading());
      await _contentRepository.likeArtist(event.id);
      emit(ArtistLikeSuccess());
    } catch (error) {
      emit(MusicFailure(error.toString()));
    }
  }

  Future<void> _onAlbumLiked(
    AlbumLiked event,
    Emitter<MusicState> emit,
  ) async {
    try {
      emit(MusicLoading());
      await _contentRepository.likeAlbum(event.id);
      emit(AlbumLikeSuccess());
    } catch (error) {
      emit(MusicFailure(error.toString()));
    }
  }

  Future<void> _onTrackUnliked(
    TrackUnliked event,
    Emitter<MusicState> emit,
  ) async {
    try {
      emit(MusicLoading());
      await _contentRepository.unlikeTrack(event.id);
      emit(TrackUnlikeSuccess());
    } catch (error) {
      emit(MusicFailure(error.toString()));
    }
  }

  Future<void> _onArtistUnliked(
    ArtistUnliked event,
    Emitter<MusicState> emit,
  ) async {
    try {
      emit(MusicLoading());
      await _contentRepository.unlikeArtist(event.id);
      emit(ArtistUnlikeSuccess());
    } catch (error) {
      emit(MusicFailure(error.toString()));
    }
  }

  Future<void> _onAlbumUnliked(
    AlbumUnliked event,
    Emitter<MusicState> emit,
  ) async {
    try {
      emit(MusicLoading());
      await _contentRepository.unlikeAlbum(event.id);
      emit(AlbumUnlikeSuccess());
    } catch (error) {
      emit(MusicFailure(error.toString()));
    }
  }

  Future<void> _onTracksSearched(
    TracksSearched event,
    Emitter<MusicState> emit,
  ) async {
    try {
      emit(MusicLoading());
      final tracks = await _contentRepository.searchTracks(event.query);
      emit(TracksSearchResultLoaded(tracks));
    } catch (error) {
      emit(MusicFailure(error.toString()));
    }
  }

  Future<void> _onArtistsSearched(
    ArtistsSearched event,
    Emitter<MusicState> emit,
  ) async {
    try {
      emit(MusicLoading());
      final artists = await _contentRepository.searchArtists(event.query);
      emit(ArtistsSearchResultLoaded(artists));
    } catch (error) {
      emit(MusicFailure(error.toString()));
    }
  }

  Future<void> _onAlbumsSearched(
    AlbumsSearched event,
    Emitter<MusicState> emit,
  ) async {
    try {
      emit(MusicLoading());
      final albums = await _contentRepository.searchAlbums(event.query);
      emit(AlbumsSearchResultLoaded(albums));
    } catch (error) {
      emit(MusicFailure(error.toString()));
    }
  }

  Future<void> _onSpotifyDevicesRequested(
    SpotifyDevicesRequested event,
    Emitter<MusicState> emit,
  ) async {
    try {
      emit(MusicLoading());
      final devices = await _contentRepository.getSpotifyDevices();
      emit(SpotifyDevicesLoaded(devices));
    } catch (error) {
      emit(MusicFailure(error.toString()));
    }
  }

  Future<void> _onTrackPlayRequested(
    TrackPlayRequested event,
    Emitter<MusicState> emit,
  ) async {
    try {
      emit(MusicLoading());
      await _contentRepository.playTrack(event.trackId,
          deviceId: event.deviceId);
      emit(TrackPlaySuccess());
    } catch (error) {
      emit(MusicFailure(error.toString()));
    }
  }

  Future<void> _onTrackPlayWithLocationRequested(
    TrackPlayWithLocationRequested event,
    Emitter<MusicState> emit,
  ) async {
    try {
      emit(MusicLoading());
      await _contentRepository.playTrackWithLocation(
        event.trackId,
        event.latitude,
        event.longitude,
      );
      emit(TrackPlayWithLocationSuccess());
    } catch (error) {
      emit(MusicFailure(error.toString()));
    }
  }

  Future<void> _onPlayedTrackSaved(
    PlayedTrackSaved event,
    Emitter<MusicState> emit,
  ) async {
    try {
      emit(MusicLoading());
      await _contentRepository.savePlayedTrack(
        event.trackId,
        event.latitude,
        event.longitude,
      );
      emit(PlayedTrackSaveSuccess());
    } catch (error) {
      emit(MusicFailure(error.toString()));
    }
  }
}
