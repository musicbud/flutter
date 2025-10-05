import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/user_profile/user_profile_bloc.dart';
import '../constants/app_theme.dart';
import '../widgets/common/index.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load user profile and dynamic content
    context.read<UserProfileBloc>().add(FetchMyProfile());
    context.read<UserProfileBloc>().add(FetchMyLikedContent(contentType: 'tracks'));
    context.read<UserProfileBloc>().add(FetchMyTopContent(contentType: 'artists'));
    context.read<UserProfileBloc>().add(FetchMyPlayedTracks());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return BlocListener<UserProfileBloc, UserProfileState>(
      listener: (context, state) {
        if (state is UserProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: appTheme.colors.errorRed,
            ),
          );
        }
      },
      child: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              gradient: appTheme.gradients.backgroundGradient,
            ),
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  // Header Section
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.all(appTheme.spacing.lg),
                      child: Row(
                        children: [
                          // Profile Avatar
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(appTheme.radius.circular),
                              boxShadow: appTheme.shadows.shadowCard,
                              border: Border.all(
                                color: appTheme.colors.primaryRed.withValues(alpha: 0.3),
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 28,
                              backgroundColor: appTheme.colors.primaryRed,
                              backgroundImage: state is UserProfileLoaded && state.userProfile.avatarUrl != null
                                  ? NetworkImage(state.userProfile.avatarUrl!)
                                  : null,
                              child: state is UserProfileLoaded && state.userProfile.avatarUrl == null
                                  ? Icon(
                                      Icons.person,
                                      color: appTheme.colors.white,
                                      size: 28,
                                    )
                                  : null,
                            ),
                          ),
                          SizedBox(width: appTheme.spacing.md),
                          // Welcome Text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome back!',
                                  style: appTheme.typography.bodySmall.copyWith(
                                    color: appTheme.colors.textMuted,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: appTheme.spacing.xs),
                                Text(
                                  state is UserProfileLoaded
                                      ? (state.userProfile.displayName ?? state.userProfile.username)
                                      : 'Loading...',
                                  style: appTheme.typography.headlineH6.copyWith(
                                    color: appTheme.colors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Notification Icon
                          Container(
                            padding: EdgeInsets.all(appTheme.spacing.sm),
                            decoration: BoxDecoration(
                              color: appTheme.colors.surfaceDark,
                              borderRadius: BorderRadius.circular(appTheme.radius.md),
                              boxShadow: appTheme.shadows.shadowSmall,
                            ),
                            child: Icon(
                              Icons.notifications_outlined,
                              color: appTheme.colors.textSecondary,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Search Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                      child: ModernInputField(
                        hintText: 'Search for music, artists, or playlists...',
                        controller: _searchController,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            // Navigate to search page with query
                            Navigator.pushNamed(
                              context,
                              '/search',
                              arguments: {'query': value},
                            );
                          }
                        },
                        size: ModernInputFieldSize.large,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: appTheme.spacing.lg),
                  ),
                  // Action Buttons Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                      child: Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              text: 'Discover',
                              onPressed: () {
                                Navigator.pushNamed(context, '/discover');
                              },
                              icon: Icons.explore,
                              size: ModernButtonSize.large,
                              isFullWidth: true,
                            ),
                          ),
                          SizedBox(width: appTheme.spacing.md),
                          Expanded(
                            child: SecondaryButton(
                              text: 'My Library',
                              onPressed: () {
                                Navigator.pushNamed(context, '/library');
                              },
                              icon: Icons.library_music,
                              size: ModernButtonSize.large,
                              isFullWidth: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: appTheme.spacing.xl),
                  ),

                  // Dynamic Content Sections
                  _buildDynamicContentSections(appTheme),

                  SliverToBoxAdapter(
                    child: SizedBox(height: appTheme.spacing.xl),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDynamicContentSections(dynamic appTheme) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, state) {
        if (state is MyContentLoaded) {
          return SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.contentType == 'tracks' && state.content.isNotEmpty) ...[
                  _buildContentSection(
                    'Your Liked Songs',
                    state.content.take(5).toList(),
                    appTheme,
                    'liked_songs',
                  ),
                  SizedBox(height: appTheme.spacing.xl),
                ],
                if (state.contentType == 'artists' && state.content.isNotEmpty) ...[
                  _buildContentSection(
                    'Your Top Artists',
                    state.content.take(5).toList(),
                    appTheme,
                    'top_artists',
                  ),
                  SizedBox(height: appTheme.spacing.xl),
                ],
                if (state.contentType == 'played_tracks' && state.content.isNotEmpty) ...[
                  _buildContentSection(
                    'Recently Played',
                    state.content.take(5).toList(),
                    appTheme,
                    'recently_played',
                  ),
                  SizedBox(height: appTheme.spacing.xl),
                ],
              ],
            ),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }

  Widget _buildContentSection(String title, List<dynamic> items, dynamic appTheme, String sectionType) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: appTheme.typography.headlineH6.copyWith(
                  color: appTheme.colors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to full list
                  Navigator.pushNamed(context, '/library', arguments: {'tab': sectionType});
                },
                child: Text(
                  'See All',
                  style: appTheme.typography.bodySmall.copyWith(
                    color: appTheme.colors.primaryRed,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: appTheme.spacing.md),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildContentItem(item, appTheme, sectionType);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentItem(dynamic item, dynamic appTheme, String sectionType) {
    String title = '';
    String subtitle = '';
    String imageUrl = '';

    // Extract data based on item type
    if (item is Map<String, dynamic>) {
      title = item['name'] ?? item['title'] ?? 'Unknown';
      subtitle = item['artistName'] ?? item['artist'] ?? '';
      imageUrl = item['albumImageUrl'] ?? item['imageUrl'] ?? '';
    }

    return Container(
      width: 100,
      margin: EdgeInsets.only(right: appTheme.spacing.md),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(appTheme.radius.md),
              image: imageUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
              color: appTheme.colors.surfaceDark,
            ),
            child: imageUrl.isEmpty
                ? Icon(
                    sectionType == 'liked_songs' ? Icons.music_note :
                    sectionType == 'top_artists' ? Icons.person :
                    Icons.history,
                    color: appTheme.colors.textSecondary,
                    size: 30,
                  )
                : null,
          ),
          SizedBox(height: appTheme.spacing.sm),
          Text(
            title,
            style: appTheme.typography.caption.copyWith(
              color: appTheme.colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          if (subtitle.isNotEmpty) ...[
            SizedBox(height: appTheme.spacing.xs),
            Text(
              subtitle,
              style: appTheme.typography.caption.copyWith(
                color: appTheme.colors.textMuted,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
