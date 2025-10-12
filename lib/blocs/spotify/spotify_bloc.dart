import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbud_flutter/domain/repositories/spotify_repository.dart';

// Import events and states from separate files
import 'spotify_event.dart';
import 'spotify_state.dart';

// BLoC
class SpotifyBloc extends Bloc<SpotifyEvent, SpotifyState> {
  final SpotifyRepository repository;

  SpotifyBloc(this.repository) : super(SpotifyInitial()) {
    on<LoadPlayedTracks>(_onLoadPlayedTracks);
    on<PlayTrackWithLocation>(_onPlayTrackWithLocation);
    on<PlaySpotifyTrack>(_onPlaySpotifyTrack);
    on<SaveLocation>(_onSaveLocation);
    on<LoadPlayedTracksWithLocation>(_onLoadPlayedTracksWithLocation);
  }

  Future<void> _onLoadPlayedTracks(LoadPlayedTracks event, Emitter<SpotifyState> emit) async {
    emit(SpotifyLoading());
    try {
      final tracks = await repository.getPlayedTracks();
      emit(PlayedTracksLoaded(tracks));
    } catch (e) {
      emit(SpotifyError(e.toString()));
    }
  }

  Future<void> _onPlayTrackWithLocation(PlayTrackWithLocation event, Emitter<SpotifyState> emit) async {
    emit(SpotifyLoading());
    try {
      final success = await repository.playTrackWithLocation(
        event.trackId,
        event.trackName,
        event.latitude,
        event.longitude,
      );
      if (success) {
        emit(TrackPlayed());
      } else {
        emit(const SpotifyError('Failed to play track'));
      }
    } catch (e) {
      emit(SpotifyError(e.toString()));
    }
  }

  Future<void> _onPlaySpotifyTrack(PlaySpotifyTrack event, Emitter<SpotifyState> emit) async {
    emit(SpotifyLoading());
    try {
      final success = await repository.playSpotifyTrack(event.trackId, deviceId: event.deviceId);
      if (success) {
        emit(TrackPlayed());
      } else {
        emit(const SpotifyError('Failed to play track'));
      }
    } catch (e) {
      emit(SpotifyError(e.toString()));
    }
  }

  Future<void> _onSaveLocation(SaveLocation event, Emitter<SpotifyState> emit) async {
    emit(SpotifyLoading());
    try {
      await repository.saveLocation(event.latitude, event.longitude);
      emit(LocationSaved());
    } catch (e) {
      emit(SpotifyError(e.toString()));
    }
  }

  Future<void> _onLoadPlayedTracksWithLocation(LoadPlayedTracksWithLocation event, Emitter<SpotifyState> emit) async {
    emit(SpotifyLoading());
    try {
      final tracks = await repository.getPlayedTracksWithLocation();
      emit(PlayedTracksWithLocationLoaded(tracks));
    } catch (e) {
      emit(SpotifyError(e.toString()));
    }
  }
}