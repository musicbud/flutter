import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/design_system.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../blocs/discover/discover_bloc.dart';
import '../../../blocs/discover/discover_state.dart';
import '../../widgets/builders/state_builder.dart';
import '../../widgets/builders/card_builder.dart';
import '../../widgets/builders/list_builder.dart';
import '../../widgets/composers/section_composer.dart';
import '../../widgets/common/modern_card.dart';
import '../../widgets/common/app_scaffold.dart';

/// Enhanced Discover Screen demonstrating modern component usage
/// 
/// This is an example of how to refactor existing screens to use the
/// advanced widget composition patterns available in the app.
class EnhancedDiscoverExample extends StatefulWidget {
  const EnhancedDiscoverExample({super.key});

  @override
  State<EnhancedDiscoverExample> createState() => _EnhancedDiscoverExampleState();
}

class _EnhancedDiscoverExampleState extends State<EnhancedDiscoverExample> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Discover',
      showBackButton: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => Navigator.pushNamed(context, AppRoutes.search),
        ),
      ],
      body: BlocBuilder<DiscoverBloc, DiscoverState>(
        builder: (context, state) {
          return StateBuilder()
              .withState(_getStateType(state))
              .withLoadingMessage('Discovering amazing content...')
              .withLoadingWidget(_buildCustomLoadingWidget())
              .withErrorMessage('Failed to load discover content')
              .withEmptyMessage('No content available')
              .withEmptyIcon(Icons.explore_off)
              .withOnRetry(() => _retryLoad(context))
              .withContent(child: _buildSuccessContent(state))
              .build();
        },
      ),
    );
  }

  StateType _getStateType(DiscoverState state) {
    if (state is DiscoverLoading) return StateType.loading;
    if (state is DiscoverError) return StateType.error;
    if (state is DiscoverLoaded && state.isEmpty) return StateType.empty;
    return StateType.success;
  }

  Widget _buildCustomLoadingWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: DesignSystem.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(DesignSystem.radiusCircular),
          ),
          child: const Icon(
            Icons.explore,
            size: 40,
            color: DesignSystem.primary,
          ),
        ),
        const SizedBox(height: DesignSystem.spacingLG),
        Text(
          'Discovering amazing content...',
          style: DesignSystem.bodyLarge.copyWith(
            color: DesignSystem.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessContent(DiscoverState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero Section with Featured Content
          _buildHeroSection(),
          
          const SizedBox(height: DesignSystem.spacingXL),
          
          // Trending Tracks Section
          SectionComposer()
              .withTitle('Trending Now')
              .withSubtitle('What\'s hot right now')
              .withAction(
                text: 'View All',
                onPressed: () => Navigator.pushNamed(context, AppRoutes.topTracks),
              )
              .withContent(child: _buildTrendingTracksCarousel())
              .build(),
          
          const SizedBox(height: DesignSystem.spacingXL),
          
          // New Releases Section
          SectionComposer()
              .withTitle('New Releases')
              .withSubtitle('Fresh music just for you')
              .withContent(child: _buildNewReleasesGrid())
              .build(),
          
          const SizedBox(height: DesignSystem.spacingXL),
          
          // Top Artists Section
          SectionComposer()
              .withTitle('Top Artists')
              .withAction(
                text: 'Explore More',
                onPressed: () {
                  // Navigate to artists page
                },
              )
              .withContent(child: _buildTopArtistsCarousel())
              .build(),
          
          const SizedBox(height: DesignSystem.spacingXXL),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return CardBuilder()
        .withVariant(CardVariant.featured)
        .withHeight(200)
        .withMargin(const EdgeInsets.all(DesignSystem.spacingMD))
        .withBackgroundImage('https://example.com/hero-image.jpg')
        .withOverlay(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              DesignSystem.background.withOpacity(0.8),
            ],
          ),
        )
        .withContent(
          child: Padding(
            padding: const EdgeInsets.all(DesignSystem.spacingLG),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Discover New Music',
                  style: DesignSystem.headlineMedium.copyWith(
                    color: DesignSystem.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: DesignSystem.spacingSM),
                Text(
                  'Curated playlists and trending tracks',
                  style: DesignSystem.bodyMedium.copyWith(
                    color: DesignSystem.onPrimary.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        )
        .withOnTap(() {
          // Navigate to featured content
        })
        .build();
  }

  Widget _buildTrendingTracksCarousel() {
    final mockTracks = List.generate(10, (index) => {
      'id': 'track_$index',
      'title': 'Trending Track ${index + 1}',
      'artist': 'Artist Name',
      'image': 'https://example.com/track_$index.jpg',
      'isPlaying': index == 2, // Mock currently playing
    });

    return SizedBox(
      height: 180,
      child: ListBuilder<Map<String, dynamic>>()
          .withItems(mockTracks)
          .withScrollDirection(Axis.horizontal)
          .withItemBuilder((context, track, index) {
            return Container(
              width: 140,
              margin: EdgeInsets.only(
                left: index == 0 ? DesignSystem.spacingMD : 0,
                right: DesignSystem.spacingMD,
              ),
              child: ModernCard(
                imageUrl: track['image'],
                title: track['title'],
                subtitle: track['artist'],
                tag: track['isPlaying'] == true ? 'Now Playing' : '#${index + 1}',
                tagColor: track['isPlaying'] == true 
                    ? DesignSystem.success 
                    : DesignSystem.primary,
                onTap: () {
                  // Play track
                },
              ),
            );
          })
          .withPadding(EdgeInsets.zero)
          .build(),
    );
  }

  Widget _buildNewReleasesGrid() {
    final mockReleases = List.generate(6, (index) => {
      'id': 'release_$index',
      'title': 'New Album ${index + 1}',
      'artist': 'Artist ${index + 1}',
      'image': 'https://example.com/album_$index.jpg',
      'releaseDate': '2024',
    });

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingMD),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: DesignSystem.spacingMD,
        mainAxisSpacing: DesignSystem.spacingMD,
        childAspectRatio: 0.8,
      ),
      itemCount: mockReleases.length,
      itemBuilder: (context, index) {
        final release = mockReleases[index];
        return ModernCard(
          imageUrl: release['image'],
          title: release['title'],
          subtitle: release['artist'],
          tag: 'NEW',
          tagColor: DesignSystem.success,
          onTap: () {
            // Navigate to album
          },
        );
      },
    );
  }

  Widget _buildTopArtistsCarousel() {
    final mockArtists = List.generate(8, (index) => {
      'id': 'artist_$index',
      'name': 'Artist ${index + 1}',
      'genre': 'Pop',
      'image': 'https://example.com/artist_$index.jpg',
      'followers': '${(index + 1) * 100}K followers',
    });

    return SizedBox(
      height: 200,
      child: ListBuilder<Map<String, dynamic>>()
          .withItems(mockArtists)
          .withScrollDirection(Axis.horizontal)
          .withItemBuilder((context, artist, index) {
            return Container(
              width: 160,
              margin: EdgeInsets.only(
                left: index == 0 ? DesignSystem.spacingMD : 0,
                right: DesignSystem.spacingMD,
              ),
              child: CardBuilder()
                  .withVariant(CardVariant.outlined)
                  .withImageUrl(artist['image'])
                  .withImageAspectRatio(1.0)
                  .withHeader(
                    title: artist['name'],
                    subtitle: artist['followers'],
                  )
                  .withOnTap(() {
                    Navigator.pushNamed(
                      context, 
                      AppRoutes.artistDetails,
                      arguments: artist['id'],
                    );
                  })
                  .build(),
            );
          })
          .withPadding(EdgeInsets.zero)
          .build(),
    );
  }

  void _retryLoad(BuildContext context) {
    // Trigger reload of discover content
    context.read<DiscoverBloc>().add(const FetchDiscoverContent());
  }
}

