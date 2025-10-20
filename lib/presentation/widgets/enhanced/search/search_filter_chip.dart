import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// A filter chip widget for search and discovery screens
/// 
/// Provides a toggleable chip UI for filtering content by categories,
/// genres, or other attributes.
/// 
/// Example:
/// ```dart
/// Wrap(
///   spacing: 8,
///   runSpacing: 8,
///   children: [
///     SearchFilterChip(
///       label: 'Rock',
///       selected: selectedGenre == 'Rock',
///       icon: Icons.music_note,
///       onSelected: (selected) {
///         setState(() => selectedGenre = selected ? 'Rock' : null);
///       },
///     ),
///     SearchFilterChip(
///       label: 'Pop',
///       selected: selectedGenre == 'Pop',
///       icon: Icons.music_note,
///       onSelected: (selected) {
///         setState(() => selectedGenre = selected ? 'Pop' : null);
///       },
///     ),
///   ],
/// )
/// ```
class SearchFilterChip extends StatelessWidget {
  /// The label text to display
  final String label;

  /// Whether the chip is selected
  final bool selected;

  /// Callback when chip selection changes
  final ValueChanged<bool>? onSelected;

  /// Optional icon to display before label
  final IconData? icon;

  /// Custom background color when not selected
  final Color? backgroundColor;

  /// Custom background color when selected
  final Color? selectedColor;

  /// Custom text color when not selected
  final Color? labelColor;

  /// Custom text color when selected
  final Color? selectedLabelColor;

  const SearchFilterChip({
    super.key,
    required this.label,
    required this.selected,
    this.onSelected,
    this.icon,
    this.backgroundColor,
    this.selectedColor,
    this.labelColor,
    this.selectedLabelColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? DesignSystem.surface;
    final effectiveSelectedColor = selectedColor ?? DesignSystem.primary;
    final effectiveLabelColor = labelColor ?? DesignSystem.onSurface;
    final effectiveSelectedLabelColor = selectedLabelColor ?? DesignSystem.onPrimary;

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: selected ? effectiveSelectedLabelColor : effectiveLabelColor,
            ),
            const SizedBox(width: 4),
          ],
          Text(label),
        ],
      ),
      selected: selected,
      onSelected: onSelected,
      showCheckmark: false,
      backgroundColor: effectiveBackgroundColor,
      selectedColor: effectiveSelectedColor,
      labelStyle: TextStyle(
        color: selected ? effectiveSelectedLabelColor : effectiveLabelColor,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.spacingSM,
        vertical: DesignSystem.spacingXS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignSystem.radiusXL),
        side: BorderSide(
          color: selected ? effectiveSelectedColor : DesignSystem.border,
          width: selected ? 2 : 1,
        ),
      ),
    );
  }
}

/// A row of filter chips with common styling
/// 
/// Example:
/// ```dart
/// SearchFilterChipRow(
///   filters: [
///     FilterOption(label: 'All', value: null),
///     FilterOption(label: 'Rock', value: 'rock'),
///     FilterOption(label: 'Pop', value: 'pop'),
///   ],
///   selectedValue: selectedGenre,
///   onChanged: (value) => setState(() => selectedGenre = value),
/// )
/// ```
class SearchFilterChipRow<T> extends StatelessWidget {
  final List<FilterOption<T>> filters;
  final T? selectedValue;
  final ValueChanged<T?>? onChanged;

  const SearchFilterChipRow({
    super.key,
    required this.filters,
    required this.selectedValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingLG),
      child: Row(
        children: filters.asMap().entries.map((entry) {
          final index = entry.key;
          final filter = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              right: index < filters.length - 1 ? DesignSystem.spacingSM : 0,
            ),
            child: SearchFilterChip(
              label: filter.label,
              selected: selectedValue == filter.value,
              icon: filter.icon,
              onSelected: (selected) {
                if (onChanged != null) {
                  onChanged!(selected ? filter.value : null);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Model class for filter options
class FilterOption<T> {
  final String label;
  final T? value;
  final IconData? icon;

  const FilterOption({
    required this.label,
    required this.value,
    this.icon,
  });
}
