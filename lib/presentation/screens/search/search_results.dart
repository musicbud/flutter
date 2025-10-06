import 'package:flutter/material.dart';
import '../../../domain/models/search.dart';
import '../../widgets/search_result_item.dart';
import '../../widgets/sections/content_list.dart';

class SearchResults extends StatelessWidget {
  final List<SearchItem> results;
  final bool hasMore;
  final bool isLoading;
  final VoidCallback onLoadMore;
  final ScrollController scrollController;
  final ValueChanged<SearchItem> onItemTap;

  const SearchResults({
    super.key,
    required this.results,
    required this.hasMore,
    required this.isLoading,
    required this.onLoadMore,
    required this.scrollController,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return ContentList<SearchItem>(
      items: results,
      itemBuilder: (context, item, index) => SearchResultItem(
        item: item,
        onTap: () => onItemTap(item),
      ),
      hasMoreItems: hasMore,
      onLoadMore: onLoadMore,
      scrollController: scrollController,
      isLoading: isLoading && results.isEmpty,
      emptyState: _buildEmptyState(),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'No results found',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    );
  }
}