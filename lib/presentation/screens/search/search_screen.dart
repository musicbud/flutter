import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/search.dart' as search_models;
import '../../blocs/search/search_bloc.dart';
import '../../blocs/search/search_event.dart';
import '../../blocs/search/search_state.dart';
import '../../../presentation/navigation/main_navigation.dart';
import '../../../presentation/navigation/navigation_drawer.dart';
import 'search_app_bar.dart';
import 'search_filters.dart';
import 'search_results.dart' as search_widget;
import 'search_suggestions.dart';
import 'components/search_empty_state.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late final MainNavigationController _navigationController;

  final List<String> _selectedTypes = [];
  final Map<String, dynamic> _activeFilters = {};
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _navigationController = MainNavigationController();
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    _navigationController.dispose();
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

  void _onClearSearch() {
    _searchController.clear();
    context.read<SearchBloc>().add(ResetSearch());
    _loadInitialData();
  }

  void _onToggleFilters() {
    setState(() => _showFilters = !_showFilters);
  }

  void _onLoadMore(SearchResultsLoaded state) {
    context.read<SearchBloc>().add(PerformSearch(
          query: state.query,
          types: _selectedTypes,
          filters: _activeFilters,
          page: state.results.metadata.currentPage + 1,
          pageSize: state.results.metadata.pageSize,
          saveToRecent: false,
        ));
  }

  void _onItemTap(search_models.SearchItem item) {
    Navigator.pushNamed(
      context,
      '/details',
      arguments: {
        'item': item,
        'type': item.type,
      },
    );
  }

  void _onSuggestionSelected(String suggestion) {
    _searchController.text = suggestion;
    _onSearch(suggestion);
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
      key: _scaffoldKey,
      appBar: SearchAppBar(
        searchController: _searchController,
        searchFocusNode: _searchFocusNode,
        showFilters: _showFilters,
        onSearchChanged: _onSearchChanged,
        onSearchSubmitted: _onSearch,
        onClearSearch: _onClearSearch,
        onToggleFilters: _onToggleFilters,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: MainNavigationDrawer(
        navigationController: _navigationController,
      ),
      body: Column(
        children: [
          if (_showFilters)
            SearchFilters(
              selectedTypes: _selectedTypes,
              onFilterToggled: _toggleFilter,
            ),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const LoadingIndicator();
                } else if (state is SearchResultsLoaded) {
                  return search_widget.SearchResults(
                    results: state.results.items,
                    hasMore: state.results.metadata.hasMore,
                    isLoading: false,
                    onLoadMore: () => _onLoadMore(state),
                    scrollController: _scrollController,
                    onItemTap: _onItemTap,
                  );
                } else if (state is SearchSuggestionsLoaded) {
                  return SearchSuggestions(
                    suggestions: state.suggestions,
                    onSuggestionSelected: _onSuggestionSelected,
                  );
                } else if (state is RecentSearchesLoaded) {
                  return SearchSuggestions(
                    suggestions: state.searches,
                    onSuggestionSelected: _onSuggestionSelected,
                  );
                } else if (state is TrendingSearchesLoaded) {
                  return SearchSuggestions(
                    suggestions: state.searches,
                    showTrendingIcon: true,
                    onSuggestionSelected: _onSuggestionSelected,
                  );
                } else if (state is SearchEmpty) {
                  return SearchEmptyState(query: state.query);
                } else if (state is SearchError) {
                  return ErrorView(
                    title: 'Search Error',
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