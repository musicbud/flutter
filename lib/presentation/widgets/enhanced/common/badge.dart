import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// A badge widget for displaying counts, notifications, or status
///
/// Example:
/// ```dart
/// Badge(
///   content: '5',
///   child: Icon(Icons.notifications),
/// )
/// ```
class AppBadge extends StatelessWidget {
  /// The content to display in the badge (usually a number or short text)
  final String? content;

  /// The child widget to display the badge on
  final Widget child;

  /// Badge background color
  final Color? backgroundColor;

  /// Badge text color
  final Color? textColor;

  /// Badge position relative to child
  final BadgePosition position;

  /// Whether to show the badge
  final bool show;

  /// Badge size
  final BadgeSize size;

  /// Custom badge widget (overrides content)
  final Widget? customBadge;

  const AppBadge({
    super.key,
    this.content,
    required this.child,
    this.backgroundColor,
    this.textColor,
    this.position = BadgePosition.topRight,
    this.show = true,
    this.size = BadgeSize.medium,
    this.customBadge,
  });

  @override
  Widget build(BuildContext context) {
    if (!show) {
      return child;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: _getTopPosition(),
          right: _getRightPosition(),
          bottom: _getBottomPosition(),
          left: _getLeftPosition(),
          child: customBadge ?? _buildDefaultBadge(),
        ),
      ],
    );
  }

  double? _getTopPosition() {
    switch (position) {
      case BadgePosition.topRight:
      case BadgePosition.topLeft:
        return -6;
      case BadgePosition.bottomRight:
      case BadgePosition.bottomLeft:
        return null;
    }
  }

  double? _getRightPosition() {
    switch (position) {
      case BadgePosition.topRight:
      case BadgePosition.bottomRight:
        return -6;
      case BadgePosition.topLeft:
      case BadgePosition.bottomLeft:
        return null;
    }
  }

  double? _getBottomPosition() {
    switch (position) {
      case BadgePosition.bottomRight:
      case BadgePosition.bottomLeft:
        return -6;
      case BadgePosition.topRight:
      case BadgePosition.topLeft:
        return null;
    }
  }

  double? _getLeftPosition() {
    switch (position) {
      case BadgePosition.topLeft:
      case BadgePosition.bottomLeft:
        return -6;
      case BadgePosition.topRight:
      case BadgePosition.bottomRight:
        return null;
    }
  }

  Widget _buildDefaultBadge() {
    final double badgeSize = _getBadgeSize();
    final double fontSize = _getFontSize();

    return Container(
      constraints: BoxConstraints(
        minWidth: badgeSize,
        minHeight: badgeSize,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor ?? DesignSystem.error,
        borderRadius: BorderRadius.circular(badgeSize / 2),
        border: Border.all(
          color: DesignSystem.surface,
          width: 1.5,
        ),
      ),
      child: content != null
          ? Center(
              child: Text(
                content!,
                style: TextStyle(
                  color: textColor ?? DesignSystem.onError,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
                textAlign: TextAlign.center,
              ),
            )
          : null,
    );
  }

  double _getBadgeSize() {
    switch (size) {
      case BadgeSize.small:
        return 12;
      case BadgeSize.medium:
        return 18;
      case BadgeSize.large:
        return 24;
    }
  }

  double _getFontSize() {
    switch (size) {
      case BadgeSize.small:
        return 8;
      case BadgeSize.medium:
        return 11;
      case BadgeSize.large:
        return 13;
    }
  }

  /// Factory for a notification badge (red dot)
  factory AppBadge.notification({
    required Widget child,
    bool show = true,
    BadgePosition position = BadgePosition.topRight,
  }) {
    return AppBadge(
      show: show,
      position: position,
      size: BadgeSize.small,
      customBadge: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: DesignSystem.error,
          shape: BoxShape.circle,
          border: Border.all(
            color: DesignSystem.surface,
            width: 1.5,
          ),
        ),
      ),
      child: child,
    );
  }

  /// Factory for a count badge
  factory AppBadge.count({
    required int count,
    required Widget child,
    BadgePosition position = BadgePosition.topRight,
    BadgeSize size = BadgeSize.medium,
    Color? backgroundColor,
  }) {
    final displayText = count > 99 ? '99+' : count.toString();
    return AppBadge(
      content: displayText,
      show: count > 0,
      position: position,
      size: size,
      backgroundColor: backgroundColor,
      child: child,
    );
  }

  /// Factory for a status badge
  factory AppBadge.status({
    required String status,
    required Widget child,
    Color? backgroundColor,
    Color? textColor,
    BadgePosition position = BadgePosition.topRight,
  }) {
    return AppBadge(
      content: status,
      backgroundColor: backgroundColor,
      textColor: textColor,
      position: position,
      size: BadgeSize.small,
      child: child,
    );
  }
}

/// Badge position relative to child
enum BadgePosition {
  topRight,
  topLeft,
  bottomRight,
  bottomLeft,
}

/// Badge size
enum BadgeSize {
  small,
  medium,
  large,
}

/// A standalone badge (not attached to a widget)
class StandaloneBadge extends StatelessWidget {
  /// Badge label
  final String label;

  /// Background color
  final Color? backgroundColor;

  /// Text color
  final Color? textColor;

  /// Border color
  final Color? borderColor;

  /// Whether to show border
  final bool showBorder;

  /// Padding
  final EdgeInsetsGeometry? padding;

  const StandaloneBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.showBorder = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
      decoration: BoxDecoration(
        color: backgroundColor ?? DesignSystem.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: showBorder
            ? Border.all(
                color: borderColor ?? DesignSystem.border,
                width: 1,
              )
            : null,
      ),
      child: Text(
        label,
        style: DesignSystem.labelSmall.copyWith(
          color: textColor ?? DesignSystem.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Factory for success badge
  factory StandaloneBadge.success({required String label}) {
    return StandaloneBadge(
      label: label,
      backgroundColor: DesignSystem.success,
      textColor: DesignSystem.onSuccess,
    );
  }

  /// Factory for error badge
  factory StandaloneBadge.error({required String label}) {
    return StandaloneBadge(
      label: label,
      backgroundColor: DesignSystem.error,
      textColor: DesignSystem.onError,
    );
  }

  /// Factory for warning badge
  factory StandaloneBadge.warning({required String label}) {
    return StandaloneBadge(
      label: label,
      backgroundColor: DesignSystem.warning,
      textColor: DesignSystem.onWarning,
    );
  }

  /// Factory for info badge
  factory StandaloneBadge.info({required String label}) {
    return StandaloneBadge(
      label: label,
      backgroundColor: DesignSystem.info,
      textColor: DesignSystem.onInfo,
    );
  }

  /// Factory for neutral badge
  factory StandaloneBadge.neutral({required String label}) {
    return StandaloneBadge(
      label: label,
      backgroundColor: DesignSystem.surfaceContainerHigh,
      textColor: DesignSystem.onSurface,
    );
  }
}
