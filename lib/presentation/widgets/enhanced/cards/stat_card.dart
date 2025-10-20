import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// A card widget for displaying profile statistics
/// 
/// Perfect for showing counts like followers, tracks, playlists, etc.
/// Automatically formats large numbers (1.2K, 1.5M).
/// 
/// Example:
/// ```dart
/// Row(
///   children: [
///     Expanded(
///       child: StatCard(
///         icon: Icons.people,
///         value: 1234,
///         label: 'Followers',
///         onTap: () => showFollowers(),
///       ),
///     ),
///     Expanded(
///       child: StatCard(
///         icon: Icons.music_note,
///         value: 567,
///         label: 'Tracks',
///       ),
///     ),
///   ],
/// )
/// ```
class StatCard extends StatelessWidget {
  /// The icon to display (e.g., Icons.person, Icons.music_note)
  final IconData icon;

  /// The numeric value to display (e.g., 123, 4567)
  final int value;

  /// The label text (e.g., "Followers", "Tracks", "Playlists")
  final String label;

  /// Size of the icon (defaults to 24)
  final double iconSize;

  /// Color of the icon (defaults to onSurfaceVariant)
  final Color? iconColor;

  /// Text style for the value text
  final TextStyle? valueStyle;

  /// Text style for the label text
  final TextStyle? labelStyle;

  /// Optional tap callback
  final VoidCallback? onTap;

  /// Padding inside the card
  final EdgeInsetsGeometry? padding;

  /// Background color of the card
  final Color? backgroundColor;

  /// Border radius of the card
  final double? borderRadius;

  /// Whether to show elevation
  final bool showElevation;

  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.iconSize = 24,
    this.iconColor,
    this.valueStyle,
    this.labelStyle,
    this.onTap,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.showElevation = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: padding ?? const EdgeInsets.all(DesignSystem.spacingMD),
      decoration: BoxDecoration(
        color: backgroundColor ?? DesignSystem.surfaceContainer,
        borderRadius: BorderRadius.circular(borderRadius ?? DesignSystem.radiusMD),
        boxShadow: showElevation
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Icon(
            icon,
            size: iconSize,
            color: iconColor ?? DesignSystem.onSurfaceVariant,
          ),

          const SizedBox(height: DesignSystem.spacingXS),

          // Value
          Text(
            _formatValue(value),
            style: valueStyle ??
                DesignSystem.titleLarge.copyWith(
                  color: DesignSystem.onSurface,
                  fontWeight: FontWeight.w700,
                ),
          ),

          const SizedBox(height: 2),

          // Label
          Text(
            label,
            style: labelStyle ??
                DesignSystem.bodySmall.copyWith(
                  color: DesignSystem.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius ?? DesignSystem.radiusMD),
        child: content,
      );
    }

    return content;
  }

  /// Formats the numeric value for display
  /// Examples: 1234 -> "1.2K", 1234567 -> "1.2M"
  String _formatValue(int value) {
    if (value < 1000) {
      return value.toString();
    } else if (value < 1000000) {
      final thousands = (value / 1000).toStringAsFixed(1);
      // Remove trailing .0
      if (thousands.endsWith('.0')) {
        return '${thousands.substring(0, thousands.length - 2)}K';
      }
      return '${thousands}K';
    } else {
      final millions = (value / 1000000).toStringAsFixed(1);
      // Remove trailing .0
      if (millions.endsWith('.0')) {
        return '${millions.substring(0, millions.length - 2)}M';
      }
      return '${millions}M';
    }
  }
}
