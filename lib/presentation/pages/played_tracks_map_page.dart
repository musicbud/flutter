import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../blocs/map/map_bloc.dart';
import '../../blocs/map/map_event.dart';
import '../../blocs/map/map_state.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/track_list_item.dart';

class PlayedTracksMapPage extends StatefulWidget {
  const PlayedTracksMapPage({super.key});

  @override
  State<PlayedTracksMapPage> createState() => _PlayedTracksMapPageState();
}

class _PlayedTracksMapPageState extends State<PlayedTracksMapPage> {
  @override
  void initState() {
    super.initState();
    context.read<MapBloc>().add(MapTracksRequested());
  }

  void _onMapCreated(GoogleMapController controller) {
    context.read<MapBloc>().add(MapControllerSet(controller));
  }

  void _onCameraMove(CameraPosition position) {
    final bounds = LatLngBounds(
      southwest: position.target.offset(-0.1, -0.1),
      northeast: position.target.offset(0.1, 0.1),
    );
    context.read<MapBloc>().add(MapBoundsChanged(bounds));
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Played Tracks Map'),
      ),
      body: BlocConsumer<MapBloc, MapState>(
        listener: (context, state) {
          if (state is MapFailure) {
            _showErrorSnackBar(state.error);
          } else if (state is MapTrackSelected) {
            showModalBottomSheet(
              context: context,
              builder: (context) => Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TrackListItem(track: state.track),
                    Text(
                      'Played at: ${state.track.playedAt?.toString() ?? 'Unknown time'}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is MapLoading) {
            return const LoadingIndicator();
          }

          if (state is MapTracksLoaded) {
            return GoogleMap(
              onMapCreated: _onMapCreated,
              onCameraMove: _onCameraMove,
              initialCameraPosition: const CameraPosition(
                target: LatLng(0, 0),
                zoom: 2,
              ),
              markers: Set<Marker>.of(state.markers.values),
            );
          }

          return const Center(
            child: Text('Failed to load map'),
          );
        },
      ),
    );
  }
}

extension on LatLng {
  LatLng offset(double lat, double lng) {
    return LatLng(
      latitude + lat,
      longitude + lng,
    );
  }
}
