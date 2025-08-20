import '../../domain/models/common_track.dart';
import '../../domain/models/spotify_device.dart';

/// Base class for all Spotify control states
abstract class SpotifyControlState {}

/// Initial state
class SpotifyControlInitial extends SpotifyControlState {}

/// Loading state
class SpotifyControlLoading extends SpotifyControlState {}

/// State when played tracks are loaded
class SpotifyPlayedTracksLoaded extends SpotifyControlState {
  final List<CommonTrack> tracks;

  SpotifyPlayedTracksLoaded({required this.tracks});
}

/// State when devices are loaded
class SpotifyDevicesLoaded extends SpotifyControlState {
  final List<SpotifyDevice> devices;
  final SpotifyDevice? selectedDevice;

  SpotifyDevicesLoaded({
    required this.devices,
    this.selectedDevice,
  });
}

/// State when playback state changes
class SpotifyPlaybackStateChanged extends SpotifyControlState {
  final bool isPlaying;

  SpotifyPlaybackStateChanged({required this.isPlaying});
}

/// State when volume changes
class SpotifyVolumeStateChanged extends SpotifyControlState {
  final int volume;

  SpotifyVolumeStateChanged({required this.volume});
}

/// State when track location is saved
class SpotifyTrackLocationSaved extends SpotifyControlState {
  final CommonTrack track;
  final double latitude;
  final double longitude;

  SpotifyTrackLocationSaved({
    required this.track,
    required this.latitude,
    required this.longitude,
  });
}

/// Error state
class SpotifyControlFailure extends SpotifyControlState {
  final String error;

  SpotifyControlFailure({required this.error});
}
