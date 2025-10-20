import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/discover/discover_bloc.dart';
import '../../../blocs/discover/discover_event.dart';
import '../../../blocs/discover/discover_state.dart';
import '../../../core/theme/design_system.dart';
import '../../../models/common_track.dart';

// Enhanced UI Library - All components
import '../../widgets/enhanced/enhanced_widgets.dart';

class TopTracksPage extends StatefulWidget {
  const TopTracksPage({super.key});

  @override
  State<TopTracksPage> createState() => _TopTracksPageState();
}

class _TopTracksPageState extends State<TopTracksPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load top tracks on init
    context.read<DiscoverBloc>().add(const FetchTopTracks());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoadingMore) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    setState(() {
      _isLoadingMore = true;
    });

    // For now, just reload - in future could implement pagination
    context.read<DiscoverBloc>().add(const FetchTopTracks());

    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Top Tracks',
          style: DesignSystem.headlineSmall.copyWith(
            color: DesignSystem.onSurface,
          ),
        ),
        backgroundColor: DesignSystem.surface,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: DesignSystem.gradientBackground,
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<DiscoverBloc>().add(const FetchTopTracks());
          },
          child: BlocBuilder<DiscoverBloc, DiscoverState>(
            builder: (context, state) {
              if (state is TopTracksLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is TopTracksError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: DesignSystem.error,
                      ),
                      const SizedBox(height: DesignSystem.spacingMD),
                      Text(
                        'Failed to load top tracks',
                        style: DesignSystem.bodyMedium.copyWith(
                          color: DesignSystem.onSurface,
                        ),
                      ),
                      const SizedBox(height: DesignSystem.spacingMD),
                      Text(
                        state.message,
                        style: DesignSystem.caption.copyWith(
                          color: DesignSystem.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: DesignSystem.spacingLG),
                      ModernButton(
                        text: 'Retry',
                        onPressed: () {
                          context.read<DiscoverBloc>().add(const FetchTopTracks());
                        },
                        variant: ModernButtonVariant.primary,
                        size: ModernButtonSize.medium,
                      ),
                    ],
                  ),
                );
              }

              if (state is TopTracksLoaded) {
                final tracks = state.tracks;
                if (tracks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.music_note,
                          size: 64,
                          color: DesignSystem.onSurfaceVariant,
                        ),
                        const SizedBox(height: DesignSystem.spacingMD),
                        Text(
                          'No top tracks available',
                          style: DesignSystem.bodyMedium.copyWith(
                            color: DesignSystem.onSurface,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(DesignSystem.spacingMD),
                  itemCount: tracks.length + (_isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == tracks.length) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final track = tracks[index];
                    return _buildTrackItem(track);
                  },
                );
              }

              return const Center(
                child: Text('Loading top tracks...'),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTrackItem(CommonTrack track) {
    return Container(
      margin: const EdgeInsets.only(bottom: DesignSystem.spacingMD),
      padding: const EdgeInsets.all(DesignSystem.spacingMD),
      decoration: BoxDecoration(
        color: DesignSystem.surfaceContainer,
        borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
        boxShadow: DesignSystem.shadowCard,
      ),
      child: Row(
        children: [
          // Track image
          ImageWithFallback(
            imageUrl: track.imageUrl,
            width: 60,
            height: 60,
            borderRadius: DesignSystem.radiusSM,
            fallbackIcon: Icons.music_note,
          ),
          const SizedBox(width: DesignSystem.spacingMD),

          // Track info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.name,
                  style: DesignSystem.titleSmall.copyWith(
                    color: DesignSystem.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: DesignSystem.spacingXS),
                Text(
                  track.artistName ?? 'Unknown Artist',
                  style: DesignSystem.bodySmall.copyWith(
                    color: DesignSystem.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (track.durationMs != null) ...[
                  const SizedBox(height: DesignSystem.spacingXS),
                  Text(
                    _formatDuration(track.durationMs!),
                    style: DesignSystem.caption.copyWith(
                      color: DesignSystem.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Action buttons
          Column(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.play_arrow,
                  color: DesignSystem.primary,
                ),
                onPressed: () {
                  // TODO: Implement play functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Playing: ${track.name}')),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  track.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: track.isLiked ? DesignSystem.error : DesignSystem.onSurfaceVariant,
                ),
                onPressed: () {
                  // TODO: Implement like functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(track.isLiked ? 'Unliked' : 'Liked')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}