import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';

/// A reusable overlay widget for media cards.
/// Displays a gradient overlay with an optional play button.
class MediaCardOverlay extends StatelessWidget {
  /// Whether to show the overlay
  final bool show;

  /// Custom play button widget (if null, uses default circular play button)
  final Widget? playButton;

  /// Border radius for the overlay
  final BorderRadius? borderRadius;

  const MediaCardOverlay({
    super.key,
    this.show = false,
    this.playButton,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    if (!show) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(DesignSystem.radiusMD),
        gradient: DesignSystem.gradientCard,
      ),
      child: Center(
        child: playButton ?? _buildDefaultPlayButton(),
      ),
    );
  }

  Widget _buildDefaultPlayButton() {
    return const SizedBox(
      width: 56,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: DesignSystem.primary,
        ),
        child: Icon(
          Icons.play_arrow_rounded,
          size: 32,
          color: DesignSystem.onPrimary,
        ),
      ),
    );
  }
}