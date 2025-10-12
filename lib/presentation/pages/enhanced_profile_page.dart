import 'package:flutter/material.dart';
import '../../core/design_system/design_system.dart';

class EnhancedProfilePage extends StatefulWidget {
  const EnhancedProfilePage({super.key});

  @override
  State<EnhancedProfilePage> createState() => _EnhancedProfilePageState();
}

class _EnhancedProfilePageState extends State<EnhancedProfilePage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MusicBudColors.backgroundPrimary,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildProfileHeader(),
          _buildTabBar(),
          _buildTabContent(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 100,
      floating: false,
      pinned: true,
      backgroundColor: MusicBudColors.backgroundPrimary.withOpacity(0.95),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          color: MusicBudColors.textPrimary,
          onPressed: () {
            // Navigate to settings
          },
        ),
        IconButton(
          icon: const Icon(Icons.share_outlined),
          color: MusicBudColors.textPrimary,
          onPressed: () {
            // Share profile
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Profile',
          style: MusicBudTypography.heading4.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(MusicBudSpacing.lg),
        child: Column(
          children: [
            // Profile Avatar and Info
            Row(
              children: [
                // Using placeholder as we reference the UI assets
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(MusicBudSpacing.radiusXl),
                    gradient: const LinearGradient(
                      colors: [
                        MusicBudColors.primaryRed,
                        MusicBudColors.primaryDark,
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: MusicBudSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alex Johnson',
                        style: MusicBudTypography.heading4.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '@alexmusic',
                        style: MusicBudTypography.bodyMedium.copyWith(
                          color: MusicBudColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '🎵 Music enthusiast | Pop & Rock lover | Looking for concert buddies',
                        style: MusicBudTypography.bodySmall.copyWith(
                          color: MusicBudColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: MusicBudSpacing.lg),
            
            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('125', 'Matches'),
                _buildStatItem('48', 'Events'),
                _buildStatItem('1.2K', 'Followers'),
                _buildStatItem('892', 'Following'),
              ],
            ),
            
            const SizedBox(height: MusicBudSpacing.lg),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      // Edit profile
                    },
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit Profile'),
                  ),
                ),
                const SizedBox(width: MusicBudSpacing.md),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // View insights
                    },
                    icon: const Icon(Icons.analytics_outlined),
                    label: const Text('Insights'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: MusicBudTypography.heading5.copyWith(
            fontWeight: FontWeight.w700,
            color: MusicBudColors.primaryRed,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: MusicBudTypography.bodySmall.copyWith(
            color: MusicBudColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: MusicBudSpacing.lg,
          vertical: MusicBudSpacing.md,
        ),
        decoration: BoxDecoration(
          color: MusicBudColors.backgroundTertiary,
          borderRadius: BorderRadius.circular(MusicBudSpacing.radiusLg),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: MusicBudColors.primaryRed,
            borderRadius: BorderRadius.circular(MusicBudSpacing.radiusLg),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelStyle: MusicBudTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: MusicBudTypography.bodyMedium,
          tabs: const [
            Tab(text: 'Music'),
            Tab(text: 'Events'),
            Tab(text: 'Photos'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return SliverFillRemaining(
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildMusicTab(),
          _buildEventsTab(),
          _buildPhotosTab(),
        ],
      ),
    );
  }

  Widget _buildMusicTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(MusicBudSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Artists',
            style: MusicBudTypography.heading5.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: MusicBudSpacing.md),
          _buildTopArtistsGrid(),
          
          const SizedBox(height: MusicBudSpacing.xl),
          
          Text(
            'Recently Played',
            style: MusicBudTypography.heading5.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: MusicBudSpacing.md),
          _buildRecentlyPlayedList(),
        ],
      ),
    );
  }

  Widget _buildTopArtistsGrid() {
    final artists = ['Taylor Swift', 'Ed Sheeran', 'Billie Eilish', 'The Weeknd'];
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: MusicBudSpacing.md,
        mainAxisSpacing: MusicBudSpacing.md,
      ),
      itemCount: artists.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: MusicBudColors.backgroundTertiary,
            borderRadius: BorderRadius.circular(MusicBudSpacing.radiusLg),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: MusicBudColors.primaryRed.withOpacity(0.2),
                child: const Icon(
                  Icons.person_rounded,
                  size: 30,
                  color: MusicBudColors.primaryRed,
                ),
              ),
              const SizedBox(height: MusicBudSpacing.sm),
              Text(
                artists[index],
                style: MusicBudTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecentlyPlayedList() {
    final tracks = [
      {'title': 'Anti-Hero', 'artist': 'Taylor Swift'},
      {'title': 'Shape of You', 'artist': 'Ed Sheeran'},
      {'title': 'Bad Guy', 'artist': 'Billie Eilish'},
      {'title': 'Blinding Lights', 'artist': 'The Weeknd'},
    ];

    return Column(
      children: tracks.map((track) => Container(
        margin: const EdgeInsets.only(bottom: MusicBudSpacing.sm),
        padding: const EdgeInsets.all(MusicBudSpacing.md),
        decoration: BoxDecoration(
          color: MusicBudColors.backgroundTertiary,
          borderRadius: BorderRadius.circular(MusicBudSpacing.radiusLg),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(MusicBudSpacing.radiusMd),
                color: MusicBudColors.primaryRed.withOpacity(0.1),
              ),
              child: const Icon(
                Icons.music_note_rounded,
                color: MusicBudColors.primaryRed,
              ),
            ),
            const SizedBox(width: MusicBudSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track['title']!,
                    style: MusicBudTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    track['artist']!,
                    style: MusicBudTypography.bodySmall.copyWith(
                      color: MusicBudColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.favorite_border_rounded,
                color: MusicBudColors.textSecondary,
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildEventsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.event_outlined,
            size: 64,
            color: MusicBudColors.textSecondary,
          ),
          const SizedBox(height: MusicBudSpacing.lg),
          Text(
            'No Events Yet',
            style: MusicBudTypography.heading5.copyWith(
              color: MusicBudColors.textSecondary,
            ),
          ),
          const SizedBox(height: MusicBudSpacing.sm),
          Text(
            'Events you create or attend will appear here',
            style: MusicBudTypography.bodyMedium.copyWith(
              color: MusicBudColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.photo_library_outlined,
            size: 64,
            color: MusicBudColors.textSecondary,
          ),
          const SizedBox(height: MusicBudSpacing.lg),
          Text(
            'No Photos Yet',
            style: MusicBudTypography.heading5.copyWith(
              color: MusicBudColors.textSecondary,
            ),
          ),
          const SizedBox(height: MusicBudSpacing.sm),
          Text(
            'Photos from events and concerts will appear here',
            style: MusicBudTypography.bodyMedium.copyWith(
              color: MusicBudColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}