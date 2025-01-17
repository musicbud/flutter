import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:musicbud_flutter/models/common_track.dart';
import 'package:musicbud_flutter/services/api_service.dart';

class PlayedTracksMapPage extends StatefulWidget {
  final ApiService apiService;

  const PlayedTracksMapPage({Key? key, required this.apiService}) : super(key: key);

  @override
  _PlayedTracksMapPageState createState() => _PlayedTracksMapPageState();
}

class _PlayedTracksMapPageState extends State<PlayedTracksMapPage> {
  GoogleMapController? mapController;
  Map<MarkerId, Marker> markers = {};
  List<CommonTrack> tracksWithLocation = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchTracksWithLocation();
  }

  Future<void> _fetchTracksWithLocation() async {
    try {
      final tracks = await widget.apiService.getPlayedTracksWithLocation();
      setState(() {
        tracksWithLocation = tracks;
        if (tracks.isNotEmpty) {
          _createMarkers();
        }
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching tracks with location: $e');
      setState(() {
        errorMessage = 'Failed to load tracks with location. Please try again later.';
        isLoading = false;
      });
    }
  }

  void _createMarkers() {
    for (var track in tracksWithLocation) {
      if (track.latitude != null && track.longitude != null) {
        final markerId = MarkerId(track.id ?? '');
        final marker = Marker(
          markerId: markerId,
          position: LatLng(track.latitude!, track.longitude!),
          infoWindow: InfoWindow(
            title: track.name,
            snippet: track.artistName ?? 'Unknown Artist',
          ),
        );
        markers[markerId] = marker;
      }
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Played Tracks Map'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    } else if (tracksWithLocation.isEmpty) {
      return const Center(child: Text('No tracks with location data available.'));
    } else {
      return GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            tracksWithLocation[0].latitude ?? 0,
            tracksWithLocation[0].longitude ?? 0,
          ),
          zoom: 10,
        ),
        markers: Set<Marker>.of(markers.values),
      );
    }
  }
}
