import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/content_repository.dart';
import 'likes_event.dart';
import 'likes_state.dart';

class LikesBloc extends Bloc<LikesEvent, LikesState> {
  final ContentRepository _contentRepository;

  LikesBloc({
    required ContentRepository contentRepository,
  })  : _contentRepository = contentRepository,
        super(const LikesInitial()) {
    on<LikesUpdateRequested>(_onLikesUpdateRequested);
    on<SpotifyConnectionRequested>(_onSpotifyConnectionRequested);
    on<LikesUpdateCancelled>(_onLikesUpdateCancelled);
    on<ArtistLikeRequested>(_onArtistLikeRequested);
    on<TrackLikeRequested>(_onTrackLikeRequested);
    on<AlbumLikeRequested>(_onAlbumLikeRequested);
    on<GenreLikeRequested>(_onGenreLikeRequested);
  }

  Future<void> _onLikesUpdateRequested(
    LikesUpdateRequested event,
    Emitter<LikesState> emit,
  ) async {
    emit(const LikesUpdating());
    try {
      // TODO: Implement proper likes update logic with specific type, id, and isLiked
      // For now, we'll use placeholder values
      await _contentRepository.updateLikes('track', 'placeholder_id', true);
      emit(const LikesUpdateSuccess('Likes updated successfully!'));
    } catch (e) {
      final message = e.toString();
      final needsSpotifyConnection =
          message.contains('No Spotify account found');
      emit(LikesUpdateFailure(
        error: message,
        needsSpotifyConnection: needsSpotifyConnection,
      ));
    }
  }

  Future<void> _onSpotifyConnectionRequested(
    SpotifyConnectionRequested event,
    Emitter<LikesState> emit,
  ) async {
    try {
      // Spotify connection is now handled by the centralized AuthBloc
      // Use the service connection page instead
      emit(const LikesUpdateSuccess('Please connect your Spotify account from the service connection page'));
    } catch (e) {
      emit(const LikesUpdateFailure(
        error: 'Spotify connection is now handled centrally. Please use the service connection page.',
      ));
    }
  }

  void _onLikesUpdateCancelled(
    LikesUpdateCancelled event,
    Emitter<LikesState> emit,
  ) {
    emit(const LikesInitial());
  }

  Future<void> _onArtistLikeRequested(
    ArtistLikeRequested event,
    Emitter<LikesState> emit,
  ) async {
    emit(const LikesUpdating());
    try {
      if (event.isLiked) {
        await _contentRepository.likeArtist(event.artistId);
        emit(const LikesUpdateSuccess('Artist liked successfully!'));
      } else {
        await _contentRepository.unlikeArtist(event.artistId);
        emit(const LikesUpdateSuccess('Artist unliked successfully!'));
      }
    } catch (e) {
      final message = e.toString();
      final needsSpotifyConnection = message.contains('No Spotify account found');
      emit(LikesUpdateFailure(
        error: message,
        needsSpotifyConnection: needsSpotifyConnection,
      ));
    }
  }

  Future<void> _onTrackLikeRequested(
    TrackLikeRequested event,
    Emitter<LikesState> emit,
  ) async {
    emit(const LikesUpdating());
    try {
      if (event.isLiked) {
        await _contentRepository.likeTrack(event.trackId);
        emit(const LikesUpdateSuccess('Track liked successfully!'));
      } else {
        await _contentRepository.unlikeTrack(event.trackId);
        emit(const LikesUpdateSuccess('Track unliked successfully!'));
      }
    } catch (e) {
      final message = e.toString();
      final needsSpotifyConnection = message.contains('No Spotify account found');
      emit(LikesUpdateFailure(
        error: message,
        needsSpotifyConnection: needsSpotifyConnection,
      ));
    }
  }

  Future<void> _onAlbumLikeRequested(
    AlbumLikeRequested event,
    Emitter<LikesState> emit,
  ) async {
    emit(const LikesUpdating());
    try {
      if (event.isLiked) {
        await _contentRepository.likeAlbum(event.albumId);
        emit(const LikesUpdateSuccess('Album liked successfully!'));
      } else {
        await _contentRepository.unlikeAlbum(event.albumId);
        emit(const LikesUpdateSuccess('Album unliked successfully!'));
      }
    } catch (e) {
      final message = e.toString();
      final needsSpotifyConnection = message.contains('No Spotify account found');
      emit(LikesUpdateFailure(
        error: message,
        needsSpotifyConnection: needsSpotifyConnection,
      ));
    }
  }

  Future<void> _onGenreLikeRequested(
    GenreLikeRequested event,
    Emitter<LikesState> emit,
  ) async {
    emit(const LikesUpdating());
    try {
      if (event.isLiked) {
        await _contentRepository.likeGenre(event.genreId);
        emit(const LikesUpdateSuccess('Genre liked successfully!'));
      } else {
        await _contentRepository.unlikeGenre(event.genreId);
        emit(const LikesUpdateSuccess('Genre unliked successfully!'));
      }
    } catch (e) {
      final message = e.toString();
      final needsSpotifyConnection = message.contains('No Spotify account found');
      emit(LikesUpdateFailure(
        error: message,
        needsSpotifyConnection: needsSpotifyConnection,
      ));
    }
  }
}
