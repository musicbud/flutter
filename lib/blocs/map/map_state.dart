import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/models/common_track.dart';

abstract class MapState {}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapFailure extends MapState {
  final String error;

  MapFailure({required this.error});
}

class MapTracksLoaded extends MapState {
  final List<CommonTrack> tracks;
  final Set<Marker> markers;
  final LatLngBounds bounds;

  MapTracksLoaded({
    required this.tracks,
    required this.markers,
    required this.bounds,
  });
}

class MapTrackSelected extends MapState {
  final CommonTrack track;
  final LatLng position;

  MapTrackSelected({
    required this.track,
    required this.position,
  });
}
