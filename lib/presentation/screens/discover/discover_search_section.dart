import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/common/index.dart';
import 'widgets/category_filter_widget.dart';

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
    final appTheme = AppTheme.of(context);

    return Column(
      children: [
        // Header Section
        Container(
          padding: EdgeInsets.all(appTheme.spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Discover Music',
                style: appTheme.typography.headlineH5.copyWith(
                  color: appTheme.colors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: appTheme.spacing.sm),
              Text(
                'Find your next favorite track',
                style: appTheme.typography.bodyMedium.copyWith(
                  color: appTheme.colors.textMuted,
                ),
              ),
            ],
          ),
        ),

        // Search Section
        Padding(
          padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
          child: ModernInputField(
            hintText: 'Search for artists, tracks, or genres...',
            controller: _searchController,
            onChanged: widget.onSearch,
            size: ModernInputFieldSize.large,
          ),
        ),

        SizedBox(height: appTheme.spacing.lg),

        // Categories Section
        Padding(
          padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
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

        SizedBox(height: appTheme.spacing.xl),
      ],
    );
  }
}