import 'package:flutter/material.dart';
import '../../models/track.dart';
import '../../../core/theme/design_system.dart';
import 'common/image_with_fallback.dart';
import 'common/modern_button.dart';
import 'factories/card_factory.dart';
import 'mixins/interaction/hover_mixin.dart';
import 'mixins/interaction/focus_mixin.dart';

class TopTracksHorizontalList extends StatefulWidget {
  final List<Track> initialTracks;
  final Future<List<Track>> Function(int page) loadMoreTracks;
  final bool enableHover;
  final bool enableFocus;
  final bool showLoadMoreButton;

  const TopTracksHorizontalList({
    Key? key,
    required this.initialTracks,
    required this.loadMoreTracks,
    this.enableHover = true,
    this.enableFocus = true,
    this.showLoadMoreButton = true,
  }) : super(key: key);

  @override
  TopTracksHorizontalListState createState() => TopTracksHorizontalListState();
}

class TopTracksHorizontalListState extends State<TopTracksHorizontalList>
    with HoverMixin<TopTracksHorizontalList>, FocusMixin<TopTracksHorizontalList> {
  late List<Track> _tracks;
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasReachedEnd = false;
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _tracks = widget.initialTracks;
    if (widget.enableHover) {
      setupHover(
        onHover: () {},
        onExit: () {},
        enableScaleAnimation: false,
      );
    }
    if (widget.enableFocus) {
      setupFocus(
        onFocus: () {},
        onUnfocus: () {},
      );
    }
  }

  Future<void> _loadMoreTracks() async {
    if (!_isLoading && !_hasReachedEnd) {
      setState(() {
        _isLoading = true;
      });

      final scaffoldMessenger = ScaffoldMessenger.of(context);
      try {
        final newTracks = await widget.loadMoreTracks(_currentPage + 1);

        setState(() {
          _tracks.addAll(newTracks);
          _currentPage++;
          _hasReachedEnd = newTracks.length < _pageSize;
          _isLoading = false;
        });
      } catch (e) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Error loading tracks: $e'),
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildTrackCard(Track track) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return CardFactory().createTrackCard(
      context: context,
      title: track.name,
      artist: track.artistName ?? 'Unknown Artist',
      album: track.albumName ?? 'Unknown Album',
      imageUrl: track.imageUrl ?? '',
      duration: track.durationMs != null ? Duration(milliseconds: track.durationMs!) : const Duration(minutes: 3),
      onTap: () {
        // TODO: Navigate to track details or play track
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Playing ${track.name}'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      onPlay: () {
        // TODO: Implement play functionality
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Playing ${track.name}'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _tracks.length + (widget.showLoadMoreButton ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _tracks.length) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (!_hasReachedEnd) {
            return Padding(
              padding: EdgeInsets.all(design.designSystemSpacing.md),
              child: ModernButton(
                text: 'Load More',
                onPressed: _loadMoreTracks,
                variant: ModernButtonVariant.outline,
                size: ModernButtonSize.medium,
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }
        final track = _tracks[index];
        return Padding(
          padding: EdgeInsets.only(right: design.designSystemSpacing.md),
          child: _buildTrackCard(track),
        );
      },
    );
  }
}
