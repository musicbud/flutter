import 'package:flutter/material.dart';
import '../base/base_card.dart';
import '../../../core/theme/design_system.dart';

/// A reusable stat card widget for displaying profile statistics.
/// Commonly used for showing counts like followers, following, tracks, etc.
///
/// Features:
/// - Icon with customizable size and color
/// - Value display with proper formatting
/// - Label text for context
/// - Consistent theming and spacing
/// - Optional tap gesture support
class StatCard extends BaseCard {
  /// The icon to display (e.g., Icons.person, Icons.music_note)
  final IconData icon;

  /// The numeric value to display (e.g., 123, 4567)
  final int value;

  /// The label text (e.g., "Followers", "Tracks", "Playlists")
  final String label;

  /// Size of the icon (defaults to 24)
  final double iconSize;

  /// Color of the icon (defaults to theme's onSurfaceVariant)
  final Color? iconColor;

  /// Text style for the value text
  final TextStyle? valueStyle;

  /// Text style for the label text
  final TextStyle? labelStyle;

  const StatCard({
    super.key,
    super.onTap,
    super.padding,
    super.backgroundColor,
    super.borderRadius,
    super.showElevation,
    super.elevation,
    required this.icon,
    required this.value,
    required this.label,
    this.iconSize = 24,
    this.iconColor,
    this.valueStyle,
    this.labelStyle,
  });

  @override
  Widget buildCard(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
          style: valueStyle ?? DesignSystem.titleLarge.copyWith(
            color: DesignSystem.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: DesignSystem.spacingXXS),

        // Label
        Text(
          label,
          style: labelStyle ?? DesignSystem.bodySmall.copyWith(
            color: DesignSystem.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Formats the numeric value for display
  /// Examples: 1234 -> "1.2K", 1234567 -> "1.2M"
  String _formatValue(int value) {
    if (value < 1000) {
      return value.toString();
    } else if (value < 1000000) {
      final thousands = (value / 1000).toStringAsFixed(1);
      return '${thousands}K';
    } else {
      final millions = (value / 1000000).toStringAsFixed(1);
      return '${millions}M';
    }
  }
}
