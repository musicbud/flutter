import 'package:flutter/material.dart';
import '../../widgets/search_suggestion_list.dart';

class SearchSuggestions extends StatelessWidget {
  final List<String> suggestions;
  final bool showTrendingIcon;
  final ValueChanged<String> onSuggestionSelected;

  const SearchSuggestions({
    super.key,
    required this.suggestions,
    this.showTrendingIcon = false,
    required this.onSuggestionSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return SearchSuggestionList(
      suggestions: suggestions,
      showTrendingIcon: showTrendingIcon,
      onSuggestionSelected: onSuggestionSelected,
    );
  }
}