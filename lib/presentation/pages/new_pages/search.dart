import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/profile/profile_bloc.dart';
import '../../../blocs/profile/profile_event.dart';
import '../../../blocs/profile/profile_state.dart';
import '../../../domain/models/common_track.dart';
import '../../../domain/models/common_artist.dart';
import '../../../domain/models/common_genre.dart';
import '../../../domain/models/user_profile.dart';
import '../../../domain/models/channel.dart';
import '../../constants/app_constants.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../widgets/common/app_app_bar.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';
import '../../mixins/page_mixin.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with PageMixin, TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _currentQuery = '';
  String _selectedCategory = 'all';
  String _selectedFilter = 'relevance';

  final List<String> _categories = [
    'all',
    'music',
    'users',
    'channels',
    'stories',
    'genres',
  ];

  final List<String> _filters = [
    'relevance',
    'newest',
    'popular',
    'rating',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedCategory = _categories[_tabController.index];
      });
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _loadMoreResults();
    }
  }

  void _loadMoreResults() {
    if (_currentQuery.isNotEmpty) {
      // TODO: Implement search load more
      print('Load more for: $_currentQuery, $_selectedCategory, $_selectedFilter');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppAppBar(
        title: 'Search',
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showAdvancedFilters(),
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _showSearchHistory(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
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
      child: AppTextField(
        controller: _searchController,
        labelText: 'Search MusicBud',
        hintText: 'Search for music, users, channels, stories...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _currentQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _clearSearch,
              )
            : null,
        onChanged: (value) {
          setState(() {
            _currentQuery = value;
          });
          if (value.isNotEmpty) {
            _performSearch(value);
          }
        },
        onSubmitted: _performSearch,
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _filters.map((filter) => Container(
          margin: const EdgeInsets.only(right: 8),
          child: FilterChip(
            label: Text(filter),
            selected: _selectedFilter == filter,
            onSelected: (selected) {
              setState(() {
                _selectedFilter = filter;
              });
              if (_currentQuery.isNotEmpty) {
                _performSearch(_currentQuery);
              }
            },
            backgroundColor: AppConstants.surfaceColor,
            selectedColor: AppConstants.primaryColor,
            labelStyle: TextStyle(
              color: _selectedFilter == filter ? Colors.white : AppConstants.textColor,
            ),
            side: BorderSide(
              color: _selectedFilter == filter ? AppConstants.primaryColor : AppConstants.borderColor,
            ),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppConstants.borderColor.withOpacity(0.3)),
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
        tabs: _categories.map((category) => Tab(
          text: _getCategoryDisplayName(category),
        )).toList(),
      ),
    );
  }

  Widget _buildTabView() {
    if (_currentQuery.isEmpty) {
      return _buildSearchSuggestions();
    }

    return TabBarView(
      controller: _tabController,
      children: _categories.map((category) => _buildSearchResults(category)).toList(),
    );
  }

  Widget _buildSearchSuggestions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Popular Searches'),
          _buildPopularSearches(),
          const SizedBox(height: 24),
          _buildSectionTitle('Recent Searches'),
          _buildRecentSearches(),
          const SizedBox(height: 24),
          _buildSectionTitle('Trending Topics'),
          _buildTrendingTopics(),
        ],
      ),
    );
  }

  Widget _buildSearchResults(String category) {
        // TODO: Implement search results
    return const Center(child: Text('Search functionality coming soon'));
  }

  Widget _buildPopularSearches() {
    final popularSearches = [
      'Pop Music',
      'Rock Bands',
      'Jazz Artists',
      'Electronic Music',
      'Hip Hop',
      'Classical',
      'Country Music',
      'R&B',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: popularSearches.map((search) => ActionChip(
        label: Text(search),
        onPressed: () => _performSearch(search),
        backgroundColor: AppConstants.surfaceColor,
        labelStyle: const TextStyle(color: Colors.white),
        side: BorderSide(color: AppConstants.borderColor),
      )).toList(),
    );
  }

  Widget _buildRecentSearches() {
    final recentSearches = [
      'Ed Sheeran',
      'Taylor Swift',
      'The Weeknd',
      'Drake',
      'Ariana Grande',
    ];

    return Column(
      children: recentSearches.map((search) => ListTile(
        leading: const Icon(Icons.history, color: Colors.white70),
        title: Text(
          search,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
        onTap: () => _performSearch(search),
      )).toList(),
    );
  }

  Widget _buildTrendingTopics() {
    final trendingTopics = [
      {'topic': 'Summer Hits 2024', 'count': '2.3K'},
      {'topic': 'Indie Rock', 'count': '1.8K'},
      {'topic': 'K-Pop', 'count': '1.5K'},
      {'topic': 'Lo-Fi', 'count': '1.2K'},
    ];

    return Column(
      children: trendingTopics.map((topic) => ListTile(
        leading: const Icon(Icons.trending_up, color: AppConstants.primaryColor),
        title: Text(
          topic['topic']!,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          '${topic['count']} searches',
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
        onTap: () => _performSearch(topic['topic']!),
      )).toList(),
    );
  }

  Widget _buildResultsList(List<dynamic> results, String category) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return _buildResultItem(result, category);
      },
    );
  }

  Widget _buildResultItem(dynamic result, String category) {
    switch (category) {
      case 'music':
        if (result is CommonTrack) {
          return _buildTrackResult(result);
        } else if (result is CommonArtist) {
          return _buildArtistResult(result);
        } else if (result is CommonGenre) {
          return _buildGenreResult(result);
        }
        break;
      case 'users':
        if (result is UserProfile) {
          return _buildUserResult(result);
        }
        break;
      case 'channels':
        if (result is Channel) {
          return _buildChannelResult(result);
        }
        break;
      case 'stories':
        // TODO: Implement story result
        break;
        break;
    }

    return const SizedBox.shrink();
  }

  Widget _buildTrackResult(CommonTrack track) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppConstants.surfaceColor,
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.music_note,
            color: Colors.white70,
          ),
        ),
        title: Text(
          track.name,
          style: const TextStyle(color: Colors.white),
        ),
                    subtitle: Text(
              track.artistName ?? 'Unknown Artist',
              style: const TextStyle(color: Colors.white70),
            ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _playTrack(track.id),
              icon: const Icon(
                Icons.play_circle_outline,
                color: Colors.white70,
              ),
            ),
            Icon(
              track.isLiked ? Icons.favorite : Icons.favorite_border,
              color: track.isLiked ? Colors.red : Colors.white70,
            ),
          ],
        ),
        onTap: () => _showTrackDetails(track),
      ),
    );
  }

  Widget _buildArtistResult(CommonArtist artist) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppConstants.surfaceColor,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppConstants.primaryColor.withOpacity(0.3),
          child: Text(
            artist.name.isNotEmpty ? artist.name[0].toUpperCase() : 'A',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          artist.name,
          style: const TextStyle(color: Colors.white),
        ),
                    subtitle: Text(
              '${artist.followers ?? 0} followers',
              style: const TextStyle(color: Colors.white70),
            ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _followArtist(artist.id),
              icon:             Icon(
              Icons.person_add,
              color: Colors.white70,
            ),
            ),
            Icon(
              artist.isLiked ? Icons.favorite : Icons.favorite_border,
              color: artist.isLiked ? Colors.red : Colors.white70,
            ),
          ],
        ),
        onTap: () => _showArtistDetails(artist),
      ),
    );
  }

  Widget _buildGenreResult(CommonGenre genre) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppConstants.surfaceColor,
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.category,
            color: Colors.white70,
          ),
        ),
        title: Text(
          genre.name,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          '0 tracks',
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: IconButton(
          onPressed: () => _exploreGenre(genre.id),
          icon: const Icon(
            Icons.explore,
            color: Colors.white70,
          ),
        ),
        onTap: () => _showGenreDetails(genre),
      ),
    );
  }

  Widget _buildUserResult(UserProfile user) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppConstants.surfaceColor,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppConstants.primaryColor.withOpacity(0.3),
          backgroundImage: user.avatarUrl != null
              ? NetworkImage(user.avatarUrl!)
              : null,
          child: user.avatarUrl == null
              ? Text(
                  user.username.isNotEmpty ? user.username[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        title: Text(
          user.displayName ?? user.username,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          user.bio ?? 'No bio available',
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _sendBudRequest(user.id),
              icon: const Icon(
                Icons.person_add,
                color: Colors.white70,
              ),
            ),
            IconButton(
              onPressed: () => _viewUserProfile(user.id),
              icon: const Icon(
                Icons.person,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        onTap: () => _viewUserProfile(user.id),
      ),
    );
  }

  Widget _buildChannelResult(Channel channel) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppConstants.surfaceColor,
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.chat,
            color: Colors.white70,
          ),
        ),
        title: Text(
          channel.name,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          '${channel.memberCount} members',
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _joinChannel(channel.id),
              icon:                 Icon(
                  Icons.login,
                  color: Colors.white70,
                ),
            ),
            IconButton(
              onPressed: () => _viewChannelDetails(channel.id),
              icon: const Icon(
                Icons.info,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        onTap: () => _viewChannelDetails(channel.id),
      ),
    );
  }

  Widget _buildStoryResult(dynamic story) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppConstants.surfaceColor,
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.article,
            color: Colors.white70,
          ),
        ),
        title: Text(
          story.title.isNotEmpty ? story.title : 'Untitled Story',
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          'by ${story.authorName}',
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite,
              color: story.isLiked ? Colors.red : Colors.white70,
            ),
            const SizedBox(width: 4),
            Text(
              '${story.likesCount}',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
        onTap: () => _viewStory(story.id),
      ),
    );
  }

  Widget _buildNoResultsFound(String category) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getCategoryIcon(category),
            size: 64,
            color: Colors.white54,
          ),
          const SizedBox(height: 16),
          Text(
            'No ${_getCategoryDisplayName(category)} found',
            style: TextStyle(
              color: AppConstants.textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search terms or filters',
            style: TextStyle(
              color: AppConstants.textSecondaryColor,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Search Error',
            style: TextStyle(
              color: AppConstants.textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(
              color: AppConstants.textSecondaryColor,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          AppButton(
            text: 'Retry',
            onPressed: () => _performSearch(_currentQuery),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          color: AppConstants.textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Helper methods
  String _getCategoryDisplayName(String category) {
    switch (category) {
      case 'all':
        return 'All';
      case 'music':
        return 'Music';
      case 'users':
        return 'Users';
      case 'channels':
        return 'Channels';
      case 'stories':
        return 'Stories';
      case 'genres':
        return 'Genres';
      default:
        return category;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'music':
        return Icons.music_note;
      case 'users':
        return Icons.people;
      case 'channels':
        return Icons.chat;
      case 'stories':
        return Icons.article;
      case 'genres':
        return Icons.category;
      default:
        return Icons.search;
    }
  }

  List<dynamic> _filterResultsByCategory(List<dynamic> results, String category) {
    if (category == 'all') return results;

    return results.where((result) {
      switch (category) {
        case 'music':
          return result is CommonTrack || result is CommonArtist || result is CommonGenre;
        case 'users':
          return result is UserProfile;
        case 'channels':
          return result is Channel;
        case 'stories':
          return false; // TODO: Implement story filtering
        case 'genres':
          return result is CommonGenre;
        default:
          return true;
      }
    }).toList();
  }

  // Action methods
  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      // TODO: Implement search
      print('Search for: ${query.trim()}, $_selectedCategory, $_selectedFilter');
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _currentQuery = '';
    });
  }

  void _showAdvancedFilters() {
    // Implement advanced filters dialog
  }

  void _showSearchHistory() {
    // Implement search history dialog
  }

  void _playTrack(String trackId) {
    // Implement play track logic
  }

  void _showTrackDetails(CommonTrack track) {
    // Navigate to track details page
  }

  void _followArtist(String artistId) {
    // Implement follow artist logic
  }

  void _showArtistDetails(CommonArtist artist) {
    // Navigate to artist details page
  }

  void _exploreGenre(String genreId) {
    // Navigate to genre exploration page
  }

  void _showGenreDetails(CommonGenre genre) {
    // Navigate to genre details page
  }

  void _sendBudRequest(String userId) {
    // Implement send bud request logic
  }

  void _viewUserProfile(String userId) {
    // Navigate to user profile page
  }

  void _joinChannel(String channelId) {
    // Implement join/leave channel logic
  }

  void _viewChannelDetails(String channelId) {
    // Navigate to channel details page
  }

  void _viewStory(String storyId) {
    // Navigate to story view page
  }
}
