import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';

/// A reusable content widget for media cards.
/// Displays title and subtitle text with consistent styling.
class MediaCardContent extends StatelessWidget {
  /// The title text (e.g., song name, artist name, playlist name)
  final String title;

  /// The subtitle text (e.g., artist name, track count, description)
  final String? subtitle;

  const MediaCardContent({
    super.key,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          title,
          style: DesignSystem.titleMedium.copyWith(
            color: DesignSystem.onSurface,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        // Subtitle
        if (subtitle != null) ...[
          const SizedBox(height: DesignSystem.spacingXS),
          Text(
            subtitle!,
            style: DesignSystem.bodySmall.copyWith(
              color: DesignSystem.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
