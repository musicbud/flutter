import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../widgets/common/index.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 2; // Library tab

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: appTheme.colors.background,
      appBar: AppBar(
        backgroundColor: appTheme.colors.white,
        elevation: 0,
        title: Text(
          'My Library',
          style: appTheme.typography.headlineH6.copyWith(
            color: appTheme.colors.neutral[900],
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: appTheme.colors.primary),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.search, color: appTheme.colors.neutral[700]),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: appTheme.colors.primary,
          unselectedLabelColor: appTheme.colors.neutral[600],
          indicatorColor: appTheme.colors.primary,
          tabs: [
            Tab(text: 'Playlists'),
            Tab(text: 'Tracks'),
            Tab(text: 'Albums'),
            Tab(text: 'Artists'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPlaylistsTab(),
          _buildTracksTab(),
          _buildAlbumsTab(),
          _buildArtistsTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: appTheme.colors.white,
        selectedItemColor: appTheme.colors.primary,
        unselectedItemColor: appTheme.colors.neutral[400],
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistsTab() {
    final appTheme = AppTheme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(appTheme.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Actions
          Row(
            children: [
              Expanded(
                child: AppButtons.primary(
                  text: 'Create Playlist',
                  onPressed: () {},
                  icon: Icons.add,
                ),
              ),
              SizedBox(width: appTheme.spacing.md),
              Expanded(
                child: AppButtons.secondary(
                  text: 'Import',
                  onPressed: () {},
                  icon: Icons.file_upload,
                ),
              ),
            ],
          ),

          SizedBox(height: appTheme.spacing.xl),

          // Featured Playlists
          Text(
            'Featured Playlists',
            style: appTheme.typography.headlineH6.copyWith(
              color: appTheme.colors.neutral[900],
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: appTheme.spacing.md),

          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 160,
                  margin: EdgeInsets.only(right: appTheme.spacing.md),
                  child: AppCards.musicTrack(
                    title: 'Featured Playlist ${index + 1}',
                    artist: 'Various Artists',
                    album: 'Playlist Collection',
                    imageUrl: 'https://via.placeholder.com/160x120',
                    duration: '${20 + index * 5} tracks',
                    onTap: () {},
                  ),
                );
              },
            ),
          ),

          SizedBox(height: appTheme.spacing.xl),

          // My Playlists
          Text(
            'My Playlists',
            style: appTheme.typography.headlineH6.copyWith(
              color: appTheme.colors.neutral[900],
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: appTheme.spacing.md),

          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 8,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: appTheme.spacing.md),
                child: AppCards.profile(
                  name: 'My Playlist ${index + 1}',
                  role: '${15 + index * 3} tracks • Created ${index + 1} days ago',
                  imageUrl: 'https://via.placeholder.com/50x50',
                  onTap: () {},
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTracksTab() {
    final appTheme = AppTheme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(appTheme.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Track Stats
          AppCards.defaultCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Total Tracks', '1,247'),
                _buildStatItem('Liked', '89'),
                _buildStatItem('Downloaded', '156'),
              ],
            ),
          ),

          SizedBox(height: appTheme.spacing.lg),

          // Sort Options
          Row(
            children: [
              Expanded(
                child: AppButtons.secondary(
                  text: 'Sort by',
                  onPressed: () {},
                  icon: Icons.sort,
                ),
              ),
              SizedBox(width: appTheme.spacing.md),
              Expanded(
                child: AppButtons.secondary(
                  text: 'Filter',
                  onPressed: () {},
                  icon: Icons.filter_list,
                ),
              ),
            ],
          ),

          SizedBox(height: appTheme.spacing.lg),

          // Tracks List
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 20,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: appTheme.spacing.sm),
                child: AppCards.musicTrack(
                  title: 'Track ${index + 1}',
                  artist: 'Artist ${index + 1}',
                  album: 'Album ${index + 1}',
                  imageUrl: 'https://via.placeholder.com/50x50',
                  duration: '3:45',
                  onTap: () {},
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumsTab() {
    final appTheme = AppTheme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(appTheme.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Album Grid
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: appTheme.spacing.md,
              mainAxisSpacing: appTheme.spacing.md,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              return AppCards.musicTrack(
                title: 'Album ${index + 1}',
                artist: 'Artist ${index + 1}',
                album: 'Album Collection',
                imageUrl: 'https://via.placeholder.com/150x150',
                duration: '45:30',
                onTap: () {},
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildArtistsTab() {
    final appTheme = AppTheme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(appTheme.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Artists List
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 15,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: appTheme.spacing.md),
                child: AppCards.profile(
                  name: 'Artist ${index + 1}',
                  role: '${25 + index * 5} tracks • ${10 + index * 2} albums',
                  imageUrl: 'https://via.placeholder.com/60x60',
                  onTap: () {},
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    final appTheme = AppTheme.of(context);

    return Column(
      children: [
        Text(
          value,
          style: appTheme.typography.headlineH5.copyWith(
            color: appTheme.colors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: appTheme.typography.bodyH8.copyWith(
            color: appTheme.colors.neutral[600],
          ),
        ),
      ],
    );
  }
}