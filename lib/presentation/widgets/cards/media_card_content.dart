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
    final designSystem = Theme.of(context).designSystem!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          title,
          style: designSystem.designSystemTypography.titleMedium.copyWith(
            color: designSystem.designSystemColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        // Subtitle
        if (subtitle != null) ...[
          SizedBox(height: designSystem.designSystemSpacing.xs),
          Text(
            subtitle!,
            style: designSystem.designSystemTypography.bodySmall.copyWith(
              color: designSystem.designSystemColors.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}