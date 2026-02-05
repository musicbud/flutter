import 'package:flutter/material.dart';
import '../../../domain/repositories/bud_repository.dart';
import '../../../domain/repositories/content_repository.dart';
import '../../../models/bud_match.dart';
import '../../../models/common_track.dart';
import '../../../injection_container.dart';
import '../../../core/theme/design_system.dart';
import '../../../presentation/navigation/main_navigation.dart';
import '../../../presentation/navigation/navigation_drawer.dart';

class TrackDetailsScreen extends StatefulWidget {
  final CommonTrack? track;

  const TrackDetailsScreen({
    super.key,
    this.track,
  });

  @override
  State<TrackDetailsScreen> createState() => _TrackDetailsScreenState();
}

class _TrackDetailsScreenState extends State<TrackDetailsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final MainNavigationController _navigationController;
  bool _isLoading = false;
  String? _errorMessage;
  List<BudMatch> _buds = [];

  CommonTrack get _track => widget.track ?? const CommonTrack(name: 'Sample Track', artistName: 'Sample Artist');

  String get _trackIdentifier {
    final uid = _track.uid;
    final id = _track.id;
    return uid ?? id ?? '';
  }

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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(service != null ? 'Playing on $service' : 'Playing track'),
            backgroundColor: DesignSystem.success,
          ),
        );
      }
    } catch (e) {
      setState(() {
        if (e.toString().contains('Track not found')) {
          _errorMessage = 'Track not found. It might not be available in our system.';
        } else {
          _errorMessage = 'Error playing track: $e';
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage!),
            backgroundColor: DesignSystem.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _navigationController = MainNavigationController();
    debugPrint('Track Details: uid = ${_track.uid}, id = ${_track.id}');
  }

  @override
  void dispose() {
    _navigationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Track Details'),
        backgroundColor: DesignSystem.surface,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: MainNavigationDrawer(
        navigationController: _navigationController,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: DesignSystem.gradientBackground,
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
                      _track.name,
                      style: DesignSystem.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _track.artistName ?? 'Unknown Artist',
                      style: DesignSystem.titleMedium,
                    ),
                    if (_track.albumName != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Album: ${_track.albumName}',
                        style: DesignSystem.bodyMedium,
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
                        backgroundColor: DesignSystem.primary,
                        foregroundColor: DesignSystem.onPrimary,
                      ),
                      child: const Text('Play on Spotify'),
                    ),
                    ElevatedButton(
                      onPressed: _isLoading ? null : () => _playTrack(service: 'ytmusic'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DesignSystem.primary,
                        foregroundColor: DesignSystem.onPrimary,
                      ),
                      child: const Text('Play on YouTube Music'),
                    ),
                    ElevatedButton(
                      onPressed: _isLoading ? null : () => _playTrack(service: 'lastfm'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DesignSystem.primary,
                        foregroundColor: DesignSystem.onPrimary,
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
                    backgroundColor: DesignSystem.primary,
                    foregroundColor: DesignSystem.onPrimary,
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
                    style: const TextStyle(color: DesignSystem.error),
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
                        style: DesignSystem.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _buds.length,
                        itemBuilder: (context, index) {
                          final bud = _buds[index];
                          return Card(
                            color: DesignSystem.surface,
                            child: ListTile(
                              title: Text(
                                bud.username,
                                style: const TextStyle(color: DesignSystem.onSurface),
                              ),
                              subtitle: Text(
                                bud.email ?? '',
                                style: const TextStyle(color: DesignSystem.onSurfaceVariant),
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
