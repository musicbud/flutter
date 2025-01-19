import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../blocs/map/map_bloc.dart';
import '../../blocs/map/map_event.dart';
import '../../blocs/map/map_state.dart';
import '../../domain/models/track.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/track_list_item.dart';

class PlayedTracksMapPage extends StatefulWidget {
  const PlayedTracksMapPage({Key? key}) : super(key: key);

  @override
  State<PlayedTracksMapPage> createState() => _PlayedTracksMapPageState();
}

class _PlayedTracksMapPageState extends State<PlayedTracksMapPage> {
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    context.read<MapBloc>().add(MapTracksRequested());
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Played Tracks Map'),
      ),
      body: BlocConsumer<MapBloc, MapState>(
        listener: (context, state) {
          if (state is MapTracksLoaded || state is MapTrackSelectedState) {
            _fitBounds(state as MapTracksLoaded);
          }
        },
        builder: (context, state) {
          if (state is MapLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MapFailure) {
            return Center(child: Text('Error: ${state.error}'));
          }

          if (state is MapTracksLoaded || state is MapTrackSelectedState) {
            final loadedState = state as MapTracksLoaded;
            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(0, 0),
                    zoom: 2,
                  ),
                  markers: loadedState.markers,
                  onMapCreated: (controller) {
                    _mapController = controller;
                    _fitBounds(loadedState);
                  },
                ),
                if (state is MapTrackSelectedState)
                  _buildTrackInfoCard(state.selectedTrack),
              ],
            );
          }

          return const Center(child: Text('No tracks to display'));
        },
      ),
    );
  }

  void _fitBounds(MapTracksLoaded state) {
    if (_mapController != null && state.markers.isNotEmpty) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(state.bounds, 50),
      );
    }
  }

  Widget _buildTrackInfoCard(Track track) {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                track.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                track.artistName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (track.albumName != null) ...[
                const SizedBox(height: 4),
                Text(
                  track.albumName!,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
              if (track.playedAt != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Played on: ${track.playedAt!.toString()}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
