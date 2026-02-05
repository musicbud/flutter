import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';
import '../../../core/components/musicbud_components.dart';

/// Home Screen matching Figma Design
/// Features: Hero card, category tabs, content carousels, avatars with stories
class FigmaHomeScreen extends StatefulWidget {
  const FigmaHomeScreen({super.key});

  @override
  State<FigmaHomeScreen> createState() => _FigmaHomeScreenState();
}

class _FigmaHomeScreenState extends State<FigmaHomeScreen> {
  int _selectedCategory = 0;
  final List<String> _categories = ['Music', 'Movies', 'Anime'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignSystem.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header with profile and notifications
            SliverToBoxAdapter(
              child: _buildHeader(),
            ),

            // Stories / Active buds
            SliverToBoxAdapter(
              child: _buildStoriesSection(),
            ),

            // Hero Card Section
            SliverToBoxAdapter(
              child: HeroCard(
                imageUrl: null,
                title: 'Discover New Music',
                subtitle: 'Trending this week',
                onPlayTap: () {
                  // TODO: Handle play action
                  debugPrint('Play tapped');
                },
                onSaveTap: () {
                  // TODO: Handle save action
                  debugPrint('Save tapped');
                },
              ),
            ),

            const SizedBox(height: DesignSystem.spacingLG),

            // Category Tabs
            SliverToBoxAdapter(
              child: _buildCategoryTabs(),
            ),

            const SizedBox(height: DesignSystem.spacingLG),

            // Trending Section
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Trending Now',
                onSeeAllTap: () {
                  // TODO: Navigate to trending page
                },
              ),
            ),

            SliverToBoxAdapter(
              child: _buildTrendingCarousel(),
            ),

            const SizedBox(height: DesignSystem.spacingXL),

            // For You Section
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'For You',
                onSeeAllTap: () {
                  // TODO: Navigate to recommendations page
                },
              ),
            ),

            SliverToBoxAdapter(
              child: _buildForYouCarousel(),
            ),

            const SizedBox(height: DesignSystem.spacingXL),

            // New Releases Section
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'New Releases',
                onSeeAllTap: () {
                  // TODO: Navigate to new releases page
                },
              ),
            ),

            SliverToBoxAdapter(
              child: _buildNewReleasesCarousel(),
            ),

            const SizedBox(height: DesignSystem.spacingXL),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(DesignSystem.spacingMD),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Profile Avatar
          MusicBudAvatar(
            imageUrl: null,
            size: 44,
            hasBorder: true,
            onTap: () {
              // TODO: Navigate to profile
              debugPrint('Profile tapped');
            },
          ),
          // App Title
          Text(
            'MusicBud',
            style: DesignSystem.headlineMedium.copyWith(
              color: DesignSystem.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Notifications
          IconButton(
            onPressed: () {
              // TODO: Navigate to notifications
              debugPrint('Notifications tapped');
            },
            icon: Stack(
              children: [
                const Icon(
                  Icons.notifications_outlined,
                  color: DesignSystem.onSurface,
                  size: 28,
                ),
                // Notification badge
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: DesignSystem.pinkAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesSection() {
    return Container(
      height: 90,
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
                  index == 0 ? 'You' : 'User $index',
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
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTrendingCarousel() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingMD),
        itemCount: 10,
        itemBuilder: (context, index) {
          return ContentCard(
            imageUrl: null,
            title: 'Trending Track ${index + 1}',
            subtitle: 'Artist Name',
            width: 120,
            height: 180,
            onTap: () {
              debugPrint('Content $index tapped');
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
  }

  Widget _buildForYouCarousel() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingMD),
        itemCount: 10,
        itemBuilder: (context, index) {
          return ContentCard(
            imageUrl: null,
            title: 'Recommended ${index + 1}',
            subtitle: 'Based on your taste',
            width: 120,
            height: 180,
            onTap: () {
              debugPrint('Recommendation $index tapped');
            },
          );
        },
      ),
    );
  }

  Widget _buildNewReleasesCarousel() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingMD),
        itemCount: 10,
        itemBuilder: (context, index) {
          return ContentCard(
            imageUrl: null,
            title: 'New Release ${index + 1}',
            subtitle: 'Just released',
            width: 140,
            height: 180,
            onTap: () {
              debugPrint('New release $index tapped');
            },
            tag: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              decoration: BoxDecoration(
              color: DesignSystem.successGreen,
                borderRadius: BorderRadius.circular(DesignSystem.radiusSM),
              ),
              child: Text(
                'NEW',
                style: DesignSystem.labelSmall.copyWith(
                  color: DesignSystem.background,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

