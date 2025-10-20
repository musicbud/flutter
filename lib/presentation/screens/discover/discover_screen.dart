import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/discover/discover_bloc.dart';
import '../../../blocs/discover/discover_event.dart';
import '../../../blocs/discover/discover_state.dart';
import '../../../core/theme/design_system.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  bool _isSearchMode = false;

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
    context.read<DiscoverBloc>().add(const FetchTopTracks());
    context.read<DiscoverBloc>().add(const FetchTopArtists());
    context.read<DiscoverBloc>().add(const FetchTopGenres());
  }

  void _toggleSearchMode() {
    setState(() {
      _isSearchMode = !_isSearchMode;
      if (!_isSearchMode) {
        _searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignSystem.surface,
      appBar: AppBar(
        title: const Text('Discover'),
        backgroundColor: DesignSystem.surfaceContainer,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isSearchMode ? Icons.close : Icons.search),
            onPressed: _toggleSearchMode,
            tooltip: _isSearchMode ? 'Close Search' : 'Search',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializeData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocConsumer<DiscoverBloc, DiscoverState>(
        listener: (context, state) {
          if (state is DiscoverError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is DiscoverLoading) {
            return _buildLoadingState();
          } else if (state is DiscoverError) {
            return _buildErrorState(state.message);
          } else if (state is DiscoverLoaded) {
            return _buildContent(state);
          }
          return _buildInitialState();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: DesignSystem.error,
          ),
          const SizedBox(height: DesignSystem.spacingMD),
          Text(
            'Something went wrong',
            style: DesignSystem.headlineSmall,
          ),
          const SizedBox(height: DesignSystem.spacingSM),
          Text(
            message,
            style: DesignSystem.bodyMedium.copyWith(
              color: DesignSystem.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignSystem.spacingLG),
          ElevatedButton(
            onPressed: _initializeData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return const Center(
      child: Text('Welcome to Discover'),
    );
  }

  Widget _buildContent(DiscoverLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(DesignSystem.spacingMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isSearchMode) _buildSearchSection(),
          _buildCategoriesSection(),
          const SizedBox(height: DesignSystem.spacingLG),
          _buildFeaturedSection(),
          const SizedBox(height: DesignSystem.spacingLG),
          _buildTrendingSection(),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: DesignSystem.spacingMD),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search for music, artists, albums...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: DesignSystem.surfaceContainer,
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    final categories = ['All', 'Music', 'Artists', 'Albums', 'Genres'];
    
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == _selectedCategory;
          
          return Container(
            margin: const EdgeInsets.only(right: DesignSystem.spacingSM),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              backgroundColor: DesignSystem.surfaceContainer,
              selectedColor: DesignSystem.primary,
              labelStyle: TextStyle(
                color: isSelected ? DesignSystem.onPrimary : DesignSystem.onSurface,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Featured Content',
          style: DesignSystem.headlineSmall,
        ),
        const SizedBox(height: DesignSystem.spacingMD),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: DesignSystem.spacingMD),
                decoration: BoxDecoration(
                  color: DesignSystem.surfaceContainer,
                  borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
                  boxShadow: DesignSystem.shadowSmall,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: DesignSystem.primary.withValues(alpha: 0.1),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(DesignSystem.radiusMD),
                            topRight: Radius.circular(DesignSystem.radiusMD),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.music_note,
                            size: 48,
                            color: DesignSystem.primary,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(DesignSystem.spacingSM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Featured Item ${index + 1}',
                            style: DesignSystem.titleSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Artist Name',
                            style: DesignSystem.bodySmall.copyWith(
                              color: DesignSystem.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Trending Now',
              style: DesignSystem.headlineSmall,
            ),
            TextButton(
              onPressed: () {},
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: DesignSystem.spacingMD),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: DesignSystem.primary.withValues(alpha: 0.1),
                child: Text('${index + 1}'),
              ),
              title: Text('Trending Track ${index + 1}'),
              subtitle: Text('Artist Name ${index + 1}'),
              trailing: IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () {},
              ),
            );
          },
        ),
      ],
    );
  }
}