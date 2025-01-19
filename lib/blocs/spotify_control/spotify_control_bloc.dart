import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/content_repository.dart';
import 'spotify_control_event.dart' as events;
import 'spotify_control_state.dart' as states;

/// Bloc that handles Spotify playback control and track management
class SpotifyControlBloc
    extends Bloc<events.SpotifyControlEvent, states.SpotifyControlState> {
  final ContentRepository _contentRepository;

  /// Creates a new instance of [SpotifyControlBloc]
  SpotifyControlBloc({required ContentRepository contentRepository})
      : _contentRepository = contentRepository,
        super(states.SpotifyControlInitial()) {
    on<events.SpotifyPlayedTracksRequested>(_onPlayedTracksRequested);
    on<events.SpotifyDevicesRequested>(_onDevicesRequested);
    on<events.SpotifyPlaybackControlRequested>(_onPlaybackControlRequested);
    on<events.SpotifyVolumeChangeRequested>(_onVolumeChangeRequested);
    on<events.SpotifyTrackLocationSaveRequested>(_onTrackLocationSaveRequested);
  }

  Future<void> _onPlayedTracksRequested(
    events.SpotifyPlayedTracksRequested event,
    Emitter<states.SpotifyControlState> emit,
  ) async {
    try {
      emit(states.SpotifyControlLoading());
      final tracks = await _contentRepository.getPlayedTracks();
      emit(states.SpotifyPlayedTracksLoaded(tracks: tracks));
    } catch (e) {
      emit(states.SpotifyControlFailure(error: e.toString()));
    }
  }

  Future<void> _onDevicesRequested(
    events.SpotifyDevicesRequested event,
    Emitter<states.SpotifyControlState> emit,
  ) async {
    try {
      emit(states.SpotifyControlLoading());
      final devices = await _contentRepository.getSpotifyDevices();
      emit(states.SpotifyDevicesLoaded(devices: devices));
    } catch (e) {
      emit(states.SpotifyControlFailure(error: e.toString()));
    }
  }

  Future<void> _onPlaybackControlRequested(
    events.SpotifyPlaybackControlRequested event,
    Emitter<states.SpotifyControlState> emit,
  ) async {
    if (event.deviceId.isEmpty) {
      emit(states.SpotifyControlFailure(error: 'No device selected'));
      return;
    }

    try {
      emit(states.SpotifyControlLoading());
      await _contentRepository.controlSpotifyPlayback(
          event.command, event.deviceId);
      emit(states.SpotifyPlaybackStateChanged(
          isPlaying: event.command == 'play'));
    } catch (e) {
      emit(states.SpotifyControlFailure(error: e.toString()));
    }
  }

  Future<void> _onVolumeChangeRequested(
    events.SpotifyVolumeChangeRequested event,
    Emitter<states.SpotifyControlState> emit,
  ) async {
    if (event.deviceId.isEmpty) {
      emit(states.SpotifyControlFailure(error: 'No device selected'));
      return;
    }

    try {
      emit(states.SpotifyControlLoading());
      await _contentRepository.setSpotifyVolume(event.deviceId, event.volume);
      emit(states.SpotifyVolumeStateChanged(volume: event.volume));
    } catch (e) {
      emit(states.SpotifyControlFailure(error: e.toString()));
    }
  }

  Future<void> _onTrackLocationSaveRequested(
    events.SpotifyTrackLocationSaveRequested event,
    Emitter<states.SpotifyControlState> emit,
  ) async {
    try {
      emit(states.SpotifyControlLoading());
      await _contentRepository.saveTrackLocation(
        event.track.id,
        event.latitude,
        event.longitude,
      );
      emit(states.SpotifyTrackLocationSaved(
        track: event.track,
        latitude: event.latitude,
        longitude: event.longitude,
      ));
    } catch (e) {
      emit(states.SpotifyControlFailure(error: e.toString()));
    }
  }
}
