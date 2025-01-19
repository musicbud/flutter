import 'package:equatable/equatable.dart';
import '../../domain/models/common_track.dart';

abstract class SpotifyControlEvent extends Equatable {
  const SpotifyControlEvent();

  @override
  List<Object?> get props => [];
}

class SpotifyPlayedTracksRequested extends SpotifyControlEvent {}

class SpotifyDevicesRequested extends SpotifyControlEvent {}

class SpotifyPlaybackControlRequested extends SpotifyControlEvent {
  final String command;
  final String? deviceId;

  const SpotifyPlaybackControlRequested({
    required this.command,
    this.deviceId,
  });

  @override
  List<Object?> get props => [command, deviceId];
}

class SpotifyVolumeChangeRequested extends SpotifyControlEvent {
  final int volume;
  final String? deviceId;

  const SpotifyVolumeChangeRequested({
    required this.volume,
    this.deviceId,
  });

  @override
  List<Object?> get props => [volume, deviceId];
}

class SpotifyTrackLocationSaveRequested extends SpotifyControlEvent {
  final CommonTrack track;
  final double latitude;
  final double longitude;

  const SpotifyTrackLocationSaveRequested({
    required this.track,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [track, latitude, longitude];
}
