import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// Abstract base class for all card widgets in the application.
/// Provides common functionality and consistent styling patterns.
///
/// **Common Properties:**
/// - [onTap] - Callback when card is tapped
/// - [padding] - Internal padding for card content
/// - [shape] - Shape/border radius for the card
/// - [backgroundColor] - Background color for the card
///
/// **Common Methods:**
/// - [buildCard] - Main card building logic (must be implemented)
/// - [_getDefaultShape] - Default shape for cards
/// - [_getDefaultPadding] - Default padding for cards
///
/// **Usage:**
/// ```dart
/// class CustomCard extends BaseCard {
///   const CustomCard({super.key, super.onTap, super.padding});
///
///   @override
///   Widget buildCard(BuildContext context) {
///     return Column(
///       children: [
///         // Custom card content
///       ],
///     );
///   }
/// }
/// ```
abstract class BaseCard extends StatelessWidget {
  /// Callback when the card is tapped
  final VoidCallback? onTap;

  /// Internal padding for card content
  final EdgeInsetsGeometry? padding;

  /// Shape/border radius for the card
  final ShapeBorder? shape;

  /// Background color for the card
  final Color? backgroundColor;

  /// Border radius for the card (alternative to shape)
  final BorderRadius? borderRadius;

  /// Whether to show elevation/shadow
  final bool showElevation;

  /// Elevation value for the card
  final double elevation;

  /// Constructor for BaseCard
  const BaseCard({
    super.key,
    this.onTap,
    this.padding,
    this.shape,
    this.backgroundColor,
    this.borderRadius,
    this.showElevation = false,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: showElevation ? elevation : 0,
      shape: shape ?? _getDefaultShape(context),
      color: backgroundColor ?? DesignSystem.surfaceContainer,
      child: InkWell(
        onTap: onTap,
        borderRadius: _getBorderRadius(context),
        child: Padding(
          padding: padding ?? _getDefaultPadding(context),
          child: buildCard(context),
        ),
      ),
    );
  }

  /// Main card building logic - must be implemented by subclasses
  /// This method should return the primary content of the card
  @protected
  Widget buildCard(BuildContext context);

  /// Get the default shape for the card
  /// Can be overridden by subclasses for custom shapes
  @protected
  ShapeBorder _getDefaultShape(BuildContext context) {
    return RoundedRectangleBorder(
      borderRadius: borderRadius ?? BorderRadius.circular(DesignSystem.radiusLg),
    );
  }

  /// Get the default padding for the card
  /// Can be overridden by subclasses for custom padding
  @protected
  EdgeInsetsGeometry _getDefaultPadding(BuildContext context) {
    return const EdgeInsets.all(DesignSystem.spacingMD);
  }

  /// Get the border radius for the InkWell
  /// Uses the shape's border radius if available, otherwise uses default
  @protected
  BorderRadius? _getBorderRadius(BuildContext context) {
    final shape = this.shape ?? _getDefaultShape(context);

    if (shape is RoundedRectangleBorder) {
      return shape.borderRadius as BorderRadius?;
    }

    return borderRadius ?? BorderRadius.circular(DesignSystem.radiusLg);
  }
}