import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/bud_matching/bud_matching_bloc.dart';
import '../../../models/bud_match.dart';
import '../../../models/bud_search_result.dart';
import '../../widgets/imported/index.dart';
import '../../widgets/bud_match_list_item.dart';

class ModernizedBudsScreen extends StatefulWidget {
  const ModernizedBudsScreen({super.key});

  @override
  State<ModernizedBudsScreen> createState() => _ModernizedBudsScreenState();
}

class _ModernizedBudsScreenState extends State<ModernizedBudsScreen>
    with LoadingStateMixin, ErrorStateMixin, TickerProviderStateMixin {
  
  final List<Map<String, dynamic>> _contentTypes = [
    {
      'label': 'Top Artists',
      'event': FindBudsByTopArtists(),
      'icon': Icons.person,
      'description': 'Find buds with similar top artists',
      'category': 'Top Content'
    },
    {
      'label': 'Top Tracks',
      'event': FindBudsByTopTracks(),
      'icon': Icons.music_note,
      'description': 'Find buds with similar top tracks',
      'category': 'Top Content'
    },
    {
      'label': 'Top Genres',
      'event': FindBudsByTopGenres(),
      'icon': Icons.category,
      'description': 'Find buds with similar genres',
      'category': 'Top Content'
    },
    {
      'label': 'Top Anime',
      'event': FindBudsByTopAnime(),
      'icon': Icons.tv,
      'description': 'Find buds with similar anime tastes',
      'category': 'Top Content'
    },
    {
      'label': 'Top Manga',
      'event': FindBudsByTopManga(),
      'icon': Icons.book,
      'description': 'Find buds with similar manga tastes',
      'category': 'Top Content'
    },
    {
      'label': 'Liked Artists',
      'event': FindBudsByLikedArtists(),
      'icon': Icons.favorite,
      'description': 'Find buds who like the same artists',
      'category': 'Liked Content'
    },
    {
      'label': 'Liked Tracks',
      'event': FindBudsByLikedTracks(),
      'icon': Icons.favorite,
      'description': 'Find buds who like the same tracks',
      'category': 'Liked Content'
    },
    {
      'label': 'Liked Genres',
      'event': FindBudsByLikedGenres(),
      'icon': Icons.favorite,
      'description': 'Find buds who like the same genres',
      'category': 'Liked Content'
    },
    {
      'label': 'Liked Albums',
      'event': FindBudsByLikedAlbums(),
      'icon': Icons.favorite,
      'description': 'Find buds who like the same albums',
      'category': 'Liked Content'
    },
    {
      'label': 'All Favorites',
      'event': FindBudsByLikedAio(),
      'icon': Icons.favorite,
      'description': 'Find buds across all your favorites',
      'category': 'Liked Content'
    },
    {
      'label': 'Played Tracks',
      'event': FindBudsByPlayedTracks(),
      'icon': Icons.play_circle,
      'description': 'Find buds with similar listening history',
      'category': 'Activity'
    },
  ];

  BudMatchingEvent? _lastEvent;
  String? _selectedCategory;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _initializeData() {
    setLoadingState(LoadingState.idle);
    // Start with empty/initial state
  }

  void _findBuds(BudMatchingEvent event) {
    _lastEvent = event;
    setLoadingState(LoadingState.loading);
    context.read<BudMatchingBloc>().add(event);
  }

  void _refreshResults() {
    if (_lastEvent != null) {
      _findBuds(_lastEvent!);
    }
  }

  BudMatch _convertBudSearchItemToBudMatch(BudSearchItem item) {
    return BudMatch(
      id: item.uid,
      userId: item.uid,
      username: item.displayName,
      email: item.email,
      avatarUrl: null, // BudSearchItem doesn't have avatar URL
      matchScore: _calculateMatchScore(item),
      commonArtists: item.commonArtistsCount ?? 0,
      commonTracks: item.commonTracksCount ?? 0,
      commonGenres: item.commonGenresCount ?? 0,
    );
  }

  double _calculateMatchScore(BudSearchItem item) {
    // Calculate a match score based on common content
    final artistScore = (item.commonArtistsCount ?? 0) * 0.4;
    final trackScore = (item.commonTracksCount ?? 0) * 0.3;
    final genreScore = (item.commonGenresCount ?? 0) * 0.3;
    return (artistScore + trackScore + genreScore).clamp(0.0, 100.0);
  }

  List<Map<String, dynamic>> get _filteredContentTypes {
    var filtered = _contentTypes.where((type) {
      final matchesSearch = _searchQuery.isEmpty ||
          (type['label'] as String).toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (type['description'] as String).toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesCategory = _selectedCategory == null ||
          type['category'] == _selectedCategory;
      
      return matchesSearch && matchesCategory;
    }).toList();

    return filtered;
  }

  Set<String> get _categories {
    return _contentTypes.map((type) => type['category'] as String).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BudMatchingBloc, BudMatchingState>(
      listener: (context, state) {
        if (state is BudMatchingError) {
          setError(
            state.message,
            type: ErrorType.network,
            retryable: true,
          );
          setLoadingState(LoadingState.error);
        } else if (state is BudsFound) {
          setLoadingState(LoadingState.loaded);
        } else if (state is BudMatchingLoading) {
          setLoadingState(LoadingState.loading);
        }
      },
      builder: (context, state) {
        return AppScaffold(
          appBar: AppBar(
            title: const Text('Find Music Buds'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _refreshResults,
                tooltip: 'Refresh Results',
              ),
            ],
          ),
          body: ResponsiveLayout(
            builder: (context, breakpoint) {
              switch (breakpoint) {
                case ResponsiveBreakpoint.xs:
                case ResponsiveBreakpoint.sm:
                  return _buildMobileLayout(state);
                case ResponsiveBreakpoint.md:
                  return _buildTabletLayout(state);
                case ResponsiveBreakpoint.lg:
                case ResponsiveBreakpoint.xl:
                  return _buildDesktopLayout(state);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout(BudMatchingState state) {
    return Column(
      children: [
        _buildSearchFiltersSection(),
        Expanded(child: _buildResultsSection(state)),
      ],
    );
  }

  Widget _buildTabletLayout(BudMatchingState state) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _buildSearchFiltersSidebar(),
        ),
        Expanded(
          flex: 2,
          child: _buildResultsSection(state),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BudMatchingState state) {
    return Row(
      children: [
        SizedBox(
          width: 350,
          child: _buildSearchFiltersSidebar(),
        ),
        Expanded(
          child: _buildResultsSection(state),
        ),
      ],
    );
  }

  Widget _buildSearchFiltersSection() {
    return ModernCard(
      variant: ModernCardVariant.elevated,
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Find Your Music Buds',
          ),
          const SizedBox(height: 8),
          Text(
            'Discover people with similar musical tastes',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          _buildSearchBar(),
          const SizedBox(height: 16),
          _buildCategoryFilters(),
          const SizedBox(height: 16),
          _buildContentTypeChips(),
        ],
      ),
    );
  }

  Widget _buildSearchFiltersSidebar() {
    return ModernCard(
      variant: ModernCardVariant.outlined,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Search Filters',
            ),
            const SizedBox(height: 16),
            _buildSearchBar(),
            const SizedBox(height: 16),
            _buildCategoryFilters(),
            const SizedBox(height: 16),
            Expanded(
              child: _buildContentTypeList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return ModernInputField(
      controller: _searchController,
      hintText: 'Search discovery methods...',
      prefixIcon: const Icon(Icons.search),
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
    );
  }

  Widget _buildCategoryFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilterChip(
              label: const Text('All'),
              selected: _selectedCategory == null,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = selected ? null : _selectedCategory;
                });
              },
            ),
            ..._categories.map((category) => FilterChip(
              label: Text(category),
              selected: _selectedCategory == category,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = selected ? category : null;
                });
              },
            )).toList(),
          ],
        ),
      ],
    );
  }

  Widget _buildContentTypeChips() {
    final filteredTypes = _filteredContentTypes.take(6).toList();
    if (filteredTypes.isEmpty) {
      return const Text('No matching discovery methods found');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Discovery Methods',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: filteredTypes.map((type) => ActionChip(
            avatar: Icon(type['icon'] as IconData, size: 18),
            label: Text(type['label'] as String),
            onPressed: () => _findBuds(type['event'] as BudMatchingEvent),
            tooltip: type['description'] as String,
          )).toList(),
        ),
        if (_filteredContentTypes.length > 6) ...[
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => _showAllMethodsDialog(),
            child: Text('Show ${_filteredContentTypes.length - 6} more methods'),
          ),
        ],
      ],
    );
  }

  Widget _buildContentTypeList() {
    final filteredTypes = _filteredContentTypes;
    if (filteredTypes.isEmpty) {
      return const Center(
        child: Text('No matching discovery methods found'),
      );
    }

    return ListView.builder(
      itemCount: filteredTypes.length,
      itemBuilder: (context, index) {
        final type = filteredTypes[index];
        return ModernCard(
          variant: ModernCardVariant.primary,
          margin: const EdgeInsets.only(bottom: 8),
          onTap: () => _findBuds(type['event'] as BudMatchingEvent),
          child: ListTile(
            leading: Icon(type['icon'] as IconData),
            title: Text(type['label'] as String),
            subtitle: Text(type['description'] as String),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        );
      },
    );
  }

  Widget _buildResultsSection(BudMatchingState state) {
    return buildLoadingState(
      context: context,
      loadedWidget: _buildResults(state),
      loadingWidget: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingIndicator(),
          SizedBox(height: 16),
          Text(
            'Finding your music buds...',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      errorWidget: buildDefaultErrorWidget(
        context: context,
        onRetry: _refreshResults,
      ),
    );
  }

  Widget _buildResults(BudMatchingState state) {
    if (state is BudMatchingInitial) {
      return _buildEmptyInitialState();
    } else if (state is BudsFound) {
      if (state.searchResult.data.buds.isEmpty) {
        return _buildEmptyResultsState();
      } else {
        return _buildBudsList(state);
      }
    } else if (state is BudMatchingError) {
      return EmptyState(
        icon: Icons.error_outline,
        title: 'Search Failed',
        message: state.message,
        actionText: 'Try Again',
        actionCallback: _refreshResults,
      );
    } else {
      return _buildEmptyInitialState();
    }
  }

  Widget _buildEmptyInitialState() {
    return EmptyState(
      icon: Icons.people_outline,
      title: 'Find Your Music Buds',
      message: 'Select a discovery method above to find people with similar musical tastes',
      actionText: 'Explore Top Artists',
      actionCallback: () => _findBuds(FindBudsByTopArtists()),
    );
  }

  Widget _buildEmptyResultsState() {
    return EmptyState(
      icon: Icons.search_off,
      title: 'No Buds Found',
      message: 'Try a different discovery method or check back later',
      actionText: 'Try Different Method',
      actionCallback: () => _showAllMethodsDialog(),
    );
  }

  Widget _buildBudsList(BudsFound state) {
    final buds = state.searchResult.data.buds.map(_convertBudSearchItemToBudMatch).toList();
    
    return RefreshIndicator(
      onRefresh: () async {
        _refreshResults();
        await Future.delayed(const Duration(seconds: 1));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ModernCard(
              variant: ModernCardVariant.outlined,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.people, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Found ${buds.length} Music Buds',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'People with similar musical tastes',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: buds.length,
              itemBuilder: (context, index) {
                final budMatch = buds[index];
                return ModernCard(
                  variant: ModernCardVariant.elevated,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: BudMatchListItem(budMatch: budMatch),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAllMethodsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('All Discovery Methods'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: _filteredContentTypes.length,
            itemBuilder: (context, index) {
              final type = _filteredContentTypes[index];
              return ListTile(
                leading: Icon(type['icon'] as IconData),
                title: Text(type['label'] as String),
                subtitle: Text(type['description'] as String),
                onTap: () {
                  Navigator.of(context).pop();
                  _findBuds(type['event'] as BudMatchingEvent);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  VoidCallback? get retryLoading => _refreshResults;

  @override
  VoidCallback? get onLoadingStarted => () {
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  };

  @override
  VoidCallback? get onLoadingCompleted => () {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Search completed!'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  };
}