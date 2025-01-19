import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/content_repository.dart';
import 'spotify_control_event.dart';
import 'spotify_control_state.dart';

class SpotifyControlBloc
    extends Bloc<SpotifyControlEvent, SpotifyControlState> {
  final ContentRepository _contentRepository;

  SpotifyControlBloc({required ContentRepository contentRepository})
      : _contentRepository = contentRepository,
        super(const SpotifyControlInitial()) {
    on<SpotifyPlayedTracksRequested>(_onPlayedTracksRequested);
    on<SpotifyDevicesRequested>(_onDevicesRequested);
    on<SpotifyPlaybackControlRequested>(_onPlaybackControlRequested);
    on<SpotifyVolumeChangeRequested>(_onVolumeChangeRequested);
    on<SpotifyTrackLocationSaveRequested>(_onTrackLocationSaveRequested);
  }

  Future<void> _onPlayedTracksRequested(
    SpotifyPlayedTracksRequested event,
    Emitter<SpotifyControlState> emit,
  ) async {
    try {
      emit(const SpotifyControlLoading());
      final tracks = await _contentRepository.getPlayedTracks();
      emit(SpotifyPlayedTracksLoaded(tracks: tracks));
    } catch (e) {
      emit(SpotifyControlFailure(error: e.toString()));
    }
  }

  Future<void> _onDevicesRequested(
    SpotifyDevicesRequested event,
    Emitter<SpotifyControlState> emit,
  ) async {
    try {
      emit(const SpotifyControlLoading());
      final devices = await _contentRepository.getSpotifyDevices();
      emit(SpotifyDevicesLoaded(devices: devices));
    } catch (e) {
      emit(SpotifyControlFailure(error: e.toString()));
    }
  }

  Future<void> _onPlaybackControlRequested(
    SpotifyPlaybackControlRequested event,
    Emitter<SpotifyControlState> emit,
  ) async {
    try {
      emit(const SpotifyControlLoading());
      await _contentRepository.controlSpotifyPlayback(
          event.command, event.deviceId);
      emit(const SpotifyPlaybackControlled());
    } catch (e) {
      emit(SpotifyControlFailure(error: e.toString()));
    }
  }

  Future<void> _onVolumeChangeRequested(
    SpotifyVolumeChangeRequested event,
    Emitter<SpotifyControlState> emit,
  ) async {
    try {
      emit(const SpotifyControlLoading());
      await _contentRepository.setSpotifyVolume(event.deviceId, event.volume);
      emit(const SpotifyVolumeChanged());
    } catch (e) {
      emit(SpotifyControlFailure(error: e.toString()));
    }
  }

  Future<void> _onTrackLocationSaveRequested(
    SpotifyTrackLocationSaveRequested event,
    Emitter<SpotifyControlState> emit,
  ) async {
    try {
      emit(const SpotifyControlLoading());
      await _contentRepository.saveTrackLocation(
        event.track.id,
        event.latitude,
        event.longitude,
      );
      emit(const SpotifyTrackLocationSaved());
    } catch (e) {
      emit(SpotifyControlFailure(error: e.toString()));
    }
  }
}