/// Card variants for different use cases
enum CardVariant {
  primary,
  secondary,
  outlined,
  featured,
}

/// State types for state builder
enum StateType {
  loading,
  success,
  error,
  empty,
}

/// Mock classes to demonstrate the pattern (these would be imported from actual files)
class SectionComposer {
  String? _title;
  String? _subtitle;
  String? _actionText;
  VoidCallback? _onActionPressed;
  Widget? _content;

  SectionComposer withTitle(String title) {
    _title = title;
    return this;
  }

  SectionComposer withSubtitle(String subtitle) {
    _subtitle = subtitle;
    return this;
  }

  SectionComposer withAction({required String text, required VoidCallback onPressed}) {
    _actionText = text;
    _onActionPressed = onPressed;
    return this;
  }

  SectionComposer withContent({required Widget child}) {
    _content = child;
    return this;
  }

  Widget build() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingMD),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_title != null)
                    Text(
                      _title!,
                      style: DesignSystem.headlineSmall.copyWith(
                        color: DesignSystem.onSurface,
                      ),
                    ),
                  if (_subtitle != null)
                    Text(
                      _subtitle!,
                      style: DesignSystem.bodyMedium.copyWith(
                        color: DesignSystem.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
              if (_actionText != null && _onActionPressed != null)
                TextButton(
                  onPressed: _onActionPressed,
                  child: Text(_actionText!),
                ),
            ],
          ),
        ),
        const SizedBox(height: DesignSystem.spacingMD),
        if (_content != null) _content!,
      ],
    );
  }
}

class StateBuilder {
  StateType _state = StateType.success;
  String _loadingMessage = 'Loading...';
  Widget? _loadingWidget;
  String _errorMessage = 'Something went wrong';
  String _emptyMessage = 'No data available';
  IconData _emptyIcon = Icons.inbox;
  VoidCallback? _onRetry;
  Widget? _content;

  StateBuilder withState(StateType state) {
    _state = state;
    return this;
  }

  StateBuilder withLoadingMessage(String message) {
    _loadingMessage = message;
    return this;
  }

  StateBuilder withLoadingWidget(Widget widget) {
    _loadingWidget = widget;
    return this;
  }

  StateBuilder withErrorMessage(String message) {
    _errorMessage = message;
    return this;
  }

  StateBuilder withEmptyMessage(String message) {
    _emptyMessage = message;
    return this;
  }

  StateBuilder withEmptyIcon(IconData icon) {
    _emptyIcon = icon;
    return this;
  }

  StateBuilder withOnRetry(VoidCallback callback) {
    _onRetry = callback;
    return this;
  }

  StateBuilder withContent({required Widget child}) {
    _content = child;
    return this;
  }

  Widget build() {
    switch (_state) {
      case StateType.loading:
        return _loadingWidget ?? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: DesignSystem.spacingMD),
              Text(_loadingMessage),
            ],
          ),
        );
      case StateType.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: DesignSystem.error),
              const SizedBox(height: DesignSystem.spacingMD),
              Text(_errorMessage),
              if (_onRetry != null) ...[
                const SizedBox(height: DesignSystem.spacingMD),
                ElevatedButton(
                  onPressed: _onRetry,
                  child: const Text('Retry'),
                ),
              ],
            ],
          ),
        );
      case StateType.empty:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_emptyIcon, size: 64, color: DesignSystem.onSurfaceVariant),
              const SizedBox(height: DesignSystem.spacingMD),
              Text(_emptyMessage),
            ],
          ),
        );
      case StateType.success:
        return _content ?? const SizedBox();
    }
  }
}

// Mock event class
class FetchDiscoverContent {
  const FetchDiscoverContent();
}