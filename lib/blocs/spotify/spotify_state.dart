import 'package:equatable/equatable.dart';
import 'package:musicbud_flutter/data/models/common_track.dart';

/// Base class for all Spotify states
abstract class SpotifyState extends Equatable {
  const SpotifyState();

  @override
  List<Object> get props => [];
}

/// Initial state when Spotify BLoC is first created
class SpotifyInitial extends SpotifyState {}

/// Loading state during API calls
class SpotifyLoading extends SpotifyState {}

/// State when played tracks have been successfully loaded
class PlayedTracksLoaded extends SpotifyState {
  final List<SpotifyCommonTrack> tracks;

  const PlayedTracksLoaded(this.tracks);

  @override
  List<Object> get props => [tracks];
}

/// State when a track has been successfully played
class TrackPlayed extends SpotifyState {}

/// State when location has been successfully saved
class LocationSaved extends SpotifyState {}

/// State when played tracks with location data have been loaded
class PlayedTracksWithLocationLoaded extends SpotifyState {
  final List<SpotifyCommonTrack> tracks;

  const PlayedTracksWithLocationLoaded(this.tracks);

  @override
  List<Object> get props => [tracks];
}

/// Error state when something goes wrong
class SpotifyError extends SpotifyState {
  final String message;

  const SpotifyError(this.message);

  @override
  List<Object> get props => [message];
}