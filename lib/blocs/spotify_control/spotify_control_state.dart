import '../../domain/models/common_track.dart';

abstract class SpotifyControlState {}

class SpotifyControlInitial extends SpotifyControlState {}

class SpotifyControlLoading extends SpotifyControlState {}

class SpotifyControlFailure extends SpotifyControlState {
  final String error;

  SpotifyControlFailure({required this.error});
}

class SpotifyPlayedTracksLoaded extends SpotifyControlState {
  final List<CommonTrack> tracks;

  SpotifyPlayedTracksLoaded({required this.tracks});
}

class SpotifyDevicesLoaded extends SpotifyControlState {
  final List<Map<String, dynamic>> devices;
  final String? selectedDeviceId;

  SpotifyDevicesLoaded({
    required this.devices,
    this.selectedDeviceId,
  });
}

class SpotifyPlaybackStateChanged extends SpotifyControlState {
  final bool isPlaying;

  SpotifyPlaybackStateChanged({required this.isPlaying});
}

class SpotifyVolumeStateChanged extends SpotifyControlState {
  final int volume;

  SpotifyVolumeStateChanged({required this.volume});
}

class SpotifyTrackChanged extends SpotifyControlState {
  final CommonTrack track;

  SpotifyTrackChanged({required this.track});
}

class SpotifyDeviceChanged extends SpotifyControlState {
  final String deviceId;

  SpotifyDeviceChanged({required this.deviceId});
}

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
