import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';
import 'widgets/category_filter_widget.dart';

// Enhanced UI Library
import '../../widgets/enhanced/enhanced_widgets.dart';

class DiscoverSearchSection extends StatefulWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;
  final Function(String) onSearch;

  const DiscoverSearchSection({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onSearch,
  });

  @override
  State<DiscoverSearchSection> createState() => _DiscoverSearchSectionState();
}

class _DiscoverSearchSectionState extends State<DiscoverSearchSection> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header Section
        Container(
          padding: const EdgeInsets.all(DesignSystem.spacingLG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Discover Music',
                style: DesignSystem.headlineMedium.copyWith(
                  color: DesignSystem.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: DesignSystem.spacingSM),
              Text(
                'Find your next favorite track',
                style: DesignSystem.bodyMedium.copyWith(
                  color: DesignSystem.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        // Search Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingLG),
          child: ModernInputField(
            hintText: 'Search for artists, tracks, or genres...',
            controller: _searchController,
            onChanged: widget.onSearch,
            size: ModernInputFieldSize.large,
          ),
        ),

        const SizedBox(height: DesignSystem.spacingLG),

        // Categories Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingLG),
          child: CategoryFilterWidget(
            selectedCategory: widget.selectedCategory,
            categories: const [
              'All',
              'Pop',
              'Rock',
              'Hip Hop',
              'Electronic',
              'Jazz',
              'Classical',
              'Country',
            ],
            onCategorySelected: widget.onCategorySelected,
          ),
        ),

        const SizedBox(height: DesignSystem.spacingXL),
      ],
    );
  }
}