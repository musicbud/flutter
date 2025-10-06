import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/track.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class MapTracksRequested extends MapEvent {}

class MapTrackSelectedEvent extends MapEvent {
  final Track track;

  const MapTrackSelectedEvent({required this.track});

  @override
  List<Object?> get props => [track];
}

class MapControllerSet extends MapEvent {
  final GoogleMapController controller;

  const MapControllerSet(this.controller);

  @override
  List<Object> get props => [controller];
}

class MapMarkerTapped extends MapEvent {
  final String markerId;

  const MapMarkerTapped(this.markerId);

  @override
  List<Object> get props => [markerId];
}

class MapBoundsChanged extends MapEvent {
  final LatLngBounds bounds;

  const MapBoundsChanged(this.bounds);

  @override
  List<Object> get props => [bounds];
}
