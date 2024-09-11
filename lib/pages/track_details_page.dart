import 'package:flutter/material.dart';
import 'package:musicbud_flutter/models/common_track.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'package:geolocator/geolocator.dart';

class TrackDetailsPage extends StatelessWidget {
  final CommonTrack track;
  final ApiService apiService;

  const TrackDetailsPage({
    Key? key,
    required this.track,
    required this.apiService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.name ?? 'Unknown Track',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 8),
                  Text(
                    track.artistName ?? 'Unknown Artist',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (track.albumName != null) ...[
                    SizedBox(height: 8),
                    Text(
                      'Album: ${track.albumName}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (track.uid == null || track.uid!.isEmpty) {
                  print('Error: track.uid is null or empty');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Cannot play track: Missing track ID')),
                  );
                  return;
                }

                try {
                  final position = await Geolocator.getCurrentPosition();
                  
                  print('Track details:');
                  print('UID: ${track.uid}');
                  print('Name: ${track.name}');
                  
                  await apiService.playTrackWithLocation(
                    track.uid!,  // Use the non-null assertion operator
                    track.name ?? 'Unknown Track',
                    position.latitude,
                    position.longitude,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Track played with location')),
                  );
                } catch (e) {
                  print('Error playing track with location: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to play track with location: ${e.toString()}')),
                  );
                }
              },
              child: Text('Play Track with Location'),
            ),
            // Add more widgets for additional track information or functionality
          ],
        ),
      ),
    );
  }
}
