import 'package:flutter/material.dart';
import 'package:musicbud_flutter/models/common_track.dart';
import 'package:musicbud_flutter/services/api_service.dart';

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
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final buds = await widget.apiService.getBudsByTrack(_trackIdentifier);
      if (!mounted) return;

      setState(() {
        _buds = buds;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error fetching buds: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _playTrack({String? service}) async {
    if (!mounted) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await widget.apiService.playTrack(_trackIdentifier, service: service);
      if (!mounted) return;

      scaffoldMessenger.showSnackBar(
        SnackBar(
            content: Text(
                service != null ? 'Playing on $service' : 'Playing track')),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        if (e.toString().contains('Track not found')) {
          _errorMessage =
              'Track not found. It might not be available in our system.';
        } else {
          _errorMessage = 'Error playing track: $e';
        }
      });
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(_errorMessage!)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
        title: const Text('Track Details'),
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
                    widget.track.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.track.artistName ?? 'Unknown Artist',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (widget.track.albumName != null) ...[
                    const SizedBox(height: 8),
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
                    onPressed: _isLoading
                        ? null
                        : () => _playTrack(service: 'spotify'),
                    child: const Text('Play on Spotify'),
                  ),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () => _playTrack(service: 'ytmusic'),
                    child: const Text('Play on YouTube Music'),
                  ),
                  ElevatedButton(
                    onPressed:
                        _isLoading ? null : () => _playTrack(service: 'lastfm'),
                    child: const Text('Play on Last.fm'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _getBudsByTrack,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Get Buds for This Track'),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
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
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
