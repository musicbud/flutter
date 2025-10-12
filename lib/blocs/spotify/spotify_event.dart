import 'package:equatable/equatable.dart';

/// Base class for all Spotify events
abstract class SpotifyEvent extends Equatable {
  const SpotifyEvent();

  @override
  List<Object> get props => [];
}

/// Load played tracks from Spotify
class LoadPlayedTracks extends SpotifyEvent {}

/// Play a track with location data
class PlayTrackWithLocation extends SpotifyEvent {
  final String trackId;
  final String trackName;
  final double latitude;
  final double longitude;

  const PlayTrackWithLocation(this.trackId, this.trackName, this.latitude, this.longitude);

  @override
  List<Object> get props => [trackId, trackName, latitude, longitude];
}

/// Play a Spotify track
class PlaySpotifyTrack extends SpotifyEvent {
  final String trackId;
  final String? deviceId;

  const PlaySpotifyTrack(this.trackId, this.deviceId);

  @override
  List<Object> get props => [trackId, deviceId ?? ''];
}

/// Save location data
class SaveLocation extends SpotifyEvent {
  final double latitude;
  final double longitude;

  const SaveLocation(this.latitude, this.longitude);

  @override
  List<Object> get props => [latitude, longitude];
}

/// Load played tracks with location data
class LoadPlayedTracksWithLocation extends SpotifyEvent {}