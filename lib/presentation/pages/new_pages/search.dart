import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/content/content_bloc.dart';
import '../../../blocs/content/content_event.dart';
import '../../../domain/models/common_track.dart';
import '../../../domain/models/common_artist.dart';
import '../../../domain/models/common_album.dart';
import '../../../domain/models/common_genre.dart';
import '../../../domain/models/common_anime.dart';
import '../../../domain/models/common_manga.dart';
import '../../../domain/models/bud_match.dart';
import '../../constants/app_constants.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../widgets/common/app_app_bar.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/error_message.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final Map<String, List<dynamic>> _searchResults = {};
  final Map<String, bool> _isLoading = {};
  final Map<String, String?> _errorMessages = {};

  final List<String> _searchTypes = [
    'tracks',
    'artists',
    'albums',
    'genres',
    'anime',
    'manga',
    'buds',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _searchTypes.length, vsync: this);

    // Initialize search results and loading states
    for (String type in _searchTypes) {
      _searchResults[type] = [];
      _isLoading[type] = false;
      _errorMessages[type] = null;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppAppBar(
        title: 'Search',
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearSearch,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildSearchLimitations(),
          _buildTabBar(),
          Expanded(
            child: _buildTabView(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child:             AppTextField(
              controller: _searchController,
              labelText: 'Search',
              hintText: 'Enter your search query...',
              onSubmitted: (value) => _performSearch(),
            ),
          ),
          const SizedBox(width: 12),
          AppButton(
            text: 'Search',
            onPressed: _performSearch,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchLimitations() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info, color: Colors.orange, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Search functionality is limited. Content search is not supported by the API. You can browse your existing content instead.',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppConstants.borderColor.withValues(alpha: 0.3)),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppConstants.primaryColor,
          borderRadius: BorderRadius.circular(25),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppConstants.textSecondaryColor,
        isScrollable: true,
        tabs: _searchTypes.map((type) => Tab(text: type.toUpperCase())).toList(),
      ),
    );
  }

  Widget _buildTabView() {
    return TabBarView(
      controller: _tabController,
      children: _searchTypes.map((type) => _buildSearchTab(type)).toList(),
    );
  }

  Widget _buildSearchTab(String searchType) {
    if (_errorMessages[searchType] != null) {
      return ErrorMessage(
        message: _errorMessages[searchType]!,
        onRetry: () => _performSearch(),
      );
    }

    if (_isLoading[searchType] == true) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final results = _searchResults[searchType] ?? [];

    if (results.isEmpty && _searchController.text.isNotEmpty) {
      return _buildNoResults(searchType);
    }

    if (results.isEmpty) {
      return _buildEmptyState(searchType);
    }

    return _buildSearchResults(searchType, results);
  }

  Widget _buildEmptyState(String searchType) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getSearchTypeIcon(searchType),
            size: 64,
            color: AppConstants.textSecondaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No $searchType to display',
            style: const TextStyle(
              color: AppConstants.textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start searching or browse your existing content',
            style: TextStyle(
              color: AppConstants.textSecondaryColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults(String searchType) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 64,
            color: AppConstants.textSecondaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No $searchType found',
            style: const TextStyle(
              color: AppConstants.textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try a different search term or browse your existing content',
            style: TextStyle(
              color: AppConstants.textSecondaryColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(String searchType, List<dynamic> results) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return _buildSearchResultItem(searchType, item);
      },
    );
  }

  Widget _buildSearchResultItem(String searchType, dynamic item) {
    switch (searchType) {
      case 'tracks':
        if (item is CommonTrack) {
          return _buildTrackItem(item);
        }
        break;
      case 'artists':
        if (item is CommonArtist) {
          return _buildArtistItem(item);
        }
        break;
      case 'albums':
        if (item is CommonAlbum) {
          return _buildAlbumItem(item);
        }
        break;
      case 'genres':
        if (item is CommonGenre) {
          return _buildGenreItem(item);
        }
        break;
      case 'anime':
        if (item is CommonAnime) {
          return _buildAnimeItem(item);
        }
        break;
      case 'manga':
        if (item is CommonManga) {
          return _buildMangaItem(item);
        }
        break;
      case 'buds':
        if (item is BudMatch) {
          return _buildBudItem(item);
        }
        break;
    }

    return const SizedBox.shrink();
  }

  Widget _buildTrackItem(CommonTrack track) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppConstants.primaryColor.withValues(alpha: 0.2),
          child: const Icon(Icons.music_note, color: AppConstants.primaryColor),
        ),
        title: Text(
          track.name,
          style: const TextStyle(color: AppConstants.textColor),
        ),
        subtitle: Text(
                          track.artistName ?? 'Unknown Artist',
          style: const TextStyle(color: AppConstants.textSecondaryColor),
        ),
        trailing: IconButton(
          icon: Icon(
            track.isLiked ? Icons.favorite : Icons.favorite_border,
            color: track.isLiked ? Colors.red : AppConstants.textSecondaryColor,
          ),
          onPressed: () => _toggleLike(track.id, 'track'),
        ),
      ),
    );
  }

  Widget _buildArtistItem(CommonArtist artist) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppConstants.primaryColor.withValues(alpha: 0.2),
          child: const Icon(Icons.person, color: AppConstants.primaryColor),
        ),
        title: Text(
          artist.name,
          style: const TextStyle(color: AppConstants.textColor),
        ),
        subtitle: Text(
          '${artist.followers ?? 0} followers',
          style: const TextStyle(color: AppConstants.textSecondaryColor),
        ),
        trailing: IconButton(
          icon: Icon(
            artist.isLiked ? Icons.favorite : Icons.favorite_border,
            color: artist.isLiked ? Colors.red : AppConstants.textSecondaryColor,
          ),
          onPressed: () => _toggleLike(artist.id, 'artist'),
        ),
      ),
    );
  }

  Widget _buildAlbumItem(CommonAlbum album) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppConstants.primaryColor.withValues(alpha: 0.2),
          child: const Icon(Icons.album, color: AppConstants.primaryColor),
        ),
        title: Text(
          album.name,
          style: const TextStyle(color: AppConstants.textColor),
        ),
        subtitle: Text(
                          album.artistName ?? 'Unknown Artist',
          style: const TextStyle(color: AppConstants.textSecondaryColor),
        ),
        trailing: IconButton(
          icon: Icon(
            album.isLiked ? Icons.favorite : Icons.favorite_border,
            color: album.isLiked ? Colors.red : AppConstants.textSecondaryColor,
          ),
          onPressed: () => _toggleLike(album.id, 'album'),
        ),
      ),
    );
  }

  Widget _buildGenreItem(CommonGenre genre) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppConstants.primaryColor.withValues(alpha: 0.2),
          child: const Icon(Icons.category, color: AppConstants.primaryColor),
        ),
        title: Text(
          genre.name,
          style: const TextStyle(color: AppConstants.textColor),
        ),
        subtitle: const Text(
                          'Genre',
          style: TextStyle(color: AppConstants.textSecondaryColor),
        ),
        trailing: IconButton(
          icon: Icon(
            genre.isLiked ? Icons.favorite : Icons.favorite_border,
            color: genre.isLiked ? Colors.red : AppConstants.textSecondaryColor,
          ),
          onPressed: () => _toggleLike(genre.id, 'genre'),
        ),
      ),
    );
  }

  Widget _buildAnimeItem(CommonAnime anime) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppConstants.primaryColor.withValues(alpha: 0.2),
          child: const Icon(Icons.animation, color: AppConstants.primaryColor),
        ),
        title: Text(
          anime.title,
          style: const TextStyle(color: AppConstants.textColor),
        ),
        subtitle: Text(
          anime.type ?? 'Unknown Type',
          style: const TextStyle(color: AppConstants.textSecondaryColor),
        ),
        trailing: IconButton(
          icon: Icon(
            anime.isLiked ? Icons.favorite : Icons.favorite_border,
            color: anime.isLiked ? Colors.red : AppConstants.textSecondaryColor,
          ),
          onPressed: () => _toggleLike(anime.id, 'anime'),
        ),
      ),
    );
  }

  Widget _buildMangaItem(CommonManga manga) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppConstants.primaryColor.withValues(alpha: 0.2),
          child: const Icon(Icons.book, color: AppConstants.primaryColor),
        ),
        title: Text(
          manga.title,
          style: const TextStyle(color: AppConstants.textColor),
        ),
        subtitle: Text(
          manga.type ?? 'Unknown Type',
          style: const TextStyle(color: AppConstants.textSecondaryColor),
        ),
        trailing: IconButton(
          icon: Icon(
            manga.isLiked ? Icons.favorite : Icons.favorite_border,
            color: manga.isLiked ? Colors.red : AppConstants.textSecondaryColor,
          ),
          onPressed: () => _toggleLike(manga.id, 'manga'),
        ),
      ),
    );
  }

  Widget _buildBudItem(BudMatch bud) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppConstants.primaryColor.withValues(alpha: 0.2),
          child: const Icon(Icons.person, color: AppConstants.primaryColor),
        ),
        title: Text(
          bud.username,
          style: const TextStyle(color: AppConstants.textColor),
        ),
        subtitle: Text(
          '${bud.matchScore ?? 0}% match',
          style: const TextStyle(color: AppConstants.textSecondaryColor),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.person_add, color: AppConstants.primaryColor),
              onPressed: () => _sendBudRequest(bud.id),
            ),
            IconButton(
              icon: const Icon(Icons.message, color: AppConstants.primaryColor),
              onPressed: () => _openChat(bud.id),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getSearchTypeIcon(String searchType) {
    switch (searchType) {
      case 'tracks':
        return Icons.music_note;
      case 'artists':
        return Icons.person;
      case 'albums':
        return Icons.album;
      case 'genres':
        return Icons.category;
      case 'anime':
        return Icons.animation;
      case 'manga':
        return Icons.book;
      case 'buds':
        return Icons.people;
      default:
        return Icons.search;
    }
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      _showErrorSnackBar('Please enter a search query');
      return;
    }

    // Since search is not supported by the API, we'll show an error message
    _showErrorSnackBar('Content search is not supported by the API. Please browse your existing content instead.');

    // Clear previous results
    for (String type in _searchTypes) {
      _searchResults[type] = [];
      _errorMessages[type] = 'Search functionality is not supported by the API';
    }
    setState(() {});
  }

  void _clearSearch() {
    _searchController.clear();
    for (String type in _searchTypes) {
      _searchResults[type] = [];
      _errorMessages[type] = null;
    }
    setState(() {});
  }

  void _toggleLike(String id, String type) {
    final event = LikeItem(id: id, type: type);
    context.read<ContentBloc>().add(event);
  }

  void _sendBudRequest(String budId) {
    // TODO: Fix BudBloc events
    // final event = BudRequestSent(userId: budId);
    // context.read<BudBloc>().add(event);
    _showErrorSnackBar('Bud request functionality not yet implemented');
  }

  void _openChat(String budId) {
    // TODO: Implement chat opening
    _showErrorSnackBar('Chat functionality not yet implemented');
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildNavigationDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: AppConstants.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: AppConstants.primaryColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Guest',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'guest@example.com',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            icon: Icons.home,
            text: 'Home',
            onTap: () {
              Navigator.pop(context);
              // Navigate to Home
            },
          ),
          _buildDrawerItem(
            icon: Icons.search,
            text: 'Search',
            onTap: () {
              Navigator.pop(context);
              // Already on Search page
            },
          ),
          _buildDrawerItem(
            icon: Icons.favorite,
            text: 'Favorites',
            onTap: () {
              Navigator.pop(context);
              // Navigate to Favorites
            },
          ),
          _buildDrawerItem(
            icon: Icons.history,
            text: 'History',
            onTap: () {
              Navigator.pop(context);
              // Navigate to History
            },
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            text: 'Settings',
            onTap: () {
              Navigator.pop(context);
              // Navigate to Settings
            },
          ),
          const SizedBox(height: 8),
          const Divider(color: Colors.grey),
          const SizedBox(height: 8),
          _buildDrawerItem(
            icon: Icons.logout,
            text: 'Logout',
            onTap: () {
              Navigator.pop(context);
              // Perform logout
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppConstants.primaryColor),
      title: Text(
        text,
        style: const TextStyle(
          color: AppConstants.textColor,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }
}
