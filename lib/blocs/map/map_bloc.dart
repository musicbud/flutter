import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/repositories/content_repository.dart';
import '../../models/track.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final ContentRepository _contentRepository;

  MapBloc({required ContentRepository contentRepository})
      : _contentRepository = contentRepository,
        super(MapInitial()) {
    on<MapTracksRequested>(_onMapTracksRequested);
    on<MapTrackSelectedEvent>(_onMapTrackSelected);
  }

  Future<void> _onMapTracksRequested(
    MapTracksRequested event,
    Emitter<MapState> emit,
  ) async {
    try {
      emit(MapLoading());
      final tracks = await _contentRepository.getPlayedTracksWithLocation();
      final markers = _createMarkers(tracks);
      final bounds = _calculateBounds(tracks);
      emit(MapTracksLoaded(
        tracks: tracks,
        markers: markers,
        bounds: bounds,
      ));
    } catch (e) {
      emit(MapFailure(error: e.toString()));
    }
  }

  Future<void> _onMapTrackSelected(
    MapTrackSelectedEvent event,
    Emitter<MapState> emit,
  ) async {
    if (state is MapTracksLoaded) {
      final currentState = state as MapTracksLoaded;
      emit(MapTrackSelectedState(
        selectedTrack: event.track,
        tracks: currentState.tracks,
        markers: currentState.markers,
        bounds: currentState.bounds,
      ));
    }
  }

  Set<Marker> _createMarkers(List<Track> tracks) {
    final markers = <Marker>{};
    for (final track in tracks) {
      if (track.latitude != null && track.longitude != null) {
        markers.add(
          Marker(
            markerId: MarkerId(track.id),
            position: LatLng(track.latitude!, track.longitude!),
            infoWindow: InfoWindow(
              title: track.title,
              snippet: track.artistName,
            ),
            onTap: () => add(MapTrackSelectedEvent(track: track)),
          ),
        );
      }
    }
    return markers;
  }

  LatLngBounds _calculateBounds(List<Track> tracks) {
    if (tracks.isEmpty) {
      // Default bounds if no tracks
      return LatLngBounds(
        southwest: const LatLng(-90, -180),
        northeast: const LatLng(90, 180),
      );
    }

    double? minLat, maxLat, minLng, maxLng;

    for (final track in tracks) {
      if (track.latitude == null || track.longitude == null) continue;

      minLat = minLat == null
          ? track.latitude
          : (track.latitude! < minLat ? track.latitude : minLat);
      maxLat = maxLat == null
          ? track.latitude
          : (track.latitude! > maxLat ? track.latitude : maxLat);
      minLng = minLng == null
          ? track.longitude
          : (track.longitude! < minLng ? track.longitude : minLng);
      maxLng = maxLng == null
          ? track.longitude
          : (track.longitude! > maxLng ? track.longitude : maxLng);
    }

    if (minLat == null || maxLat == null || minLng == null || maxLng == null) {
      // Default bounds if no valid coordinates
      return LatLngBounds(
        southwest: const LatLng(-90, -180),
        northeast: const LatLng(90, 180),
      );
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }
}
