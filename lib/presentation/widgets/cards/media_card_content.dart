import 'package:flutter/material.dart';
import '../base/base_card.dart';

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
          style: BaseCard.getDesignSystemTypography(context).titleMedium.copyWith(
            color: BaseCard.getDesignSystemColors(context).onSurface,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        // Subtitle
        if (subtitle != null) ...[
          SizedBox(height: BaseCard.getDesignSystemSpacing(context).xs),
          Text(
            subtitle!,
            style: BaseCard.getDesignSystemTypography(context).bodySmall.copyWith(
              color: BaseCard.getDesignSystemColors(context).onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  // Static helper methods to access BaseCard helpers
  static DesignSystemColors getDesignSystemColors(BuildContext context) {
    return Theme.of(context).extension<DesignSystemThemeExtension>()!.designSystemColors;
  }

  static DesignSystemTypography getDesignSystemTypography(BuildContext context) {
    return Theme.of(context).extension<DesignSystemThemeExtension>()!.designSystemTypography;
  }

  static DesignSystemSpacing getDesignSystemSpacing(BuildContext context) {
    return Theme.of(context).extension<DesignSystemThemeExtension>()!.designSystemSpacing;
  }
}