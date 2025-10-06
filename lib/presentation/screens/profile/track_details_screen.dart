import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/bud_repository.dart';
import '../../../domain/repositories/content_repository.dart';
import '../../../models/bud_match.dart';
import '../../../models/common_track.dart';
import '../../../core/theme/app_theme.dart';
import '../../../injection_container.dart';

class TrackDetailsScreen extends StatefulWidget {
  final CommonTrack track;

  const TrackDetailsScreen({
    super.key,
    required this.track,
  });

  @override
  State<TrackDetailsScreen> createState() => _TrackDetailsScreenState();
}

class _TrackDetailsScreenState extends State<TrackDetailsScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  List<BudMatch> _buds = [];

  String get _trackIdentifier => widget.track.uid ?? widget.track.id ?? '';

  Future<void> _getBudsByTrack() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final buds = await sl<BudRepository>().getBudsByTrack(_trackIdentifier);
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
      await sl<ContentRepository>().playTrackOnService(_trackIdentifier, service: service);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(service != null ? 'Playing on $service' : 'Playing track'),
          backgroundColor: AppTheme.of(context).colors.successGreen,
        ),
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
        SnackBar(
          content: Text(_errorMessage!),
          backgroundColor: AppTheme.of(context).colors.errorRed,
        ),
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
    debugPrint('Track Details: uid = ${widget.track.uid}, id = ${widget.track.id}');
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Details'),
        backgroundColor: appTheme.colors.surface,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: appTheme.gradients.backgroundGradient,
        ),
        child: SingleChildScrollView(
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
                      style: appTheme.typography.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.track.artistName ?? 'Unknown Artist',
                      style: appTheme.typography.titleMedium,
                    ),
                    if (widget.track.albumName != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Album: ${widget.track.albumName}',
                        style: appTheme.typography.bodyMedium,
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appTheme.colors.primary,
                        foregroundColor: appTheme.colors.onPrimary,
                      ),
                      child: const Text('Play on Spotify'),
                    ),
                    ElevatedButton(
                      onPressed: _isLoading ? null : () => _playTrack(service: 'ytmusic'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appTheme.colors.primary,
                        foregroundColor: appTheme.colors.onPrimary,
                      ),
                      child: const Text('Play on YouTube Music'),
                    ),
                    ElevatedButton(
                      onPressed: _isLoading ? null : () => _playTrack(service: 'lastfm'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appTheme.colors.primary,
                        foregroundColor: appTheme.colors.onPrimary,
                      ),
                      child: const Text('Play on Last.fm'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _getBudsByTrack,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.colors.primary,
                    foregroundColor: appTheme.colors.onPrimary,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Get Buds for This Track'),
                ),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: appTheme.colors.errorRed),
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
                        style: appTheme.typography.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _buds.length,
                        itemBuilder: (context, index) {
                          final bud = _buds[index];
                          return Card(
                            color: appTheme.colors.surface,
                            child: ListTile(
                              title: Text(
                                bud.username ?? 'Unknown User',
                                style: TextStyle(color: appTheme.colors.onSurface),
                              ),
                              subtitle: Text(
                                bud.email ?? '',
                                style: TextStyle(color: appTheme.colors.onSurfaceVariant),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}