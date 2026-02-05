import 'package:flutter/material.dart';
import 'package:musicbud_flutter/core/theme/design_system.dart';

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

    if (label == null && description == null) {
      return _buildSwitch(theme);
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
                  style: DesignSystem.bodyMedium,
                ),
              if (description != null) ...[
                const SizedBox(height: DesignSystem.spacingXS),
                Text(
                  description!,
                  style: (DesignSystem.bodySmall).copyWith(
                    color: DesignSystem.textMuted,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: DesignSystem.spacingMD),
        _buildSwitch(theme),
      ],
    );
  }

  Widget _buildSwitch(ThemeData theme) {
    switch (style) {
      case ToggleStyle.material:
        return Switch(
          value: value,
          onChanged: onChanged,
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return DesignSystem.primary;
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
              return DesignSystem.primary;
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
    final active = activeColor ?? DesignSystem.primary;
    final inactive = inactiveColor ?? DesignSystem.surfaceContainer;

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
            color: value ? active : (DesignSystem.border),
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
                  color: Colors.black.withAlpha(51),
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
    final itemSpacing = spacing ?? DesignSystem.spacingMD;

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
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
      child: Padding(
        padding: const EdgeInsets.all(DesignSystem.spacingSM),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 24,
                color: DesignSystem.onSurfaceVariant,
              ),
              const SizedBox(width: DesignSystem.spacingMD),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: DesignSystem.bodyMedium,
                  ),
                  if (description != null) ...[
                    const SizedBox(height: DesignSystem.spacingXS),
                    Text(
                      description!,
                      style: (DesignSystem.bodySmall).copyWith(
                        color: DesignSystem.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: DesignSystem.spacingMD),
            Switch.adaptive(
              value: value,
              onChanged: onChanged,
              thumbColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return DesignSystem.primary;
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
    final active = activeColor ?? DesignSystem.primary;
    final inactive = inactiveColor ?? DesignSystem.surfaceContainer;

    return Material(
      color: value ? active : inactive,
      borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignSystem.spacingMD,
            vertical: DesignSystem.spacingSM,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 20,
                  color: value ? Colors.white : (DesignSystem.onSurfaceVariant),
                ),
                if (label != null) const SizedBox(width: DesignSystem.spacingXS),
              ],
              if (label != null)
                Text(
                  label!,
                  style: (DesignSystem.bodySmall).copyWith(
                    color: value ? Colors.white : (DesignSystem.onSurfaceVariant),
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
    return Material(
      color: value
          ? DesignSystem.primary.withAlpha(25)
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
                ? DesignSystem.primary
                : DesignSystem.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}