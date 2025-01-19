import 'package:equatable/equatable.dart';
import '../../domain/models/common_track.dart';
import '../../domain/models/spotify_device.dart';

abstract class SpotifyControlState extends Equatable {
  const SpotifyControlState();

  @override
  List<Object?> get props => [];
}

class SpotifyControlInitial extends SpotifyControlState {
  const SpotifyControlInitial();
}

class SpotifyControlLoading extends SpotifyControlState {
  const SpotifyControlLoading();
}

class SpotifyPlayedTracksLoaded extends SpotifyControlState {
  final List<CommonTrack> tracks;

  const SpotifyPlayedTracksLoaded({required this.tracks});

  @override
  List<Object?> get props => [tracks];
}

class SpotifyDevicesLoaded extends SpotifyControlState {
  final List<SpotifyDevice> devices;

  const SpotifyDevicesLoaded({required this.devices});

  @override
  List<Object?> get props => [devices];
}

class SpotifyPlaybackControlled extends SpotifyControlState {
  const SpotifyPlaybackControlled();
}

class SpotifyVolumeChanged extends SpotifyControlState {
  const SpotifyVolumeChanged();
}

class SpotifyTrackLocationSaved extends SpotifyControlState {
  const SpotifyTrackLocationSaved();
}

class SpotifyControlFailure extends SpotifyControlState {
  final String error;

  const SpotifyControlFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
