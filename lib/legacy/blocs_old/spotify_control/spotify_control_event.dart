import '../../domain/models/common_track.dart';

/// Base class for all Spotify control events
abstract class SpotifyControlEvent {}

/// Event to request played tracks
class SpotifyPlayedTracksRequested extends SpotifyControlEvent {}

/// Event to request available devices
class SpotifyDevicesRequested extends SpotifyControlEvent {}

/// Event to control playback (play, pause, etc.)
class SpotifyPlaybackControlRequested extends SpotifyControlEvent {
  final String command;
  final String deviceId;

  SpotifyPlaybackControlRequested({
    required this.command,
    required this.deviceId,
  });
}

/// Event to change volume
class SpotifyVolumeChangeRequested extends SpotifyControlEvent {
  final int volume;
  final String deviceId;

  SpotifyVolumeChangeRequested({
    required this.volume,
    required this.deviceId,
  });
}

/// Event to save track location
class SpotifyTrackLocationSaveRequested extends SpotifyControlEvent {
  final CommonTrack track;
  final double latitude;
  final double longitude;

  SpotifyTrackLocationSaveRequested({
    required this.track,
    required this.latitude,
    required this.longitude,
  });
}
