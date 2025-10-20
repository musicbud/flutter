import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// Modern toggle switch with customizable styles
///
/// Supports:
/// - Material and iOS-style switches
/// - Custom colors and sizes
/// - Label and description text
/// - Disabled states
///
/// Example:
/// ```dart
/// ModernToggle(
///   value: isEnabled,
///   onChanged: (value) => setState(() => isEnabled = value),
///   label: 'Enable notifications',
/// )
/// ```
class ModernToggle extends StatelessWidget {
  const ModernToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.description,
    this.style = ToggleStyle.material,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final String? description;
  final ToggleStyle style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();

    if (label == null && description == null) {
      return _buildSwitch(theme, design);
    }

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (label != null)
                Text(
                  label!,
                  style: design?.designSystemTypography.bodyMedium ?? theme.textTheme.bodyMedium,
                ),
              if (description != null) ...[
                SizedBox(height: design?.designSystemSpacing.xs ?? 4),
                Text(
                  description!,
                  style: (design?.designSystemTypography.bodySmall ?? theme.textTheme.bodySmall)?.copyWith(
                    color: design?.designSystemColors.textMuted ?? theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(width: design?.designSystemSpacing.md ?? 12),
        _buildSwitch(theme, design),
      ],
    );
  }

  Widget _buildSwitch(ThemeData theme, DesignSystemThemeExtension? design) {
    switch (style) {
      case ToggleStyle.material:
        return Switch(
          value: value,
          onChanged: onChanged,
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return design?.designSystemColors.primary ?? theme.colorScheme.primary;
            }
            return null;
          }),
        );
      case ToggleStyle.adaptive:
        return Switch.adaptive(
          value: value,
          onChanged: onChanged,
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return design?.designSystemColors.primary ?? theme.colorScheme.primary;
            }
            return null;
          }),
        );
      case ToggleStyle.custom:
        return CustomToggle(
          value: value,
          onChanged: onChanged,
        );
    }
  }
}

enum ToggleStyle {
  material,
  adaptive,
  custom,
}

/// Custom styled toggle switch
class CustomToggle extends StatelessWidget {
  const CustomToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = 50.0,
    this.height = 30.0,
    this.activeColor,
    this.inactiveColor,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final double width;
  final double height;
  final Color? activeColor;
  final Color? inactiveColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();
    final active = activeColor ?? design?.designSystemColors.primary ?? theme.colorScheme.primary;
    final inactive = inactiveColor ?? design?.designSystemColors.surfaceContainer ?? theme.colorScheme.surfaceContainerHighest;

    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: value ? active : inactive,
          borderRadius: BorderRadius.circular(height / 2),
          border: Border.all(
            color: value ? active : (design?.designSystemColors.border ?? theme.colorScheme.outline),
            width: 2,
          ),
        ),
        padding: const EdgeInsets.all(2),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: height - 8,
            height: height - 8,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Toggle group for multiple options
class ToggleGroup extends StatelessWidget {
  const ToggleGroup({
    super.key,
    required this.items,
    this.spacing,
  });

  final List<ToggleItem> items;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    final design = Theme.of(context).extension<DesignSystemThemeExtension>();
    final itemSpacing = spacing ?? design?.designSystemSpacing.md ?? 12;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < items.length; i++) ...[
          items[i],
          if (i < items.length - 1) SizedBox(height: itemSpacing),
        ],
      ],
    );
  }
}

/// Single item in a toggle group
class ToggleItem extends StatelessWidget {
  const ToggleItem({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.description,
    this.icon,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? description;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();

    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(design?.designSystemRadius.md ?? 8),
      child: Padding(
        padding: EdgeInsets.all(design?.designSystemSpacing.sm ?? 8),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 24,
                color: design?.designSystemColors.onSurfaceVariant ?? theme.colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: design?.designSystemSpacing.md ?? 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: design?.designSystemTypography.bodyMedium ?? theme.textTheme.bodyMedium,
                  ),
                  if (description != null) ...[
                    SizedBox(height: design?.designSystemSpacing.xs ?? 4),
                    Text(
                      description!,
                      style: (design?.designSystemTypography.bodySmall ?? theme.textTheme.bodySmall)?.copyWith(
                        color: design?.designSystemColors.textMuted ?? theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: design?.designSystemSpacing.md ?? 12),
            Switch.adaptive(
              value: value,
              onChanged: onChanged,
              thumbColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return design?.designSystemColors.primary ?? theme.colorScheme.primary;
                }
                return null;
              }),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact toggle button
class ToggleButton extends StatelessWidget {
  const ToggleButton({
    super.key,
    required this.value,
    required this.onChanged,
    this.icon,
    this.label,
    this.activeColor,
    this.inactiveColor,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData? icon;
  final String? label;
  final Color? activeColor;
  final Color? inactiveColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();
    final active = activeColor ?? design?.designSystemColors.primary ?? theme.colorScheme.primary;
    final inactive = inactiveColor ?? design?.designSystemColors.surfaceContainer ?? theme.colorScheme.surfaceContainerHighest;

    return Material(
      color: value ? active : inactive,
      borderRadius: BorderRadius.circular(design?.designSystemRadius.md ?? 8),
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(design?.designSystemRadius.md ?? 8),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: design?.designSystemSpacing.md ?? 12,
            vertical: design?.designSystemSpacing.sm ?? 8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 20,
                  color: value ? Colors.white : (design?.designSystemColors.onSurfaceVariant ?? theme.colorScheme.onSurfaceVariant),
                ),
                if (label != null) SizedBox(width: design?.designSystemSpacing.xs ?? 4),
              ],
              if (label != null)
                Text(
                  label!,
                  style: (design?.designSystemTypography.bodySmall ?? theme.textTheme.bodySmall)?.copyWith(
                    color: value ? Colors.white : (design?.designSystemColors.onSurfaceVariant ?? theme.colorScheme.onSurfaceVariant),
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Icon toggle button
class IconToggle extends StatelessWidget {
  const IconToggle({
    super.key,
    required this.value,
    required this.onChanged,
    required this.icon,
    this.activeIcon,
    this.size = 40.0,
    this.iconSize = 24.0,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData icon;
  final IconData? activeIcon;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();

    return Material(
      color: value
          ? (design?.designSystemColors.primary ?? theme.colorScheme.primary).withValues(alpha: 0.1)
          : Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: () => onChanged(!value),
        customBorder: const CircleBorder(),
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          child: Icon(
            value && activeIcon != null ? activeIcon : icon,
            size: iconSize,
            color: value
                ? (design?.designSystemColors.primary ?? theme.colorScheme.primary)
                : (design?.designSystemColors.onSurfaceVariant ?? theme.colorScheme.onSurfaceVariant),
          ),
        ),
      ),
    );
  }
}
