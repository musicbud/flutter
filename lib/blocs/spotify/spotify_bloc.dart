import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:musicbud_flutter/data/models/common_track.dart';
import 'package:musicbud_flutter/domain/repositories/spotify_repository.dart';

// Events
abstract class SpotifyEvent extends Equatable {
  const SpotifyEvent();

  @override
  List<Object> get props => [];
}

class LoadPlayedTracks extends SpotifyEvent {}

class PlayTrackWithLocation extends SpotifyEvent {
  final String trackId;
  final String trackName;
  final double latitude;
  final double longitude;

  const PlayTrackWithLocation(this.trackId, this.trackName, this.latitude, this.longitude);

  @override
  List<Object> get props => [trackId, trackName, latitude, longitude];
}

class PlaySpotifyTrack extends SpotifyEvent {
  final String trackId;
  final String? deviceId;

  const PlaySpotifyTrack(this.trackId, this.deviceId);

  @override
  List<Object> get props => [trackId, deviceId ?? ''];
}

class SaveLocation extends SpotifyEvent {
  final double latitude;
  final double longitude;

  const SaveLocation(this.latitude, this.longitude);

  @override
  List<Object> get props => [latitude, longitude];
}

class LoadPlayedTracksWithLocation extends SpotifyEvent {}

// States
abstract class SpotifyState extends Equatable {
  const SpotifyState();

  @override
  List<Object> get props => [];
}

class SpotifyInitial extends SpotifyState {}

class SpotifyLoading extends SpotifyState {}

class PlayedTracksLoaded extends SpotifyState {
  final List<CommonTrack> tracks;

  const PlayedTracksLoaded(this.tracks);

  @override
  List<Object> get props => [tracks];
}

class TrackPlayed extends SpotifyState {}

class LocationSaved extends SpotifyState {}

class PlayedTracksWithLocationLoaded extends SpotifyState {
  final List<CommonTrack> tracks;

  const PlayedTracksWithLocationLoaded(this.tracks);

  @override
  List<Object> get props => [tracks];
}

class SpotifyError extends SpotifyState {
  final String message;

  const SpotifyError(this.message);

  @override
  List<Object> get props => [message];
}

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