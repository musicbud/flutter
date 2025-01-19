import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../blocs/map/map_bloc.dart';
import '../../blocs/map/map_event.dart';
import '../../blocs/map/map_state.dart';

class PlayedTracksMapPage extends StatefulWidget {
  const PlayedTracksMapPage({super.key});

  @override
  State<PlayedTracksMapPage> createState() => _PlayedTracksMapPageState();
}

class _PlayedTracksMapPageState extends State<PlayedTracksMapPage> {
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    context.read<MapBloc>().add(MapTracksRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Played Tracks Map'),
      ),
      body: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          if (state is MapTracksLoaded || state is MapTrackSelectedState) {
            final loadedState = state as MapTracksLoaded;
            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(0, 0),
                    zoom: 2,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                    _mapController.animateCamera(
                      CameraUpdate.newLatLngBounds(loadedState.bounds, 50),
                    );
                  },
                  markers: loadedState.markers,
                ),
                if (state is MapTrackSelectedState)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.selectedTrack.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.selectedTrack.artistName ??
                                  'Unknown Artist',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          } else if (state is MapLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MapFailure) {
            return Center(child: Text(state.error));
          }
          return const Center(child: Text('No tracks found'));
        },
      ),
    );
  }
}
