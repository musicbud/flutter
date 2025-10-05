import 'package:flutter/material.dart';

class SearchSuggestionList extends StatelessWidget {
  final List<String> suggestions;
  final ValueChanged<String> onSuggestionSelected;
  final bool showTrendingIcon;

  const SearchSuggestionList({
    Key? key,
    required this.suggestions,
    required this.onSuggestionSelected,
    this.showTrendingIcon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          leading: Icon(
            showTrendingIcon ? Icons.trending_up : Icons.history,
            color: Theme.of(context).colorScheme.secondary,
          ),
          title: Text(suggestion),
          onTap: () => onSuggestionSelected(suggestion),
          trailing: IconButton(
            icon: const Icon(Icons.north_west),
            onPressed: () => onSuggestionSelected(suggestion),
            tooltip: 'Use this suggestion',
          ),
        );
      },
    );
  }
}
