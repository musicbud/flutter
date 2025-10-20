import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// A horizontal scrolling list with section header and "See All" action
///
/// Displays items in a horizontal scroll view with an optional title and
/// action button. Perfect for showcasing categories, featured content, etc.
///
/// Example:
/// ```dart
/// HorizontalList(
///   title: 'Recently Played',
///   itemCount: albums.length,
///   itemBuilder: (context, index) => MediaCard.album(
///     imageUrl: albums[index].artworkUrl,
///     title: albums[index].title,
///     artist: albums[index].artist,
///     onTap: () => navigateToAlbum(albums[index]),
///   ),
///   onSeeAll: () => navigateToAllAlbums(),
/// )
/// ```
class HorizontalList extends StatelessWidget {
  /// Section title
  final String? title;

  /// Number of items in the list
  final int itemCount;

  /// Builder function for each item
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// "See All" button callback
  final VoidCallback? onSeeAll;

  /// Item width (if null, items take their natural width)
  final double? itemWidth;

  /// Item height
  final double? itemHeight;

  /// Spacing between items
  final double spacing;

  /// Padding around the list
  final EdgeInsetsGeometry? padding;

  /// Whether to show the title row
  final bool showTitle;

  /// Custom title widget (overrides title string)
  final Widget? titleWidget;

  /// "See All" button text
  final String seeAllText;

  const HorizontalList({
    super.key,
    this.title,
    required this.itemCount,
    required this.itemBuilder,
    this.onSeeAll,
    this.itemWidth,
    this.itemHeight,
    this.spacing = DesignSystem.spacingMD,
    this.padding,
    this.showTitle = true,
    this.titleWidget,
    this.seeAllText = 'See All',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Row
        if (showTitle && (title != null || titleWidget != null))
          _buildTitleRow(),

        // Horizontal List
        SizedBox(
          height: itemHeight,
          child: ListView.separated(
            padding: padding ??
                const EdgeInsets.symmetric(
                  horizontal: DesignSystem.spacingLG,
                ),
            scrollDirection: Axis.horizontal,
            itemCount: itemCount,
            separatorBuilder: (context, index) => SizedBox(width: spacing),
            itemBuilder: (context, index) {
              final item = itemBuilder(context, index);
              if (itemWidth != null) {
                return SizedBox(width: itemWidth, child: item);
              }
              return item;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTitleRow() {
    return Padding(
      padding: const EdgeInsets.only(
        left: DesignSystem.spacingLG,
        right: DesignSystem.spacingLG,
        bottom: DesignSystem.spacingMD,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title
          Expanded(
            child: titleWidget ??
                Text(
                  title!,
                  style: DesignSystem.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),

          // See All Button
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              style: TextButton.styleFrom(
                foregroundColor: DesignSystem.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignSystem.spacingMD,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    seeAllText,
                    style: DesignSystem.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// Factory for a compact list (smaller items)
  factory HorizontalList.compact({
    String? title,
    required int itemCount,
    required Widget Function(BuildContext context, int index) itemBuilder,
    VoidCallback? onSeeAll,
    EdgeInsetsGeometry? padding,
    String seeAllText = 'See All',
  }) {
    return HorizontalList(
      title: title,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      onSeeAll: onSeeAll,
      itemWidth: 120,
      itemHeight: 180,
      spacing: DesignSystem.spacingSM,
      padding: padding,
      seeAllText: seeAllText,
    );
  }

  /// Factory for a standard list (medium items)
  factory HorizontalList.standard({
    String? title,
    required int itemCount,
    required Widget Function(BuildContext context, int index) itemBuilder,
    VoidCallback? onSeeAll,
    EdgeInsetsGeometry? padding,
    String seeAllText = 'See All',
  }) {
    return HorizontalList(
      title: title,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      onSeeAll: onSeeAll,
      itemWidth: 160,
      itemHeight: 220,
      spacing: DesignSystem.spacingMD,
      padding: padding,
      seeAllText: seeAllText,
    );
  }

  /// Factory for a large list (bigger items)
  factory HorizontalList.large({
    String? title,
    required int itemCount,
    required Widget Function(BuildContext context, int index) itemBuilder,
    VoidCallback? onSeeAll,
    EdgeInsetsGeometry? padding,
    String seeAllText = 'See All',
  }) {
    return HorizontalList(
      title: title,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      onSeeAll: onSeeAll,
      itemWidth: 200,
      itemHeight: 280,
      spacing: DesignSystem.spacingLG,
      padding: padding,
      seeAllText: seeAllText,
    );
  }
}

/// A simplified horizontal list for chips/tags
class HorizontalChipList extends StatelessWidget {
  /// List of chip labels
  final List<String> items;

  /// Selected items (for multi-select)
  final Set<String>? selectedItems;

  /// Callback when an item is tapped
  final void Function(String item)? onTap;

  /// Chip background color
  final Color? chipColor;

  /// Selected chip color
  final Color? selectedChipColor;

  /// Padding around the list
  final EdgeInsetsGeometry? padding;

  const HorizontalChipList({
    super.key,
    required this.items,
    this.selectedItems,
    this.onTap,
    this.chipColor,
    this.selectedChipColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: padding ??
            const EdgeInsets.symmetric(horizontal: DesignSystem.spacingLG),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: DesignSystem.spacingSM),
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = selectedItems?.contains(item) ?? false;

          return FilterChip(
            label: Text(item),
            selected: isSelected,
            onSelected: onTap != null ? (_) => onTap!(item) : null,
            backgroundColor: chipColor ?? DesignSystem.surfaceContainer,
            selectedColor:
                selectedChipColor ?? DesignSystem.primaryContainer,
            labelStyle: TextStyle(
              color: isSelected
                  ? DesignSystem.onPrimary
                  : DesignSystem.onSurface,
            ),
          );
        },
      ),
    );
  }
}

/// A horizontal list with page snapping effect
class SnapHorizontalList extends StatelessWidget {
  /// Section title
  final String? title;

  /// Number of items in the list
  final int itemCount;

  /// Builder function for each item
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// "See All" button callback
  final VoidCallback? onSeeAll;

  /// Item width
  final double itemWidth;

  /// Item height
  final double itemHeight;

  /// Viewport fraction (0.0 to 1.0)
  final double viewportFraction;

  const SnapHorizontalList({
    super.key,
    this.title,
    required this.itemCount,
    required this.itemBuilder,
    this.onSeeAll,
    this.itemWidth = 300,
    this.itemHeight = 200,
    this.viewportFraction = 0.85,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Row
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(
              left: DesignSystem.spacingLG,
              right: DesignSystem.spacingLG,
              bottom: DesignSystem.spacingMD,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title!,
                  style: DesignSystem.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (onSeeAll != null)
                  TextButton(
                    onPressed: onSeeAll,
                    child: const Text('See All'),
                  ),
              ],
            ),
          ),

        // Snapping PageView
        SizedBox(
          height: itemHeight,
          child: PageView.builder(
            controller: PageController(viewportFraction: viewportFraction),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignSystem.spacingSM,
                ),
                child: itemBuilder(context, index),
              );
            },
          ),
        ),
      ],
    );
  }
}
