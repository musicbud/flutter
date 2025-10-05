import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/library_item.dart';
import '../../blocs/library/library_bloc.dart';
import '../../blocs/library/library_event.dart';
import '../../blocs/library/library_state.dart';
import '../widgets/common/index.dart';
import '../theme/app_theme.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedTab = 'Playlists';
  int _selectedIndex = 0;

  final List<String> _tabs = [
    'Playlists',
    'Liked Songs',
    'Downloads',
    'Recently Played',
  ];

  @override
  void initState() {
    super.initState();
    // Load initial playlists
    context.read<LibraryBloc>().add(const LibraryItemsRequested(type: 'playlists'));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onTabChanged(String tab) {
    setState(() {
      _selectedTab = tab;
      _selectedIndex = _tabs.indexOf(tab);
    });

    // Load items for selected tab
    String type = tab.toLowerCase().replaceAll(' ', '_');
    context.read<LibraryBloc>().add(LibraryItemsRequested(
      type: type,
      query: _searchController.text.isNotEmpty ? _searchController.text : null,
    ));
  }

  void _onSearch(String query) {
    String type = _selectedTab.toLowerCase().replaceAll(' ', '_');
    context.read<LibraryBloc>().add(LibraryItemsRequested(
      type: type,
      query: query.isNotEmpty ? query : null,
    ));
  }

  void _onCreatePlaylist() {
    final appTheme = AppTheme.of(context);
    final nameController = TextEditingController();
    final descController = TextEditingController();
    bool isPrivate = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            'Create Playlist',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ModernInputField(
                controller: nameController,
                hintText: 'Playlist Name',
              ),
              SizedBox(height: appTheme.spacing.md),
              ModernInputField(
                controller: descController,
                hintText: 'Description (optional)',
                maxLines: 3,
              ),
              SizedBox(height: appTheme.spacing.md),
              CheckboxListTile(
                title: Text(
                  'Private Playlist',
                  style: appTheme.typography.bodyMedium,
                ),
                value: isPrivate,
                onChanged: (value) {
                  setState(() {
                    isPrivate = value ?? false;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            PrimaryButton(
              text: 'Create',
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  context.read<LibraryBloc>().add(LibraryPlaylistCreated(
                    name: nameController.text,
                    description: descController.text,
                    isPrivate: isPrivate,
                  ));
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: appTheme.gradients.backgroundGradient,
      ),
      child: BlocConsumer<LibraryBloc, LibraryState>(
        listener: (context, state) {
          if (state is LibraryActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is LibraryActionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: const Color(0xFFCF6679),
              ),
            );
          }
        },
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              // Header Section
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Library',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Your personal music collection',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0x80FFFFFF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

          // Search Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ModernInputField(
                hintText: 'Search your library...',
                controller: _searchController,
                onChanged: _onSearch,
                size: ModernInputFieldSize.large,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: const SizedBox(height: 24),
          ),

          // Create Playlist Button (only show in Playlists tab)
          if (_selectedTab == 'Playlists')
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: PrimaryButton(
                  text: 'Create New Playlist',
                  onPressed: _onCreatePlaylist,
                  icon: Icons.add,
                  size: ModernButtonSize.large,
                ),
              ),
            ),

          SliverToBoxAdapter(
            child: const SizedBox(height: 24),
          ),

          // Library Items Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state is LibraryLoaded) ...[
                    Text(
                      '${state.totalCount} $_selectedTab',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: const Color(0xB3FFFFFF),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return _buildLibraryItem(item, appTheme);
                      },
                    ),
                  ] else if (state is LibraryLoading) ...[
                    const Center(child: CircularProgressIndicator()),
                  ] else if (state is LibraryError) ...[
                    Center(
                      child: Text(
                        'Error: ${state.message}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFFCF6679),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Tabs Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _tabs.length,
                  itemBuilder: (context, index) {
                    final tab = _tabs[index];
                    final isSelected = index == _selectedIndex;

                    return Container(
                      margin: EdgeInsets.only(
                        right: index < _tabs.length - 1 ? 16 : 0,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                            _selectedTab = tab;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFCF6679)
                                : const Color(0xFF282828),
                            borderRadius: BorderRadius.circular(appTheme.radius.circular),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFCF6679)
                                  : const Color(0xFF3E3E3E),
                              width: 1.5,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                          ),
                          child: Center(
                            child: Text(
                              tab,
                              style: appTheme.typography.bodySmall?.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xB3FFFFFF),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: const SizedBox(height: 32),
          ),

          // Content based on selected tab
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildTabContent(appTheme),
            ),
          ),

          SliverToBoxAdapter(
            child: const SizedBox(height: 32),
          ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabContent(dynamic appTheme) {
    switch (_selectedTab) {
      case 'Playlists':
        return _buildPlaylistsContent(appTheme);
      case 'Liked Songs':
        return _buildLikedSongsContent(appTheme);
      case 'Downloads':
        return _buildDownloadsContent(appTheme);
      case 'Recently Played':
        return _buildRecentlyPlayedContent(appTheme);
      default:
        return _buildPlaylistsContent(appTheme);
    }
  }

  Widget _buildPlaylistsContent(dynamic appTheme) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, state) {
        if (state is LibraryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is LibraryLoaded && state.items.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Playlists',
                    style: appTheme.typography.headlineH7.copyWith(
                      color: appTheme.colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  PrimaryButton(
                    text: 'Create New',
                    onPressed: _onCreatePlaylist,
                    icon: Icons.add,
                    size: ModernButtonSize.small,
                  ),
                ],
              ),
              SizedBox(height: appTheme.spacing.md),

              // Playlists Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: appTheme.spacing.md,
                  mainAxisSpacing: appTheme.spacing.md,
                  childAspectRatio: 0.8,
                ),
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return _buildPlaylistCard(
                    item.title,
                    item.description ?? '0 tracks',
                    item.imageUrl ?? 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=300&fit=crop',
                    appTheme.colors.accentBlue,
                    appTheme,
                  );
                },
              ),
            ],
          );
        }

        // Show empty state or fallback
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Playlists',
                  style: appTheme.typography.headlineH7.copyWith(
                    color: appTheme.colors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                PrimaryButton(
                  text: 'Create New',
                  onPressed: _onCreatePlaylist,
                  icon: Icons.add,
                  size: ModernButtonSize.small,
                ),
              ],
            ),
            SizedBox(height: appTheme.spacing.md),
            Center(
              child: Padding(
                padding: EdgeInsets.all(appTheme.spacing.xl),
                child: Column(
                  children: [
                    Icon(
                      Icons.queue_music,
                      size: 64,
                      color: appTheme.colors.textMuted,
                    ),
                    SizedBox(height: appTheme.spacing.md),
                    Text(
                      'No playlists yet',
                      style: appTheme.typography.headlineH6.copyWith(
                        color: appTheme.colors.textSecondary,
                      ),
                    ),
                    SizedBox(height: appTheme.spacing.sm),
                    Text(
                      'Create your first playlist to get started',
                      style: appTheme.typography.bodyMedium.copyWith(
                        color: appTheme.colors.textMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLikedSongsContent(dynamic appTheme) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, state) {
        if (state is LibraryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is LibraryLoaded && state.items.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Liked Songs',
                style: appTheme.typography.headlineH7.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: appTheme.spacing.md),

              // Liked Songs List
              Column(
                children: state.items.map((item) {
                  return Column(
                    children: [
                      _buildLikedSongCard(
                        item.title,
                        item.description ?? 'Unknown Artist',
                        'Liked', // Could be enhanced to show genre
                        item.imageUrl ?? 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=100&h=100&fit=crop',
                        appTheme.colors.accentBlue,
                        appTheme,
                      ),
                      SizedBox(height: appTheme.spacing.md),
                    ],
                  );
                }).toList(),
              ),
            ],
          );
        }

        // Empty state
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Liked Songs',
              style: appTheme.typography.headlineH7.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: appTheme.spacing.md),
            Center(
              child: Padding(
                padding: EdgeInsets.all(appTheme.spacing.xl),
                child: Column(
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: appTheme.colors.textMuted,
                    ),
                    SizedBox(height: appTheme.spacing.md),
                    Text(
                      'No liked songs yet',
                      style: appTheme.typography.headlineH6.copyWith(
                        color: appTheme.colors.textSecondary,
                      ),
                    ),
                    SizedBox(height: appTheme.spacing.sm),
                    Text(
                      'Songs you like will appear here',
                      style: appTheme.typography.bodyMedium.copyWith(
                        color: appTheme.colors.textMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDownloadsContent(dynamic appTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Downloaded Music',
          style: appTheme.typography.headlineH7.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: appTheme.spacing.md),

        // Downloads Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: appTheme.spacing.md,
            mainAxisSpacing: appTheme.spacing.md,
            childAspectRatio: 0.8,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return _buildDownloadCard(
              'Album ${index + 1}',
              'Artist ${index + 1}',
              '${(index + 1) * 8} tracks',
              'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=300&fit=crop',
              appTheme.colors.accentOrange,
              appTheme,
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentlyPlayedContent(dynamic appTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recently Played',
          style: appTheme.typography.headlineH7.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: appTheme.spacing.md),

        // Recently Played List
        Column(
          children: [
            _buildRecentlyPlayedCard(
              'Electric Storm',
              'Luna Echo',
              '2 hours ago',
              'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=100&h=100&fit=crop',
              appTheme.colors.primaryRed,
              appTheme,
            ),
            SizedBox(height: appTheme.spacing.md),
            _buildRecentlyPlayedCard(
              'Chill Vibes',
              'Coastal Vibes',
              '1 day ago',
              'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=100&h=100&fit=crop',
              appTheme.colors.accentBlue,
              appTheme,
            ),
            const SizedBox(height: 16),
            _buildRecentlyPlayedCard(
              'Urban Flow',
              'City Pulse',
              '3 days ago',
              'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=100&h=100&fit=crop',
              appTheme.colors.accentPurple,
              appTheme,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlaylistCard(
    String title,
    String trackCount,
    String imageUrl,
    Color accentColor,
    dynamic appTheme,
  ) {
    return ModernCard(
      variant: ModernCardVariant.primary,
      onTap: () {
        // Navigate to playlist
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Playlist Image
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(appTheme.radius.lg),
              color: accentColor.withValues(alpha: 0.1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(appTheme.radius.lg),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.playlist_play,
                    color: accentColor,
                    size: 48,
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Playlist Info
          Text(
            title,
            style: appTheme.typography.titleSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: appTheme.spacing.xs),
          Text(
            trackCount,
            style: appTheme.typography.caption.copyWith(
              color: const Color(0x80FFFFFF),
            ),
          ),
          SizedBox(height: appTheme.spacing.md),

          // Action Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(appTheme.spacing.sm),
                decoration: BoxDecoration(
                  color: appTheme.colors.primaryRed,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: appTheme.colors.white,
                  size: 20,
                ),
              ),
              Icon(
                Icons.more_vert,
                color: const Color(0x80FFFFFF),
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLikedSongCard(
    String title,
    String artist,
    String genre,
    String imageUrl,
    Color accentColor,
    dynamic appTheme,
  ) {
    return ModernCard(
      variant: ModernCardVariant.primary,
      onTap: () {
        // Navigate to song
      },
      child: Row(
        children: [
          // Song Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(appTheme.radius.md),
              color: accentColor.withValues(alpha: 0.1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(appTheme.radius.md),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.music_note,
                    color: accentColor,
                    size: 30,
                  );
                },
              ),
            ),
          ),

          SizedBox(width: appTheme.spacing.md),

          // Song Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: appTheme.typography.titleSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: appTheme.spacing.xs),
                Text(
                  artist,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xB3FFFFFF),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: appTheme.spacing.sm,
                    vertical: appTheme.spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(appTheme.radius.sm),
                  ),
                  child: Text(
                    genre,
                    style: appTheme.typography.caption.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(appTheme.spacing.sm),
                decoration: BoxDecoration(
                  color: appTheme.colors.primaryRed,
                  borderRadius: BorderRadius.circular(appTheme.radius.circular),
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: appTheme.colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: appTheme.spacing.sm),
              Icon(
                Icons.favorite,
                color: appTheme.colors.primaryRed,
                size: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadCard(
    String title,
    String artist,
    String trackCount,
    String imageUrl,
    Color accentColor,
    dynamic appTheme,
  ) {
    return ModernCard(
      variant: ModernCardVariant.primary,
      onTap: () {
        // Navigate to album
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Album Image
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(appTheme.radius.lg),
              color: accentColor.withValues(alpha: 0.1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(appTheme.radius.lg),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.album,
                    color: accentColor,
                    size: 48,
                  );
                },
              ),
            ),
          ),

          SizedBox(height: appTheme.spacing.md),

          // Album Info
          Text(
            title,
            style: appTheme.typography.titleSmall.copyWith(
              color: appTheme.colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: appTheme.spacing.xs),
          Text(
            artist,
            style: appTheme.typography.bodySmall?.copyWith(
              color: const Color(0xB3FFFFFF),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            trackCount,
            style: appTheme.typography.caption.copyWith(
              color: appTheme.colors.textMuted,
            ),
          ),
          SizedBox(height: appTheme.spacing.md),

          // Action Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(appTheme.spacing.sm),
                decoration: BoxDecoration(
                  color: appTheme.colors.primaryRed,
                  borderRadius: BorderRadius.circular(appTheme.radius.circular),
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: appTheme.colors.white,
                  size: 20,
                ),
              ),
              Icon(
                Icons.download_done,
                color: appTheme.colors.accentGreen,
                size: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentlyPlayedCard(
    String title,
    String artist,
    String timeAgo,
    String imageUrl,
    Color accentColor,
    dynamic appTheme,
  ) {
    return ModernCard(
      variant: ModernCardVariant.primary,
      onTap: () {
        // Navigate to song
      },
      child: Row(
        children: [
          // Song Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(appTheme.radius.md),
              color: accentColor.withValues(alpha: 0.1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(appTheme.radius.md),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.music_note,
                    color: accentColor,
                    size: 30,
                  );
                },
              ),
            ),
          ),

          SizedBox(width: appTheme.spacing.md),

          // Song Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: appTheme.typography.titleSmall.copyWith(
                    color: appTheme.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: appTheme.spacing.xs),
                Text(
                  artist,
                  style: appTheme.typography.bodySmall.copyWith(
                    color: appTheme.colors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  timeAgo,
                  style: appTheme.typography.caption.copyWith(
                    color: appTheme.colors.textMuted,
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(appTheme.spacing.sm),
                decoration: BoxDecoration(
                  color: appTheme.colors.primaryRed,
                  borderRadius: BorderRadius.circular(appTheme.radius.circular),
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: appTheme.colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: appTheme.spacing.sm),
              Icon(
                Icons.history,
                color: appTheme.colors.textMuted,
                size: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLibraryItem(LibraryItem item, dynamic appTheme) {
    return ModernCard(
      variant: ModernCardVariant.secondary,
      margin: EdgeInsets.only(bottom: appTheme.spacing.md),
      child: ListTile(
        leading: item.imageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(appTheme.radius.sm),
                child: Image.network(
                  item.imageUrl!,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: appTheme.colors.surfaceVariant,
                        borderRadius: BorderRadius.circular(appTheme.radius.sm),
                      ),
                      child: Icon(
                        _getItemIcon(item.type),
                        color: appTheme.colors.textSecondary,
                      ),
                    );
                  },
                ),
              )
            : Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: appTheme.colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(appTheme.radius.sm),
                ),
                child: Icon(
                  _getItemIcon(item.type),
                  color: appTheme.colors.textSecondary,
                ),
              ),
        title: Text(
          item.title,
          style: appTheme.typography.titleMedium.copyWith(
            color: appTheme.colors.textPrimary,
          ),
        ),
        subtitle: item.description != null
            ? Text(
                item.description!,
                style: appTheme.typography.bodySmall.copyWith(
                  color: appTheme.colors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.type == 'song') ...[
              IconButton(
                icon: Icon(
                  item.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: item.isLiked ? appTheme.colors.primaryRed : appTheme.colors.textSecondary,
                ),
                onPressed: () {
                  context.read<LibraryBloc>().add(LibraryItemToggleLiked(
                    itemId: item.id,
                    type: item.type,
                  ));
                },
              ),
              IconButton(
                icon: Icon(
                  item.isDownloaded ? Icons.download_done : Icons.download_outlined,
                  color: item.isDownloaded ? appTheme.colors.primary : appTheme.colors.textSecondary,
                ),
                onPressed: () {
                  context.read<LibraryBloc>().add(LibraryItemToggleDownload(
                    itemId: item.id,
                    type: item.type,
                  ));
                },
              ),
            ],
            if (item.type == 'playlist' && !item.id.startsWith('system_')) ...[
              IconButton(
                icon: Icon(Icons.more_vert, color: appTheme.colors.textSecondary),
                onPressed: () => _showPlaylistOptions(item),
              ),
            ],
          ],
        ),
        onTap: () {
          context.read<LibraryBloc>().add(LibraryItemPlayRequested(
            itemId: item.id,
            type: item.type,
          ));
        },
      ),
    );
  }

  IconData _getItemIcon(String type) {
    switch (type) {
      case 'playlist':
        return Icons.queue_music;
      case 'song':
        return Icons.music_note;
      case 'album':
        return Icons.album;
      case 'artist':
        return Icons.person;
      default:
        return Icons.library_music;
    }
  }

  void _showPlaylistOptions(LibraryItem playlist) {
    final appTheme = AppTheme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF282828),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Playlist'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement edit playlist
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Playlist'),
              onTap: () {
                Navigator.pop(context);
                _confirmDeletePlaylist(playlist);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeletePlaylist(LibraryItem playlist) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Playlist'),
        content: Text('Are you sure you want to delete "${playlist.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<LibraryBloc>().add(LibraryPlaylistDeleted(
                playlistId: playlist.id,
              ));
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}