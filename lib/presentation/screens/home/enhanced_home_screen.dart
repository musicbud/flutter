import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/components/musicbud_components.dart';
import '../../../core/theme/design_system.dart';
import '../../../services/dynamic_navigation_service.dart';
import '../../../services/mock_data_service.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../../blocs/user/user_event.dart';
import '../../../blocs/user/user_state.dart';
import '../../../blocs/content/content_bloc.dart';
import '../../../blocs/content/content_event.dart' as content_events;
import '../../../blocs/content/content_state.dart';
import '../../../blocs/discover/discover_bloc.dart';
import '../../../blocs/discover/discover_event.dart';
import '../../../blocs/discover/discover_state.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/simple_content_bloc.dart';
import '../../widgets/imported/empty_state.dart';

/// Enhanced Home Screen using MusicBud Components Library
/// Preserves all BLoC architecture and real data consumption
class EnhancedHomeScreen extends StatefulWidget {
  const EnhancedHomeScreen({super.key});

  @override
  State<EnhancedHomeScreen> createState() => _EnhancedHomeScreenState();
}

class _EnhancedHomeScreenState extends State<EnhancedHomeScreen> {
  final DynamicNavigationService _navigation = DynamicNavigationService.instance;
  
  // State variables
  bool _hasTriggeredInitialLoad = false;
  bool _isOffline = false;
  int _selectedCategory = 0;
  final List<String> _categories = ['Music', 'Movies', 'Anime'];
  
  // Mock data for offline fallback
  List<Map<String, dynamic>>? _mockTopArtists;
  List<Map<String, dynamic>>? _mockTopTracks;
  List<Map<String, dynamic>>? _mockActivity;

  @override
  void initState() {
    super.initState();
    _initializeMockData();
  }

  void _initializeMockData() {
    _mockTopArtists = MockDataService.generateTopArtists(count: 10);
    _mockTopTracks = MockDataService.generateTopTracks(count: 15);
    _mockActivity = MockDataService.generateRecentActivity(count: 10);
  }

