import 'package:equatable/equatable.dart';
import '../../../domain/models/track.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationFailure extends LocationState {
  final String error;

  const LocationFailure(this.error);

  @override
  List<Object> get props => [error];
}

class LocationSaveSuccess extends LocationState {}

class PlayedTracksLoaded extends LocationState {
  final List<Track> tracks;

  const PlayedTracksLoaded(this.tracks);

  @override
  List<Object> get props => [tracks];
}

class PlayedTracksWithLocationLoaded extends LocationState {
  final List<Track> tracks;

  const PlayedTracksWithLocationLoaded(this.tracks);

  @override
  List<Object> get props => [tracks];
}

class CurrentlyPlayedTracksLoaded extends LocationState {
  final List<Track> tracks;

  const CurrentlyPlayedTracksLoaded(this.tracks);

  @override
  List<Object> get props => [tracks];
}
