import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/repositories/content_repository.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final ContentRepository _contentRepository;
  GoogleMapController? _mapController;

  MapBloc({required ContentRepository contentRepository})
      : _contentRepository = contentRepository,
        super(MapInitial()) {
    on<MapTracksRequested>(_onMapTracksRequested);
    on<MapControllerSet>(_onMapControllerSet);
    on<MapMarkerTapped>(_onMapMarkerTapped);
    on<MapBoundsChanged>(_onMapBoundsChanged);
  }

  Future<void> _onMapTracksRequested(
    MapTracksRequested event,
    Emitter<MapState> emit,
  ) async {
    emit(MapLoading());
    try {
      final tracks = await _contentRepository.getPlayedTracksWithLocation();
      final markers = _createMarkers(tracks);
      final bounds = _calculateBounds(tracks);
      emit(MapTracksLoaded(
        tracks: tracks,
        markers: markers,
        bounds: bounds,
      ));
    } catch (e) {
      emit(MapFailure(e.toString()));
    }
  }

  void _onMapControllerSet(
    MapControllerSet event,
    Emitter<MapState> emit,
  ) {
    _mapController = event.controller;
    if (state is MapTracksLoaded) {
      final currentState = state as MapTracksLoaded;
      if (currentState.bounds != null) {
        _mapController?.animateCamera(
          CameraUpdate.newLatLngBounds(currentState.bounds!, 50),
        );
      }
    }
  }

  void _onMapMarkerTapped(
    MapMarkerTapped event,
    Emitter<MapState> emit,
  ) {
    if (state is MapTracksLoaded) {
      final currentState = state as MapTracksLoaded;
      final track = currentState.tracks.firstWhere(
        (track) => track.id == event.markerId,
      );
      emit(MapTrackSelected(
        track: track,
        position: LatLng(track.latitude!, track.longitude!),
      ));
    }
  }

  void _onMapBoundsChanged(
    MapBoundsChanged event,
    Emitter<MapState> emit,
  ) {
    if (state is MapTracksLoaded) {
      final currentState = state as MapTracksLoaded;
      emit(MapTracksLoaded(
        tracks: currentState.tracks,
        markers: currentState.markers,
        bounds: event.bounds,
      ));
    }
  }

  Map<MarkerId, Marker> _createMarkers(List<CommonTrack> tracks) {
    return Map.fromEntries(
      tracks
          .where((track) => track.latitude != null && track.longitude != null)
          .map(
        (track) {
          final markerId = MarkerId(track.id);
          return MapEntry(
            markerId,
            Marker(
              markerId: markerId,
              position: LatLng(track.latitude!, track.longitude!),
              infoWindow: InfoWindow(
                title: track.title,
                snippet: track.artistName,
              ),
              onTap: () => add(MapMarkerTapped(track.id)),
            ),
          );
        },
      ),
    );
  }

  LatLngBounds? _calculateBounds(List<CommonTrack> tracks) {
    final tracksWithLocation = tracks.where(
      (track) => track.latitude != null && track.longitude != null,
    );

    if (tracksWithLocation.isEmpty) {
      return null;
    }

    double? minLat, maxLat, minLng, maxLng;

    for (final track in tracksWithLocation) {
      final lat = track.latitude!;
      final lng = track.longitude!;

      minLat = minLat != null ? (lat < minLat ? lat : minLat) : lat;
      maxLat = maxLat != null ? (lat > maxLat ? lat : maxLat) : lat;
      minLng = minLng != null ? (lng < minLng ? lng : minLng) : lng;
      maxLng = maxLng != null ? (lng > maxLng ? lng : maxLng) : lng;
    }

    return LatLngBounds(
      southwest: LatLng(minLat!, minLng!),
      northeast: LatLng(maxLat!, maxLng!),
    );
  }
}
