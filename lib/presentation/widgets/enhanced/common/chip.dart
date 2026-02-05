import 'package:flutter/material.dart';
import 'package:musicbud_flutter/core/theme/design_system.dart';

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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: padding ??
              const EdgeInsets.symmetric(
                horizontal: DesignSystem.spacingMD,
                vertical: DesignSystem.spacingSM,
              ),
          decoration: _getDecoration(theme),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (avatar != null) ...[
                avatar!,
                const SizedBox(width: DesignSystem.spacingXS),
              ],
              if (leadingIcon != null) ...[
                Icon(
                  leadingIcon,
                  size: 16,
                  color: _getContentColor(theme),
                ),
                const SizedBox(width: DesignSystem.spacingXS),
              ],
              Text(
                label,
                style: (DesignSystem.bodySmall)
                    .copyWith(
                  color: _getContentColor(theme),
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (onDeleted != null) ...[
                const SizedBox(width: DesignSystem.spacingXS),
                GestureDetector(
                  onTap: onDeleted,
                  child: Icon(
                    deleteIcon ?? Icons.close,
                    size: 16,
                    color: _getContentColor(theme),
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
    ThemeData theme,
  ) {
    final bgColor = selected
        ? (selectedColor ??
            DesignSystem.primaryRed)
        : (backgroundColor ??
            DesignSystem.surfaceDark);

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
                    DesignSystem.primaryRed)
                : (DesignSystem.textMuted),
            width: 1.5,
          ),
        );
      case ChipVariant.elevated:
        return BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: selected
              ? DesignSystem.shadowMedium
              : DesignSystem.shadowSmall,
        );
    }
  }

  Color _getContentColor(
    ThemeData theme,
  ) {
    if (textColor != null) return textColor!;

    if (selected) {
      return DesignSystem.onPrimary;
    }

    return DesignSystem.textPrimary;
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