  void _triggerInitialDataLoad() {
    if (!_hasTriggeredInitialLoad && !_isOffline) {
      _hasTriggeredInitialLoad = true;
      try {
        context.read<UserBloc>().add(LoadMyProfile());
        context.read<ContentBloc>().add(content_events.LoadTopContent());
        context.read<ContentBloc>().add(content_events.LoadTopTracks());
        context.read<ContentBloc>().add(content_events.LoadTopArtists());
        context.read<DiscoverBloc>().add(const DiscoverPageLoaded());
        context.read<DiscoverBloc>().add(const FetchTrendingTracks());
      } catch (e) {
        setState(() => _isOffline = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Trigger initial data load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerInitialDataLoad();
    });

    return MultiBlocListener(
      listeners: [
        BlocListener<ContentBloc, ContentState>(
          listener: (context, state) {
            if (state is ContentError) {
              setState(() {
                if (state.message.contains('network') || state.message.contains('connection')) {
                  _isOffline = true;
                }
              });
            } else if (state is ContentLoaded) {
              setState(() => _isOffline = false);
            }
          },
        ),
        BlocListener<DiscoverBloc, DiscoverState>(
          listener: (context, state) {
            if (state is DiscoverError) {
              setState(() {
                if (state.message.contains('network') || state.message.contains('connection')) {
                  _isOffline = true;
                }
              });
            } else if (state is DiscoverLoaded) {
              setState(() => _isOffline = false);
            }
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Unauthenticated) {
              _navigation.navigateTo('/login');
            }
          },
        ),
      ],
      child: BlocBuilder<SimpleContentBloc, SimpleContentState>(
        builder: (context, simpleState) {
          return Scaffold(
            backgroundColor: DesignSystem.background,
            appBar: _buildAppBar(),
            body: RefreshIndicator(
              onRefresh: _refreshData,
              child: _buildBody(simpleState),
            ),
            floatingActionButton: _buildFloatingActionButton(),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        children: [
          Text(
            'MusicBud',
            style: DesignSystem.headlineMedium.copyWith(
              color: DesignSystem.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (_isOffline) ...[
            const SizedBox(width: DesignSystem.spacingXS),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignSystem.spacingXS,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: DesignSystem.warning.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(DesignSystem.radiusSM),
                border: Border.all(color: DesignSystem.warning, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off, size: 12, color: DesignSystem.warning),
                  const SizedBox(width: 4),
                  Text(
                    'Offline',
                    style: DesignSystem.labelSmall.copyWith(
                      color: DesignSystem.warning,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: DesignSystem.onSurface),
          onPressed: () => _navigation.navigateTo('/search'),
        ),
        if (_isOffline)
          IconButton(
            icon: const Icon(Icons.refresh, color: DesignSystem.onSurface),
            onPressed: _retryConnection,
          ),
        IconButton(
          icon: Stack(
            children: [
              const Icon(Icons.notifications_outlined, color: DesignSystem.onSurface),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: DesignSystem.pinkAccent,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () => _navigation.navigateTo('/notifications'),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        String displayName = 'Music Lover';
        String? avatarUrl;

        if (state is UserProfileLoaded) {
          displayName = state.profile.displayName ?? state.profile.username;
          avatarUrl = state.profile.avatarUrl;
        }

        return Padding(
          padding: const EdgeInsets.all(DesignSystem.spacingMD),
          child: Row(
            children: [
              MusicBudAvatar(
                imageUrl: avatarUrl,
                size: 44,
                hasBorder: true,
                onTap: () => _navigation.navigateTo('/profile'),
              ),
              const SizedBox(width: DesignSystem.spacingMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back,',
                      style: DesignSystem.bodySmall.copyWith(
                        color: DesignSystem.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      displayName,
                      style: DesignSystem.titleMedium.copyWith(
                        color: DesignSystem.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStoriesSection() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        // For now, show mock friends/buds
        return Container(
          height: 100,
          padding: const EdgeInsets.symmetric(vertical: DesignSystem.spacingSM),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingMD),
            itemCount: 8,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: DesignSystem.spacingMD),
                child: Column(
                  children: [
                    MusicBudAvatar(
                      imageUrl: null,
                      size: 60,
                      hasBorder: true,
                      borderColor: DesignSystem.pinkAccent,
                      onTap: () {
                        debugPrint('Story $index tapped');
                      },
                    ),
                    const SizedBox(height: DesignSystem.spacingXXS),
                    Text(
                      index == 0 ? 'Your Story' : 'Bud $index',
                      style: DesignSystem.labelSmall.copyWith(
                        color: DesignSystem.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHeroCard() {
    return BlocBuilder<DiscoverBloc, DiscoverState>(
      builder: (context, state) {
        String title = 'Discover New Music';
        String subtitle = 'Trending this week';
        String? imageUrl;

        if (state is DiscoverLoaded && state.items.isNotEmpty) {
          final firstItem = state.items.first;
          title = firstItem.title ?? 'Discover New Music';
          subtitle = firstItem.subtitle ?? 'Trending this week';
          imageUrl = firstItem.imageUrl;
        } else if (_isOffline && _mockTopTracks != null && _mockTopTracks!.isNotEmpty) {
          final mockTrack = _mockTopTracks!.first;
          title = mockTrack['name'] ?? mockTrack['trackName'] ?? 'Discover New Music';
          subtitle = mockTrack['artist'] ?? mockTrack['artistName'] ?? 'Trending this week';
          imageUrl = mockTrack['imageUrl'];
        }

        return HeroCard(
          imageUrl: imageUrl,
          title: title,
          subtitle: subtitle,
          onPlayTap: () {
            debugPrint('Play tapped: $title');
            // TODO: Implement play functionality
          },
          onSaveTap: () {
            debugPrint('Save tapped: $title');
            // TODO: Implement save functionality
          },
        );
      },
    );
  }

  Widget _buildCategoryTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingMD),
      child: Row(
        children: List.generate(_categories.length, (index) {
          return Padding(
            padding: EdgeInsets.only(
              right: index < _categories.length - 1 ? DesignSystem.spacingMD : 0,
            ),
            child: CategoryTab(
              label: _categories[index],
              isSelected: _selectedCategory == index,
              onTap: () {
                setState(() {
                  _selectedCategory = index;
                });
                // TODO: Filter content by category
                debugPrint('Category selected: ${_categories[index]}');
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTrendingCarousel() {
    return BlocBuilder<DiscoverBloc, DiscoverState>(
      builder: (context, state) {
        List<Map<String, dynamic>> items = [];

        if (state is DiscoverLoaded && state.items.isNotEmpty) {
          items = state.items.take(10).map((item) => {
            'id': item.id,
            'title': item.title ?? 'Unknown',
            'subtitle': item.subtitle ?? '',
            'imageUrl': item.imageUrl,
          }).toList();
        } else if (state is TrendingTracksLoaded) {
          items = state.tracks.take(10).map((track) => {
            'id': track['id'],
            'title': track['name'] ?? 'Unknown Track',
            'subtitle': track['artist'] ?? 'Unknown Artist',
            'imageUrl': track['imageUrl'],
          }).toList();
        } else if (_isOffline && _mockTopTracks != null) {
          items = _mockTopTracks!.take(10).map((track) => {
            'id': track['id'] ?? '',
            'title': track['name'] ?? track['trackName'] ?? 'Unknown',
            'subtitle': track['artist'] ?? track['artistName'] ?? 'Unknown Artist',
            'imageUrl': track['imageUrl'],
          }).toList();
        }

        if (state is DiscoverLoading && !_isOffline) {
          return _buildSkeletonCarousel();
        }

        if (items.isEmpty) {
          return _buildEmptyState('No trending content available');
        }

        return SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingMD),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ContentCard(
                imageUrl: item['imageUrl'],
                title: item['title'] ?? 'Unknown',
                subtitle: item['subtitle'] ?? '',
                width: 120,
                height: 180,
                onTap: () {
                  debugPrint('Trending item tapped: ${item['title']}');
                  // TODO: Navigate to details
                },
                tag: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: DesignSystem.pinkAccent,
                    borderRadius: BorderRadius.circular(DesignSystem.radiusSM),
                  ),
                  child: Text(
                    '#${index + 1}',
                    style: DesignSystem.labelSmall.copyWith(
                      color: DesignSystem.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildForYouCarousel() {
    return BlocBuilder<DiscoverBloc, DiscoverState>(
      builder: (context, state) {
        List<Map<String, dynamic>> items = [];

        if (_isOffline && _mockTopTracks != null) {
          items = _mockTopTracks!.skip(5).take(10).map((track) => {
            'id': track['id'] ?? '',
            'title': track['name'] ?? track['trackName'] ?? 'Unknown',
            'subtitle': 'Based on your taste',
            'imageUrl': track['imageUrl'],
          }).toList();
        }

        if (items.isEmpty) {
          return _buildEmptyState('No recommendations yet');
        }

        return SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingMD),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ContentCard(
                imageUrl: item['imageUrl'],
                title: item['title'] ?? 'Unknown',
                subtitle: item['subtitle'] ?? 'Recommended',
                width: 120,
                height: 180,
                onTap: () {
                  debugPrint('Recommendation tapped: ${item['title']}');
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTopArtistsCarousel() {
    return BlocBuilder<ContentBloc, ContentState>(
      builder: (context, state) {
        List<Map<String, dynamic>> artists = [];

        if (state is ContentLoaded) {
          artists = state.topArtists.take(10).map((artist) => {
            'id': artist.id,
            'name': artist.name,
            'imageUrl': artist.imageUrls?.isNotEmpty == true ? artist.imageUrls!.first : null,
          }).toList();
        } else if (_isOffline && _mockTopArtists != null) {
          artists = _mockTopArtists!.take(10).toList();
        }

        if (state is ContentLoading && !_isOffline) {
          return _buildSkeletonCarousel();
        }

        if (artists.isEmpty) {
          return _buildEmptyState('No artists available');
        }

        return SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingMD),
            itemCount: artists.length,
            itemBuilder: (context, index) {
              final artist = artists[index];
              return ContentCard(
                imageUrl: artist['imageUrl'],
                title: artist['name'] ?? 'Unknown Artist',
                subtitle: 'Artist',
                width: 120,
                height: 180,
                onTap: () {
                  debugPrint('Artist tapped: ${artist['name']}');
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSkeletonCarousel() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingMD),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: DesignSystem.spacingMD),
            decoration: BoxDecoration(
              color: DesignSystem.surfaceContainer,
              borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingMD),
      child: Center(
        child: EmptyState(
          title: message,
          icon: Icons.music_note,
          iconSize: 48,
          actionText: _isOffline ? 'Retry' : null,
          actionCallback: _isOffline ? _retryConnection : null,
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    try {
      if (!_isOffline) {
        context.read<UserBloc>().add(LoadMyProfile());
        context.read<ContentBloc>().add(content_events.LoadTopContent());
        context.read<ContentBloc>().add(content_events.LoadTopTracks());
        context.read<ContentBloc>().add(content_events.LoadTopArtists());
        context.read<DiscoverBloc>().add(const DiscoverPageLoaded());
        context.read<DiscoverBloc>().add(const FetchTrendingTracks());
      }
    } catch (e) {
      debugPrint('Error refreshing data: $e');
      setState(() => _isOffline = true);
    }
  }

  void _retryConnection() {
    setState(() {
      _isOffline = false;
      _hasTriggeredInitialLoad = false;
    });
    _triggerInitialDataLoad();
  }

  Widget _buildBody(SimpleContentState simpleState) {
    if (simpleState is SimpleContentLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: DesignSystem.pinkAccent,
            ),
            const SizedBox(height: DesignSystem.spacingLG),
            Text(
              'Loading your music world...',
              style: DesignSystem.bodyLarge.copyWith(
                color: DesignSystem.onSurface,
              ),
            ),
          ],
        ),
      );
    }

    if (simpleState is SimpleContentError) {
      return _buildErrorState(simpleState.message);
    }

    return CustomScrollView(
      slivers: [
        // Header with profile and notifications
        SliverToBoxAdapter(
          child: _buildHeader(),
        ),

        // Quick Actions Grid
        if (simpleState is SimpleContentLoaded) 
          SliverToBoxAdapter(
            child: _buildQuickActions(context),
          ),

        // Stories / Active buds section
        SliverToBoxAdapter(
          child: _buildStoriesSection(),
        ),

        // Hero Card - Featured trending content
        SliverToBoxAdapter(
          child: _buildHeroCard(),
        ),

        // Category Tabs
        SliverToBoxAdapter(
          child: _buildCategoryTabs(),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: DesignSystem.spacingLG),
        ),

        // Content sections based on SimpleContentBloc data
        if (simpleState is SimpleContentLoaded) ...[
          // Top Artists Section
          if (simpleState.topArtists.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Top Artists',
                onSeeAllTap: () => _navigation.navigateTo('/discover'),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildSimpleArtistsCarousel(simpleState.topArtists),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: DesignSystem.spacingXL),
            ),
          ],

          // Top Tracks Section
          if (simpleState.topTracks.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Top Tracks',
                onSeeAllTap: () => _navigation.navigateTo('/discover'),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildSimpleTracksCarousel(simpleState.topTracks),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: DesignSystem.spacingXL),
            ),
          ],

          // Music Buds Section
          if (simpleState.buds.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Music Buds',
                onSeeAllTap: () => _navigation.navigateTo('/buds'),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildBudsCarousel(simpleState.buds),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: DesignSystem.spacingXL),
            ),
          ],
        ] else ...[
          // Fallback sections with BLoC data
          // Trending Now Section
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Trending Now',
              onSeeAllTap: () => _navigation.navigateTo('/discover'),
            ),
          ),

          SliverToBoxAdapter(
            child: _buildTrendingCarousel(),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: DesignSystem.spacingXL),
          ),

          // For You Section
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'For You',
              onSeeAllTap: () => _navigation.navigateTo('/recommendations'),
            ),
          ),

          SliverToBoxAdapter(
            child: _buildForYouCarousel(),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: DesignSystem.spacingXL),
          ),

          // Top Artists Section
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Top Artists',
              onSeeAllTap: () => _navigation.navigateTo('/artists'),
            ),
          ),

          SliverToBoxAdapter(
            child: _buildTopArtistsCarousel(),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: DesignSystem.spacingXL),
          ),
        ],
      ],
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: DesignSystem.errorRed,
          ),
          const SizedBox(height: DesignSystem.spacingLG),
          Text(
            'Oops! Something went wrong',
            style: DesignSystem.headlineSmall.copyWith(
              color: DesignSystem.onSurface,
            ),
          ),
          const SizedBox(height: DesignSystem.spacingSM),
          Text(
            message,
            textAlign: TextAlign.center,
            style: DesignSystem.bodyMedium.copyWith(
              color: DesignSystem.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: DesignSystem.spacingLG),
          MusicBudButton(
            text: 'Try Again',
            onPressed: () {
              context.read<SimpleContentBloc>().add(RefreshContent());
              _refreshData();
            },
            icon: Icons.refresh,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(DesignSystem.spacingMD),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Added to resolve overflow
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Quick Actions',
            onSeeAllTap: null,
          ),
          const SizedBox(height: DesignSystem.spacingSM),
          Flexible(
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: DesignSystem.spacingSM,
              crossAxisSpacing: DesignSystem.spacingSM,
              childAspectRatio: 1.5,
              children: [
                _buildQuickActionCard('Find Buds', Icons.people_rounded, DesignSystem.successGreen, '/buds'),
                _buildQuickActionCard('Chat', Icons.chat_bubble_rounded, DesignSystem.pinkAccent, '/chat'),
                _buildQuickActionCard('Discover', Icons.explore_rounded, DesignSystem.accentPurple, '/discover'),
                _buildQuickActionCard('Profile', Icons.person_rounded, DesignSystem.warningOrange, '/profile'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, Color color, String route) {
    return GestureDetector(
      onTap: () => _navigation.navigateTo(route),
      child: Container(
        padding: const EdgeInsets.all(DesignSystem.spacingMD),
        decoration: BoxDecoration(
          color: DesignSystem.surfaceContainer,
          borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
          boxShadow: DesignSystem.shadowCard,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(DesignSystem.spacingSM),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(DesignSystem.radiusSM),
              ),
              child: Icon(
                icon,
                size: 28,
                color: color,
              ),
            ),
            const SizedBox(height: DesignSystem.spacingSM),
            Text(
              title,
              style: DesignSystem.titleSmall.copyWith(
                color: DesignSystem.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleArtistsCarousel(List<Map<String, dynamic>> artists) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingMD),
        itemCount: artists.length,
        itemBuilder: (context, index) {
          final artist = artists[index];
          return ContentCard(
            imageUrl: null, // Artists from SimpleContentBloc may not have images
            title: artist['name'] ?? 'Unknown Artist',
            subtitle: '${artist['playCount'] ?? 0} plays',
            width: 120,
            height: 180,
            onTap: () {
              debugPrint('Artist tapped: ${artist['name']}');
            },
          );
        },
      ),
    );
  }

  Widget _buildSimpleTracksCarousel(List<Map<String, dynamic>> tracks) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingMD),
        itemCount: tracks.length,
        itemBuilder: (context, index) {
          final track = tracks[index];
          return ContentCard(
            imageUrl: null, // Tracks from SimpleContentBloc may not have images
            title: track['name'] ?? 'Unknown Track',
            subtitle: track['artist'] ?? 'Unknown Artist',
            width: 120,
            height: 180,
            onTap: () {
              debugPrint('Track tapped: ${track['name']}');
            },
            tag: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: DesignSystem.pinkAccent,
                borderRadius: BorderRadius.circular(DesignSystem.radiusSM),
              ),
              child: Text(
                '${track['playCount'] ?? 0}',
                style: DesignSystem.labelSmall.copyWith(
                  color: DesignSystem.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBudsCarousel(List<Map<String, dynamic>> buds) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingMD),
        itemCount: buds.length,
        itemBuilder: (context, index) {
          final bud = buds[index];
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: DesignSystem.spacingMD),
            child: Column(
              children: [
                MusicBudAvatar(
                  imageUrl: null,
                  size: 80,
                  hasBorder: true,
                  borderColor: DesignSystem.pinkAccent,
                  onTap: () => _navigation.navigateTo('/buds'),
                ),
                const SizedBox(height: DesignSystem.spacingSM),
                Text(
                  bud['displayName'] ?? 'Unknown Bud',
                  style: DesignSystem.titleSmall.copyWith(
                    color: DesignSystem.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: DesignSystem.spacingXS),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignSystem.spacingSM,
                    vertical: DesignSystem.spacingXXS,
                  ),
                  decoration: BoxDecoration(
                    color: DesignSystem.successGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(DesignSystem.radiusFull),
                    border: Border.all(
                      color: DesignSystem.successGreen.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${bud['matchPercentage'] ?? 85}% match',
                    style: DesignSystem.labelSmall.copyWith(
                      color: DesignSystem.successGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => _navigation.navigateTo('/chat'),
      backgroundColor: DesignSystem.pinkAccent,
      tooltip: 'Start Chat',
      child: const Icon(Icons.chat, color: DesignSystem.onSurface),
    );
  }
}
