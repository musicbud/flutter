import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/bud_matching/bud_matching_bloc.dart';
import '../../../core/theme/design_system.dart';
import '../../../models/bud_match.dart';
import '../../../presentation/widgets/common/modern_input_field.dart';
import '../../../presentation/widgets/common/modern_button.dart';
import '../../../presentation/widgets/bud_match_list_item.dart';
import '../../../presentation/widgets/common/loading_indicator.dart';
import '../../../presentation/widgets/common/empty_state.dart';

class BudsScreen extends StatefulWidget {
  const BudsScreen({super.key});

  @override
  State<BudsScreen> createState() => _BudsScreenState();
}

class _BudsScreenState extends State<BudsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _quickSearches = [
    'music lovers',
    'rock fans',
    'pop enthusiasts',
    'jazz lovers',
    'electronic music',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      context.read<BudMatchingBloc>().add(SearchBuds(query: query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Find Buds',
          style: DesignSystem.headlineSmall,
        ),
        backgroundColor: DesignSystem.surface,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Section
          Container(
            padding: const EdgeInsets.all(DesignSystem.spacingLG),
            decoration: BoxDecoration(
              color: DesignSystem.surface,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(DesignSystem.radiusLG),
                bottomRight: Radius.circular(DesignSystem.radiusLG),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ModernInputField(
                  hintText: 'Search for music buddies...',
                  controller: _searchController,
                  onSubmitted: _performSearch,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => _performSearch(_searchController.text),
                  ),
                ),
                const SizedBox(height: DesignSystem.spacingMD),
                Text(
                  'Quick Searches',
                  style: DesignSystem.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: DesignSystem.spacingSM),
                Wrap(
                  spacing: DesignSystem.spacingSM,
                  runSpacing: DesignSystem.spacingSM,
                  children: _quickSearches.map((search) => ActionChip(
                    label: Text(search),
                    onPressed: () => _performSearch(search),
                    backgroundColor: DesignSystem.background,
                  )).toList(),
                ),
              ],
            ),
          ),

          // Results Section
          Expanded(
            child: BlocBuilder<BudMatchingBloc, BudMatchingState>(
              builder: (context, state) {
                if (state is BudMatchingInitial) {
                  return EmptyState(
                    icon: Icons.people_outline,
                    title: 'Find Your Music Buds',
                    message: 'Search for people with similar music tastes',
                  );
                }

                if (state is BudMatchingLoading) {
                  return const LoadingIndicator();
                }

                if (state is BudsSearchResults) {
                  if (state.buds.isEmpty) {
                    return EmptyState(
                      icon: Icons.search_off,
                      title: 'No Buds Found',
                      message: 'Try a different search term',
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(DesignSystem.spacingMD),
                    itemCount: state.buds.length,
                    itemBuilder: (context, index) {
                      final budData = state.buds[index];
                      final budMatch = budData is Map<String, dynamic>
                          ? BudMatch.fromJson(budData)
                          : budData as BudMatch;

                      return BudMatchListItem(budMatch: budMatch);
                    },
                  );
                }

                if (state is BudMatchingError) {
                  return EmptyState(
                    icon: Icons.error_outline,
                    title: 'Search Failed',
                    message: state.message,
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