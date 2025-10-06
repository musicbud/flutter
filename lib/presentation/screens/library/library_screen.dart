import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/library/library_bloc.dart';
import '../../../blocs/library/library_event.dart';
import '../../../blocs/library/library_state.dart';
import '../../../core/theme/design_system.dart';
import '../../../widgets/common/index.dart';
import 'library_tab_manager.dart';
import 'library_search_section.dart';
import 'tabs/playlists_tab.dart';
import 'tabs/liked_songs_tab.dart';
import 'tabs/downloads_tab.dart';
import 'tabs/recently_played_tab.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedTab = 'Playlists';
  int _selectedIndex = 0;

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
      _selectedIndex = ['Playlists', 'Liked Songs', 'Downloads', 'Recently Played'].indexOf(tab);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: DesignSystem.gradientBackground,
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
                backgroundColor: DesignSystem.error,
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
                          color: DesignSystem.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Search Section
              SliverToBoxAdapter(
                child: LibrarySearchSection(
                  selectedTab: _selectedTab,
                  searchController: _searchController,
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
                      onPressed: () {
                        // Dialog is handled by PlaylistsTab
                      },
                      icon: Icons.add,
                      size: ModernButtonSize.large,
                    ),
                  ),
                ),

              SliverToBoxAdapter(
                child: const SizedBox(height: 24),
              ),

              // Library Items Section (for search results)
              if (state is LibraryLoaded && state.items.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      '${state.totalCount} $_selectedTab',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: DesignSystem.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: const SizedBox(height: 24),
                ),
              ],

              // Tab Manager
              SliverToBoxAdapter(
                child: LibraryTabManager(
                  selectedTab: _selectedTab,
                  selectedIndex: _selectedIndex,
                  onTabChanged: _onTabChanged,
                ),
              ),

              SliverToBoxAdapter(
                child: const SizedBox(height: 32),
              ),

              // Content based on selected tab
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildTabContent(),
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

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 'Playlists':
        return const PlaylistsTab();
      case 'Liked Songs':
        return const LikedSongsTab();
      case 'Downloads':
        return const DownloadsTab();
      case 'Recently Played':
        return const RecentlyPlayedTab();
      default:
        return const PlaylistsTab();
    }
  }



}