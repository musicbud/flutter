import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// Chip variant types
enum ChipVariant {
  filled,
  outlined,
  elevated,
}

/// A customizable chip widget for tags, filters, and selections.
///
/// Supports:
/// - Multiple variants (filled, outlined, elevated)
/// - Selection state
/// - Delete/close button
/// - Leading icon or avatar
/// - Custom colors
/// - Tap and delete callbacks
///
/// Example:
/// ```dart
/// Chip(
///   label: 'Rock Music',
///   selected: isSelected,
///   onTap: () => toggleSelection('rock'),
///   onDeleted: () => removeFilter('rock'),
/// )
/// ```
class ModernChip extends StatelessWidget {
  const ModernChip({
    super.key,
    required this.label,
    this.variant = ChipVariant.filled,
    this.selected = false,
    this.onTap,
    this.onDeleted,
    this.leadingIcon,
    this.avatar,
    this.backgroundColor,
    this.selectedColor,
    this.textColor,
    this.deleteIcon,
    this.padding,
  });

  final String label;
  final ChipVariant variant;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onDeleted;
  final IconData? leadingIcon;
  final Widget? avatar;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? textColor;
  final IconData? deleteIcon;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: padding ??
              EdgeInsets.symmetric(
                horizontal: design?.designSystemSpacing.md ?? 12,
                vertical: design?.designSystemSpacing.sm ?? 8,
              ),
          decoration: _getDecoration(design, theme),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (avatar != null) ...[
                avatar!,
                SizedBox(width: design?.designSystemSpacing.xs ?? 4),
              ],
              if (leadingIcon != null) ...[
                Icon(
                  leadingIcon,
                  size: 16,
                  color: _getContentColor(design, theme),
                ),
                SizedBox(width: design?.designSystemSpacing.xs ?? 4),
              ],
              Text(
                label,
                style: (design?.designSystemTypography.bodySmall ??
                        theme.textTheme.bodySmall)
                    ?.copyWith(
                  color: _getContentColor(design, theme),
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (onDeleted != null) ...[
                SizedBox(width: design?.designSystemSpacing.xs ?? 4),
                GestureDetector(
                  onTap: onDeleted,
                  child: Icon(
                    deleteIcon ?? Icons.close,
                    size: 16,
                    color: _getContentColor(design, theme),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _getDecoration(
    DesignSystemThemeExtension? design,
    ThemeData theme,
  ) {
    final bgColor = selected
        ? (selectedColor ??
            design?.designSystemColors.primaryRed ??
            theme.colorScheme.primary)
        : (backgroundColor ??
            design?.designSystemColors.surfaceDark ??
            theme.colorScheme.surfaceContainerHighest);

    switch (variant) {
      case ChipVariant.filled:
        return BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        );
      case ChipVariant.outlined:
        return BoxDecoration(
          color: selected ? bgColor : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? (selectedColor ??
                    design?.designSystemColors.primaryRed ??
                    theme.colorScheme.primary)
                : (design?.designSystemColors.textMuted ?? theme.dividerColor),
            width: 1.5,
          ),
        );
      case ChipVariant.elevated:
        return BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: selected
              ? design?.designSystemShadows.medium ??
                  [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]
              : design?.designSystemShadows.small ??
                  [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    )
                  ],
        );
    }
  }

  Color _getContentColor(
    DesignSystemThemeExtension? design,
    ThemeData theme,
  ) {
    if (textColor != null) return textColor!;

    if (selected) {
      return design?.designSystemColors.white ?? Colors.white;
    }

    return design?.designSystemColors.textPrimary ?? theme.colorScheme.onSurface;
  }
}

/// Filter chip for search and filtering
class FilterChip extends StatelessWidget {
  const FilterChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;

  @override
  Widget build(BuildContext context) {
    return ModernChip(
      label: label,
      variant: ChipVariant.outlined,
      selected: selected,
      onTap: onSelected != null ? () => onSelected!(!selected) : null,
    );
  }
}

/// Choice chip for single selection
class ChoiceChip extends StatelessWidget {
  const ChoiceChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onSelected,
    this.leadingIcon,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    return ModernChip(
      label: label,
      variant: ChipVariant.filled,
      selected: selected,
      leadingIcon: leadingIcon,
      onTap: onSelected != null ? () => onSelected!(!selected) : null,
    );
  }
}

/// Input chip with delete capability
class InputChip extends StatelessWidget {
  const InputChip({
    super.key,
    required this.label,
    this.onDeleted,
    this.onTap,
    this.avatar,
  });

  final String label;
  final VoidCallback? onDeleted;
  final VoidCallback? onTap;
  final Widget? avatar;

  @override
  Widget build(BuildContext context) {
    return ModernChip(
      label: label,
      variant: ChipVariant.filled,
      avatar: avatar,
      onTap: onTap,
      onDeleted: onDeleted,
    );
  }
}

/// Action chip for actions
class ActionChip extends StatelessWidget {
  const ActionChip({
    super.key,
    required this.label,
    this.onPressed,
    this.leadingIcon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    return ModernChip(
      label: label,
      variant: ChipVariant.elevated,
      leadingIcon: leadingIcon,
      onTap: onPressed,
    );
  }
}

/// Chip group for displaying multiple chips
class ChipGroup extends StatelessWidget {
  const ChipGroup({
    super.key,
    required this.children,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.alignment = WrapAlignment.start,
  });

  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      alignment: alignment,
      children: children,
    );
  }
}
