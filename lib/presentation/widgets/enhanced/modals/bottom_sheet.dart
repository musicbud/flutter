import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// A modern bottom sheet with consistent styling
///
/// Example:
/// ```dart
/// ModernBottomSheet.show(
///   context,
///   title: 'Options',
///   child: OptionsList(),
/// );
/// ```
class ModernBottomSheet extends StatelessWidget {
  /// Sheet title
  final String? title;

  /// Sheet content
  final Widget child;

  /// Whether to show close button
  final bool showCloseButton;

  /// Custom height
  final double? height;

  /// Whether to make it draggable
  final bool isDraggable;

  const ModernBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.showCloseButton = true,
    this.height,
    this.isDraggable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: DesignSystem.surfaceContainer,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DesignSystem.radiusLG),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          if (isDraggable)
            Container(
              margin: const EdgeInsets.only(top: DesignSystem.spacingSM),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: DesignSystem.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

          // Header
          if (title != null || showCloseButton)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignSystem.spacingLG,
                vertical: DesignSystem.spacingMD,
              ),
              child: Row(
                children: [
                  // Title
                  if (title != null)
                    Expanded(
                      child: Text(
                        title!,
                        style: DesignSystem.headlineSmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  // Close button
                  if (showCloseButton)
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      color: DesignSystem.onSurface,
                    ),
                ],
              ),
            ),

          // Divider
          if (title != null)
            Divider(
              color: DesignSystem.border,
              height: 1,
              thickness: 1,
            ),

          // Content
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }

  /// Show the bottom sheet
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    required Widget child,
    bool showCloseButton = true,
    double? height,
    bool isDraggable = true,
    bool isScrollControlled = false,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: isScrollControlled,
      builder: (context) => ModernBottomSheet(
        title: title,
        showCloseButton: showCloseButton,
        height: height,
        isDraggable: isDraggable,
        child: child,
      ),
    );
  }
}

/// An option item for bottom sheets
class BottomSheetOption extends StatelessWidget {
  /// Option icon
  final IconData icon;

  /// Option label
  final String label;

  /// Option subtitle/description
  final String? subtitle;

  /// Tap callback
  final VoidCallback onTap;

  /// Icon color
  final Color? iconColor;

  /// Whether this is a destructive action
  final bool isDestructive;

