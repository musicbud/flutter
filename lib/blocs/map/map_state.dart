import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/track.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapTracksLoaded extends MapState {
  final List<Track> tracks;
  final Set<Marker> markers;
  final LatLngBounds bounds;

  const MapTracksLoaded({
    required this.tracks,
    required this.markers,
    required this.bounds,
  });

  @override
  List<Object?> get props => [tracks, markers, bounds];
}

class MapTrackSelectedState extends MapTracksLoaded {
  final Track selectedTrack;

  const MapTrackSelectedState({
    required this.selectedTrack,
    required super.tracks,
    required super.markers,
    required super.bounds,
  });

  @override
  List<Object?> get props => [selectedTrack, ...super.props];
}

class MapFailure extends MapState {
  final String error;

  const MapFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
