import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/search/search_bloc.dart';
import '../blocs/search/search_event.dart';
import '../blocs/search/search_state.dart';
import '../widgets/search_result_item.dart';
import '../widgets/search_filter_chip.dart';
import '../widgets/search_suggestion_list.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_view.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  final List<String> _selectedTypes = [];
  final Map<String, dynamic> _activeFilters = {};
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    context.read<SearchBloc>()
      ..add(const GetRecentSearches(limit: 5))
      ..add(const GetTrendingSearches(limit: 5));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      final currentState = context.read<SearchBloc>().state;
      if (currentState is SearchResultsLoaded) {
        if (currentState.results.metadata.hasMore) {
          context.read<SearchBloc>().add(PerformSearch(
                query: currentState.query,
                types: _selectedTypes,
                filters: _activeFilters,
                page: currentState.results.metadata.currentPage + 1,
                pageSize: currentState.results.metadata.pageSize,
                saveToRecent: false,
              ));
        }
      }
    }
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      context.read<SearchBloc>().add(ResetSearch());
      _loadInitialData();
    } else {
      context.read<SearchBloc>().add(GetSearchSuggestions(query: query));
    }
  }

  void _onSearch(String query) {
    if (query.isNotEmpty) {
      context.read<SearchBloc>().add(PerformSearch(
            query: query,
            types: _selectedTypes,
            filters: _activeFilters,
          ));
      _searchFocusNode.unfocus();
    }
  }

  void _toggleFilter(String type) {
    setState(() {
      if (_selectedTypes.contains(type)) {
        _selectedTypes.remove(type);
      } else {
        _selectedTypes.add(type);
      }

      final currentState = context.read<SearchBloc>().state;
      if (currentState is SearchResultsLoaded) {
        context.read<SearchBloc>().add(PerformSearch(
              query: currentState.query,
              types: _selectedTypes.isEmpty ? [] : _selectedTypes,
              filters: _activeFilters,
              saveToRecent: false,
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      context.read<SearchBloc>().add(ResetSearch());
                      _loadInitialData();
                    },
                  ),
                IconButton(
                  icon: Icon(
                    _showFilters ? Icons.filter_list_off : Icons.filter_list,
                  ),
                  onPressed: () {
                    setState(() => _showFilters = !_showFilters);
                  },
                ),
              ],
            ),
          ),
          onChanged: _onSearchChanged,
          onSubmitted: _onSearch,
        ),
      ),
      body: Column(
        children: [
          if (_showFilters)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  SearchFilterChip(
                    label: 'Users',
                    icon: Icons.person,
                    selected: _selectedTypes.contains('user'),
                    onSelected: (_) => _toggleFilter('user'),
                  ),
                  const SizedBox(width: 8),
                  SearchFilterChip(
                    label: 'Music',
                    icon: Icons.music_note,
                    selected: _selectedTypes.contains('music'),
                    onSelected: (_) => _toggleFilter('music'),
                  ),
                  const SizedBox(width: 8),
                  SearchFilterChip(
                    label: 'Playlists',
                    icon: Icons.queue_music,
                    selected: _selectedTypes.contains('playlist'),
                    onSelected: (_) => _toggleFilter('playlist'),
                  ),
                  const SizedBox(width: 8),
                  SearchFilterChip(
                    label: 'Events',
                    icon: Icons.event,
                    selected: _selectedTypes.contains('event'),
                    onSelected: (_) => _toggleFilter('event'),
                  ),
                  const SizedBox(width: 8),
                  SearchFilterChip(
                    label: 'Channels',
                    icon: Icons.forum,
                    selected: _selectedTypes.contains('channel'),
                    onSelected: (_) => _toggleFilter('channel'),
                  ),
                ],
              ),
            ),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const LoadingIndicator();
                } else if (state is SearchResultsLoaded) {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: state.results.items.length + 1,
                    itemBuilder: (context, index) {
                      if (index == state.results.items.length) {
                        return state.results.metadata.hasMore
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(child: CircularProgressIndicator()),
                              )
                            : const SizedBox.shrink();
                      }

                      final item = state.results.items[index];
                      return SearchResultItem(
                        item: item,
                        onTap: () {
                          // TODO: Navigate to item details
                        },
                      );
                    },
                  );
                } else if (state is SearchSuggestionsLoaded) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state.suggestions.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'Suggestions',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          SearchSuggestionList(
                            suggestions: state.suggestions,
                            onSuggestionSelected: (suggestion) {
                              _searchController.text = suggestion;
                              _onSearch(suggestion);
                            },
                          ),
                        ],
                      ],
                    ),
                  );
                } else if (state is RecentSearchesLoaded) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state.searches.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Recent Searches',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                TextButton(
                                  onPressed: () {
                                    context
                                        .read<SearchBloc>()
                                        .add(ClearRecentSearches());
                                  },
                                  child: const Text('Clear'),
                                ),
                              ],
                            ),
                          ),
                          SearchSuggestionList(
                            suggestions: state.searches,
                            onSuggestionSelected: (search) {
                              _searchController.text = search;
                              _onSearch(search);
                            },
                          ),
                        ],
                      },
                    ),
                  );
                } else if (state is TrendingSearchesLoaded) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state.searches.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'Trending Searches',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          SearchSuggestionList(
                            suggestions: state.searches,
                            showTrendingIcon: true,
                            onSuggestionSelected: (search) {
                              _searchController.text = search;
                              _onSearch(search);
                            },
                          ),
                        ],
                      },
                    ),
                  );
                } else if (state is SearchEmpty) {
                  return Center(
                    child: Text(
                      'No results found for "${state.query}"',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                } else if (state is SearchError) {
                  return ErrorView(
                    message: state.message,
                    onRetry: () {
                      if (_searchController.text.isNotEmpty) {
                        _onSearch(_searchController.text);
                      } else {
                        _loadInitialData();
                      }
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}