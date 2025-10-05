import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/content_repository.dart';
import '../../domain/models/common_track.dart';
import 'top_tracks_event.dart';
import 'top_tracks_state.dart';

class TopTracksBloc extends Bloc<TopTracksEvent, TopTracksState> {
  final ContentRepository _contentRepository;
  static const int _pageSize = 20;

  TopTracksBloc({
    required ContentRepository contentRepository,
  })  : _contentRepository = contentRepository,
        super(const TopTracksInitial()) {
    on<TopTracksRequested>(_onTopTracksRequested);
    on<TopTracksLoadMoreRequested>(_onTopTracksLoadMoreRequested);
    on<TopTracksRefreshRequested>(_onTopTracksRefreshRequested);
    on<TopTrackLikeToggled>(_onTopTrackLikeToggled);
    on<TopTrackPlayRequested>(_onTopTrackPlayRequested);
  }

  Future<void> _onTopTracksRequested(
    TopTracksRequested event,
    Emitter<TopTracksState> emit,
  ) async {
    emit(const TopTracksLoading());
    try {
      final tracks = await _contentRepository.getTopTracks();
      final hasReachedEnd = tracks.length < _pageSize;
      emit(TopTracksLoaded(
        tracks: tracks,
        hasReachedEnd: hasReachedEnd,
        currentPage: event.page,
      ));
    } catch (e) {
      emit(TopTracksFailure(e.toString()));
    }
  }

  Future<void> _onTopTracksLoadMoreRequested(
    TopTracksLoadMoreRequested event,
    Emitter<TopTracksState> emit,
  ) async {
    if (state is TopTracksLoaded) {
      final currentState = state as TopTracksLoaded;
      if (currentState.hasReachedEnd) return;

      emit(TopTracksLoadingMore(currentState.tracks));
      try {
        final nextPage = currentState.currentPage + 1;
        final moreTracks = await _contentRepository.getTopTracks();
        final hasReachedEnd = moreTracks.length < _pageSize;

        emit(TopTracksLoaded(
          tracks: [...currentState.tracks, ...moreTracks],
          hasReachedEnd: hasReachedEnd,
          currentPage: nextPage,
        ));
      } catch (e) {
        emit(TopTracksFailure(e.toString()));
      }
    }
  }

  Future<void> _onTopTracksRefreshRequested(
    TopTracksRefreshRequested event,
    Emitter<TopTracksState> emit,
  ) async {
    try {
      final tracks = await _contentRepository.getTopTracks();
      final hasReachedEnd = tracks.length < _pageSize;
      emit(TopTracksLoaded(
        tracks: tracks,
        hasReachedEnd: hasReachedEnd,
        currentPage: 1,
      ));
    } catch (e) {
      emit(TopTracksFailure(e.toString()));
    }
  }

  Future<void> _onTopTrackLikeToggled(
    TopTrackLikeToggled event,
    Emitter<TopTracksState> emit,
  ) async {
    if (state is TopTracksLoaded) {
      final currentState = state as TopTracksLoaded;
      final trackIndex =
          currentState.tracks.indexWhere((t) => t.id == event.trackId);
      if (trackIndex == -1) return;

      final track = currentState.tracks[trackIndex];
      try {
        if (track.isLiked) {
          await _contentRepository.unlikeTrack(event.trackId);
        } else {
          await _contentRepository.likeTrack(event.trackId);
        }

        emit(TopTrackLikeStatusChanged(!track.isLiked));

        final updatedTracks = List<CommonTrack>.from(currentState.tracks);
        updatedTracks[trackIndex] = track.copyWith(isLiked: !track.isLiked);

        emit(currentState.copyWith(tracks: updatedTracks));
      } catch (e) {
        emit(TopTracksFailure(e.toString()));
      }
    }
  }

  Future<void> _onTopTrackPlayRequested(
    TopTrackPlayRequested event,
    Emitter<TopTracksState> emit,
  ) async {
    try {
      if (event.deviceId != null) {
        await _contentRepository.playTrack(event.trackId, event.deviceId!);
        emit(const TopTrackPlaybackStarted());

        if (state is TopTracksLoaded) {
          emit(state);
        }
      } else {
        emit(const TopTracksFailure('No device ID provided'));
      }
    } catch (e) {
      emit(TopTracksFailure(e.toString()));
    }
  }
}
