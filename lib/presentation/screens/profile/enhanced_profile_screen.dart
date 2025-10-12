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
import '../../../blocs/content/content_event.dart';
import '../../../blocs/content/content_state.dart';

/// Enhanced Profile Screen using MusicBud Components Library
/// Preserves all BLoC architecture and real data consumption
class EnhancedProfileScreen extends StatefulWidget {
  final String? userId; // null for current user, or specific user ID

  const EnhancedProfileScreen({super.key, this.userId});

  @override
  State<EnhancedProfileScreen> createState() => _EnhancedProfileScreenState();
}

class _EnhancedProfileScreenState extends State<EnhancedProfileScreen>
    with SingleTickerProviderStateMixin {
  final DynamicNavigationService _navigation = DynamicNavigationService.instance;
  
  // State variables
  bool _hasTriggeredInitialLoad = false;
  bool _isOffline = false;
  int _selectedTab = 0;
  final List<String> _tabs = ['Playlists', 'Liked', 'History'];
  
  late TabController _tabController;
  
  // Mock data for offline fallback
  List<Map<String, dynamic>>? _mockPlaylists;
  List<Map<String, dynamic>>? _mockLikedTracks;
  List<Map<String, dynamic>>? _mockTopArtists;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _initializeMockData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _initializeMockData() {
    _mockPlaylists = MockDataService.generateTopTracks(count: 8);
    _mockLikedTracks = MockDataService.generateTopTracks(count: 12);
    _mockTopArtists = MockDataService.generateTopArtists(count: 10);
  }

  void _triggerInitialDataLoad() {
    if (!_hasTriggeredInitialLoad && !_isOffline) {
      _hasTriggeredInitialLoad = true;
      try {
        if (widget.userId == null) {
          // Load current user profile
          context.read<UserBloc>().add(LoadMyProfile());
          context.read<UserBloc>().add(LoadTopItems());
          context.read<UserBloc>().add(LoadLikedItems());
        } else {
          // Load specific user profile
          // TODO: Add event for loading other user profiles
        }
        context.read<ContentBloc>().add(LoadTopArtists());
        context.read<ContentBloc>().add(LoadTopTracks());
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
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserError) {
              setState(() {
                if (state.message.contains('network') || state.message.contains('connection')) {
                  _isOffline = true;
                }
              });
            }
          },
        ),
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
      ],
      child: Scaffold(
        backgroundColor: DesignSystem.background,
        body: CustomScrollView(
          slivers: [
            // Custom App Bar with cover image
            _buildSliverAppBar(),

            // Profile Header (Avatar, Name, Stats)
            SliverToBoxAdapter(
              child: _buildProfileHeader(),
            ),

            // Action Buttons
            SliverToBoxAdapter(
              child: _buildActionButtons(),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: DesignSystem.spacingLG),
            ),

            // Bio Section
            SliverToBoxAdapter(
              child: _buildBioSection(),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: DesignSystem.spacingXL),
            ),

            // Content Tabs
            SliverToBoxAdapter(
              child: _buildContentTabs(),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: DesignSystem.spacingLG),
            ),

            // Content Grid based on selected tab
            _buildContentGrid(),

            const SliverToBoxAdapter(
              child: SizedBox(height: DesignSystem.spacingXL),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: DesignSystem.surfaceContainer,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: DesignSystem.gradientCard,
          ),
          child: Stack(
            children: [
              // Cover image placeholder
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (widget.userId == null) ...[
          IconButton(
            icon: const Icon(Icons.edit, color: DesignSystem.onSurface),
            onPressed: () => _navigation.navigateTo('/profile/edit'),
          ),
        ],
        IconButton(
          icon: const Icon(Icons.settings, color: DesignSystem.onSurface),
          onPressed: () => _navigation.navigateTo('/settings'),
        ),
        if (_isOffline)
          IconButton(
            icon: const Icon(Icons.refresh, color: DesignSystem.onSurface),
            onPressed: _retryConnection,
          ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        String displayName = 'Music Lover';
        String username = '@musiclover';
        String? avatarUrl;
        int followers = 0;
        int following = 0;
        int playlists = 0;

        if (state is UserProfileLoaded) {
          displayName = state.profile.displayName ?? state.profile.username;
          username = '@${state.profile.username}';
          avatarUrl = state.profile.avatarUrl;
          // TODO: Get stats from profile when available
          followers = 1250;
          following = 340;
          playlists = 12;
        }

        return Transform.translate(
          offset: const Offset(0, -40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingLG),
            child: Column(
              children: [
                // Avatar
                MusicBudAvatar(
                  imageUrl: avatarUrl,
                  size: 100,
                  hasBorder: true,
                  borderColor: DesignSystem.pinkAccent,
                ),
                const SizedBox(height: DesignSystem.spacingMD),
                
                // Name and Username
                Text(
                  displayName,
                  style: DesignSystem.headlineMedium.copyWith(
                    color: DesignSystem.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: DesignSystem.spacingXXS),
                Text(
                  username,
                  style: DesignSystem.bodyMedium.copyWith(
                    color: DesignSystem.onSurfaceVariant,
                  ),
                ),
                
                const SizedBox(height: DesignSystem.spacingLG),
                
                // Stats Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem('Followers', followers),
                    _buildStatItem('Following', following),
                    _buildStatItem('Playlists', playlists),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: DesignSystem.headlineSmall.copyWith(
            color: DesignSystem.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: DesignSystem.bodySmall.copyWith(
            color: DesignSystem.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingLG),
      child: Row(
        children: [
          if (widget.userId == null) ...[
            // Current user - Edit Profile button
            Expanded(
              child: MusicBudButton(
                text: 'Edit Profile',
                onPressed: () => _navigation.navigateTo('/profile/edit'),
                icon: Icons.edit,
              ),
            ),
            const SizedBox(width: DesignSystem.spacingMD),
            Expanded(
              child: MusicBudButton(
                text: 'Share',
                isOutlined: true,
                onPressed: () {
                  debugPrint('Share profile');
                },
                icon: Icons.share,
              ),
            ),
          ] else ...[
            // Other user - Follow/Message buttons
            Expanded(
              child: MusicBudButton(
                text: 'Follow',
                onPressed: () {
                  debugPrint('Follow user');
                },
                icon: Icons.person_add,
              ),
            ),
            const SizedBox(width: DesignSystem.spacingMD),
            Expanded(
              child: MusicBudButton(
                text: 'Message',
                isOutlined: true,
                onPressed: () {
                  debugPrint('Message user');
                },
                icon: Icons.chat,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBioSection() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        String bio = 'Passionate about music, movies, and connecting with fellow enthusiasts. Always discovering new sounds! 🎵';
        
        if (state is UserProfileLoaded && state.profile.bio != null) {
          bio = state.profile.bio!;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingLG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About',
                style: DesignSystem.titleMedium.copyWith(
                  color: DesignSystem.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: DesignSystem.spacingSM),
              Text(
                bio,
                style: DesignSystem.bodyMedium.copyWith(
                  color: DesignSystem.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContentTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingLG),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          return Padding(
            padding: EdgeInsets.only(
              right: index < _tabs.length - 1 ? DesignSystem.spacingMD : 0,
            ),
            child: CategoryTab(
              label: _tabs[index],
              isSelected: _selectedTab == index,
              onTap: () {
                setState(() {
                  _selectedTab = index;
                  _tabController.animateTo(index);
                });
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildContentGrid() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingLG),
      sliver: BlocBuilder<ContentBloc, ContentState>(
        builder: (context, state) {
          List<Map<String, dynamic>> items = [];

          // Determine content based on selected tab
          if (_selectedTab == 0) {
            // Playlists
            if (state is ContentLoaded) {
              // TODO: Get playlists from state when available
              items = _mockPlaylists ?? [];
            } else if (_isOffline && _mockPlaylists != null) {
              items = _mockPlaylists!;
            }
          } else if (_selectedTab == 1) {
            // Liked
            if (state is ContentLoaded) {
              items = state.topTracks.take(12).map((track) => {
                'id': track.id,
                'name': track.name,
                'artist': track.artistName ?? 'Unknown Artist',
                'imageUrl': track.imageUrl,
              }).toList();
            } else if (_isOffline && _mockLikedTracks != null) {
              items = _mockLikedTracks!;
            }
          } else {
            // History
            items = _mockLikedTracks?.take(6).toList() ?? [];
          }

          if (state is ContentLoading && !_isOffline) {
            return SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: DesignSystem.spacingMD,
                mainAxisSpacing: DesignSystem.spacingMD,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildSkeletonCard(),
                childCount: 6,
              ),
            );
          }

          if (items.isEmpty) {
            return SliverToBoxAdapter(
              child: _buildEmptyState(),
            );
          }

          return SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: DesignSystem.spacingMD,
              mainAxisSpacing: DesignSystem.spacingMD,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = items[index];
                return ContentCard(
                  imageUrl: item['imageUrl'],
                  title: item['name'] ?? item['trackName'] ?? 'Unknown',
                  subtitle: item['artist'] ?? item['artistName'] ?? '',
                  width: double.infinity,
                  height: 220,
                  onTap: () {
                    debugPrint('Content tapped: ${item['name']}');
                  },
                );
              },
              childCount: items.length,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      decoration: BoxDecoration(
        color: DesignSystem.surfaceContainer,
        borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(DesignSystem.spacingLG),
      decoration: BoxDecoration(
        color: DesignSystem.surfaceContainer,
        borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.music_note,
              size: 48,
              color: DesignSystem.onSurfaceVariant,
            ),
            const SizedBox(height: DesignSystem.spacingSM),
            Text(
              'No content yet',
              style: DesignSystem.bodyMedium.copyWith(
                color: DesignSystem.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _retryConnection() {
    setState(() {
      _isOffline = false;
      _hasTriggeredInitialLoad = false;
    });
    _triggerInitialDataLoad();
  }
}
