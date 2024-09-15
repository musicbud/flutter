import 'package:flutter/material.dart';
import 'package:musicbud_flutter/models/common_track.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'package:geolocator/geolocator.dart';

class TrackDetailsPage extends StatefulWidget {
  final CommonTrack track;
  final ApiService apiService;

  const TrackDetailsPage({
    Key? key,
    required this.track,
    required this.apiService,
  }) : super(key: key);

  @override
  _TrackDetailsPageState createState() => _TrackDetailsPageState();
}

class _TrackDetailsPageState extends State<TrackDetailsPage> {
  bool _isLoading = false;
  String? _errorMessage;
  List<dynamic> _buds = [];

  String get _trackIdentifier => widget.track.uid ?? widget.track.id ?? '';

  Future<void> _getBudsByTrack() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final buds = await widget.apiService.getBudsByTrack(_trackIdentifier);
      setState(() {
        _buds = buds;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching buds: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _playTrack({String? service}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await widget.apiService.playTrack(_trackIdentifier, service: service);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(service != null ? 'Playing on $service' : 'Playing track')),
      );
    } catch (e) {
      setState(() {
        if (e.toString().contains('Track not found')) {
          _errorMessage = 'Track not found. It might not be available in our system.';
        } else {
          _errorMessage = 'Error playing track: $e';
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage!)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print('Track Details: uid = ${widget.track.uid}, id = ${widget.track.id}');
  }

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
                    widget.track.name ?? 'Unknown Track',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.track.artistName ?? 'Unknown Artist',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (widget.track.albumName != null) ...[
                    SizedBox(height: 8),
                    Text(
                      'Album: ${widget.track.albumName}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _isLoading ? null : () => _playTrack(service: 'spotify'),
                    child: Text('Play on Spotify'),
                  ),
                  ElevatedButton(
                    onPressed: _isLoading ? null : () => _playTrack(service: 'ytmusic'),
                    child: Text('Play on YouTube Music'),
                  ),
                  ElevatedButton(
                    onPressed: _isLoading ? null : () => _playTrack(service: 'lastfm'),
                    child: Text('Play on Last.fm'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _getBudsByTrack,
              child: _isLoading ? CircularProgressIndicator() : Text('Get Buds for This Track'),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            if (_buds.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Buds who like this track:',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _buds.length,
                      itemBuilder: (context, index) {
                        final bud = _buds[index];
                        return ListTile(
                          title: Text(bud['username'] ?? 'Unknown User'),
                          subtitle: Text(bud['email'] ?? ''),
                          // Add more details or styling as needed
                        );
                      },
                    ),
                  ],
                ),
              ),
            // Existing buttons and functionality...
          ],
        ),
      ),
    );
  }
}