  const BottomSheetOption({
    super.key,
    required this.icon,
    required this.label,
    this.subtitle,
    required this.onTap,
    this.iconColor,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = isDestructive
        ? DesignSystem.error
        : iconColor ?? DesignSystem.onSurface;

    final effectiveTextColor =
        isDestructive ? DesignSystem.error : DesignSystem.onSurface;

    return InkWell(
      onTap: () {
        onTap();
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignSystem.spacingLG,
          vertical: DesignSystem.spacingMD,
        ),
        child: Row(
          children: [
            // Icon
            Icon(
              icon,
              color: effectiveIconColor,
              size: 24,
            ),
            const SizedBox(width: DesignSystem.spacingLG),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: DesignSystem.bodyLarge.copyWith(
                      color: effectiveTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: DesignSystem.bodySmall.copyWith(
                        color: DesignSystem.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Trailing arrow
            Icon(
              Icons.chevron_right,
              color: DesignSystem.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

/// A list of options in a bottom sheet
class BottomSheetOptionsList extends StatelessWidget {
  /// List of options
  final List<BottomSheetOption> options;

  /// Title for the options list
  final String? title;

  const BottomSheetOptionsList({
    super.key,
    required this.options,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: options,
      ),
    );
  }

  /// Show options bottom sheet
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required List<BottomSheetOption> options,
  }) {
    return ModernBottomSheet.show<T>(
      context,
      title: title,
      child: BottomSheetOptionsList(
        options: options,
        title: title,
      ),
    );
  }
}

/// A confirmation bottom sheet
class ConfirmationBottomSheet extends StatelessWidget {
  /// Confirmation title
  final String title;

  /// Confirmation message
  final String message;

  /// Confirm button label
  final String confirmLabel;

  /// Cancel button label
  final String cancelLabel;

  /// Confirm callback
  final VoidCallback onConfirm;

  /// Whether this is a destructive action
  final bool isDestructive;

  const ConfirmationBottomSheet({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    required this.onConfirm,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(DesignSystem.spacingLG),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: DesignSystem.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: DesignSystem.spacingMD),

          // Message
          Text(
            message,
            style: DesignSystem.bodyMedium.copyWith(
              color: DesignSystem.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: DesignSystem.spacingXL),

          // Buttons
          Row(
            children: [
              // Cancel button
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: DesignSystem.onSurface,
                    side: const BorderSide(color: DesignSystem.border),
                    padding: const EdgeInsets.symmetric(
                      vertical: DesignSystem.spacingMD,
                    ),
                  ),
                  child: Text(cancelLabel),
                ),
              ),
              const SizedBox(width: DesignSystem.spacingMD),

              // Confirm button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    onConfirm();
                    Navigator.pop(context, true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDestructive
                        ? DesignSystem.error
                        : DesignSystem.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: DesignSystem.spacingMD,
                    ),
                  ),
                  child: Text(confirmLabel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Show confirmation bottom sheet
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    required VoidCallback onConfirm,
    bool isDestructive = false,
  }) {
    return ModernBottomSheet.show<bool>(
      context,
      title: null,
      showCloseButton: false,
      child: ConfirmationBottomSheet(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: onConfirm,
        isDestructive: isDestructive,
      ),
    );
  }
}

/// A filter bottom sheet with multiple options
class FilterBottomSheet extends StatefulWidget {
  /// Filter title
  final String title;

  /// Available filter options
  final List<BottomSheetFilterOption> options;

  /// Initially selected filters
  final Set<String> initialSelection;

  /// Callback when filters are applied
  final void Function(Set<String> selected) onApply;

  const FilterBottomSheet({
    super.key,
    required this.title,
    required this.options,
    required this.initialSelection,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();

  /// Show filter bottom sheet
  static Future<Set<String>?> show(
    BuildContext context, {
    required String title,
    required List<BottomSheetFilterOption> options,
    required Set<String> initialSelection,
  }) {
    return ModernBottomSheet.show<Set<String>>(
      context,
      title: title,
      isScrollControlled: true,
      height: MediaQuery.of(context).size.height * 0.7,
      child: FilterBottomSheet(
        title: title,
        options: options,
        initialSelection: initialSelection,
        onApply: (selected) {
          Navigator.pop(context, selected);
        },
      ),
    );
  }
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.initialSelection);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter options list
        Expanded(
          child: ListView(
            children: widget.options.map((option) {
              final isSelected = _selected.contains(option.value);
              return CheckboxListTile(
                title: Text(option.label),
                subtitle: option.description != null
                    ? Text(option.description!)
                    : null,
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _selected.add(option.value);
                    } else {
                      _selected.remove(option.value);
                    }
                  });
                },
                activeColor: DesignSystem.primary,
              );
            }).toList(),
          ),
        ),

        // Apply button
        Padding(
          padding: const EdgeInsets.all(DesignSystem.spacingLG),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => widget.onApply(_selected),
              style: ElevatedButton.styleFrom(
                backgroundColor: DesignSystem.primary,
                foregroundColor: DesignSystem.onPrimary,
                padding: const EdgeInsets.symmetric(
                  vertical: DesignSystem.spacingMD,
                ),
              ),
              child: Text('Apply Filters (${_selected.length})'),
            ),
          ),
        ),
      ],
    );
  }
}

/// A filter option for the filter bottom sheet
class BottomSheetFilterOption {
  final String value;
  final String label;
  final String? description;

  const BottomSheetFilterOption({
    required this.value,
    required this.label,
    this.description,
  });
}
