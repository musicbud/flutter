import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';

/// A reusable widget for common card action patterns.
/// Provides consistent styling and behavior for card action buttons.
///
/// Features:
/// - Like/favorite button with toggle state
/// - Share button with customizable action
/// - More options menu button
/// - Consistent spacing and styling
/// - Customizable icons and colors
/// - Accessibility support
class CardActions extends StatelessWidget {
  /// Whether the item is currently liked/favorited
  final bool isLiked;

  /// Callback when like button is pressed
  final VoidCallback? onLikePressed;

  /// Callback when share button is pressed
  final VoidCallback? onSharePressed;

  /// Callback when more options button is pressed
  final VoidCallback? onMorePressed;

  /// List of custom actions to show in the more menu
  final List<CardActionItem>? menuItems;

  /// Size of the action buttons
  final double buttonSize;

  /// Color of the like button when not liked
  final Color? likeButtonColor;

  /// Color of the like button when liked
  final Color? likedButtonColor;

  /// Color of the share button
  final Color? shareButtonColor;

  /// Color of the more button
  final Color? moreButtonColor;

  /// Icon size for action buttons
  final double iconSize;

  /// Spacing between action buttons
  final double spacing;

  /// Whether to show labels under the buttons
  final bool showLabels;

  /// Text style for the labels
  final TextStyle? labelStyle;

  /// Main axis alignment for the actions
  final MainAxisAlignment mainAxisAlignment;

  /// Whether to show a subtle background
  final bool showBackground;

  /// Background color for the actions container
  final Color? backgroundColor;

  /// Border radius for the background
  final BorderRadius? borderRadius;

  /// Padding for the actions container
  final EdgeInsetsGeometry? padding;

  const CardActions({
    super.key,
    this.isLiked = false,
    this.onLikePressed,
    this.onSharePressed,
    this.onMorePressed,
    this.menuItems,
    this.buttonSize = 40,
    this.likeButtonColor,
    this.likedButtonColor,
    this.shareButtonColor,
    this.moreButtonColor,
    this.iconSize = 20,
    this.spacing = 8,
    this.showLabels = false,
    this.labelStyle,
    this.mainAxisAlignment = MainAxisAlignment.end,
    this.showBackground = false,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Container(
      decoration: showBackground
          ? BoxDecoration(
              color: backgroundColor ?? design.designSystemColors.surfaceContainer.withOpacity(0.8),
              borderRadius: borderRadius ?? BorderRadius.circular(design.designSystemRadius.md),
            )
          : null,
      padding: padding,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          // Like Button
          _buildLikeButton(),

          if (onSharePressed != null || onMorePressed != null || menuItems != null)
            SizedBox(width: spacing),

          // Share Button
          if (onSharePressed != null) ...[
            _buildShareButton(),
            SizedBox(width: spacing),
          ],

          // More Options Button/Menu
          _buildMoreButton(),
        ],
      ),
    );
  }

  Widget _buildLikeButton() {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Column(
      children: [
        IconButton(
          onPressed: onLikePressed,
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            size: iconSize,
            color: isLiked
                ? (likedButtonColor ?? design.designSystemColors.error)
                : (likeButtonColor ?? design.designSystemColors.onSurfaceVariant),
          ),
          style: IconButton.styleFrom(
            fixedSize: Size(buttonSize, buttonSize),
            backgroundColor: Colors.transparent,
          ),
        ),
        if (showLabels)
          Text(
            isLiked ? 'Liked' : 'Like',
            style: labelStyle ?? design.designSystemTypography.caption.copyWith(
              color: design.designSystemColors.onSurfaceVariant,
            ),
          ),
      ],
    );
  }

  Widget _buildShareButton() {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Column(
      children: [
        IconButton(
          onPressed: onSharePressed,
          icon: Icon(
            Icons.share,
            size: iconSize,
            color: shareButtonColor ?? design.designSystemColors.onSurfaceVariant,
          ),
          style: IconButton.styleFrom(
            fixedSize: Size(buttonSize, buttonSize),
            backgroundColor: Colors.transparent,
          ),
        ),
        if (showLabels)
          Text(
            'Share',
            style: labelStyle ?? design.designSystemTypography.caption.copyWith(
              color: design.designSystemColors.onSurfaceVariant,
            ),
          ),
      ],
    );
  }

  Widget _buildMoreButton() {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Column(
      children: [
        PopupMenuButton<String>(
          onSelected: (value) {
            // Handle menu item selection
            final item = menuItems?.firstWhere((item) => item.value == value);
            item?.onPressed?.call();
          },
          itemBuilder: (context) {
            if (menuItems != null && menuItems!.isNotEmpty) {
              return menuItems!.map((item) {
                return PopupMenuItem<String>(
                  value: item.value,
                  child: Row(
                    children: [
                      if (item.icon != null) ...[
                        Icon(item.icon, size: 18, color: item.iconColor),
                        const SizedBox(width: 8),
                      ],
                      Text(item.label),
                    ],
                  ),
                );
              }).toList();
            }

            // Default single "More" option
            return [
              PopupMenuItem<String>(
                value: 'more',
                child: Text(
                  'More options',
                  style: design.designSystemTypography.bodyMedium,
                ),
              ),
            ];
          },
          child: IconButton(
            onPressed: onMorePressed,
            icon: Icon(
              Icons.more_vert,
              size: iconSize,
              color: moreButtonColor ?? design.designSystemColors.onSurfaceVariant,
            ),
            style: IconButton.styleFrom(
              fixedSize: Size(buttonSize, buttonSize),
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
        if (showLabels)
          Text(
            'More',
            style: labelStyle ?? design.designSystemTypography.caption.copyWith(
              color: design.designSystemColors.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}

/// Represents a single action item for the card actions menu
class CardActionItem {
  /// The label text for the action
  final String label;

  /// The value/key for the action
  final String value;

  /// Optional icon for the action
  final IconData? icon;

  /// Color of the icon
  final Color? iconColor;

  /// Callback when the action is selected
  final VoidCallback? onPressed;

  const CardActionItem({
    required this.label,
    required this.value,
    this.icon,
    this.iconColor,
    this.onPressed,
  });
}