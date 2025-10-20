import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// Avatar sizes
enum AvatarSize {
  small, // 32px
  medium, // 48px
  large, // 64px
  extraLarge, // 96px
}

/// Status indicator position
enum StatusPosition {
  topRight,
  bottomRight,
  topLeft,
  bottomLeft,
}

/// A customizable avatar widget with fallback support and status indicators.
///
/// Supports:
/// - Multiple sizes
/// - Network images with fallback
/// - Initials fallback
/// - Icon fallback
/// - Status indicators (online, offline, busy, etc.)
/// - Border customization
///
/// Example:
/// ```dart
/// Avatar(
///   imageUrl: user.avatarUrl,
///   fallbackText: user.name,
///   size: AvatarSize.large,
///   showStatus: true,
///   statusColor: Colors.green,
/// )
/// ```
class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    this.imageUrl,
    this.fallbackText,
    this.fallbackIcon = Icons.person,
    this.size = AvatarSize.medium,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth = 0,
    this.showStatus = false,
    this.statusColor,
    this.statusPosition = StatusPosition.bottomRight,
    this.onTap,
  });

  final String? imageUrl;
  final String? fallbackText;
  final IconData fallbackIcon;
  final AvatarSize size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double borderWidth;
  final bool showStatus;
  final Color? statusColor;
  final StatusPosition statusPosition;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();
    final avatarSize = _getSize();
    final bgColor = backgroundColor ??
        design?.designSystemColors.surfaceDark ??
        theme.colorScheme.surfaceContainerHighest;
    final fgColor = foregroundColor ??
        design?.designSystemColors.textPrimary ??
        theme.colorScheme.onSurface;

    final avatar = Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
        border: borderWidth > 0
            ? Border.all(
                color: borderColor ??
                    design?.designSystemColors.textMuted ??
                    theme.dividerColor,
                width: borderWidth,
              )
            : null,
      ),
      child: ClipOval(
        child: _buildContent(fgColor),
      ),
    );

    final avatarWithStatus = showStatus
        ? Stack(
            clipBehavior: Clip.none,
            children: [
              avatar,
              _buildStatusIndicator(design, theme),
            ],
          )
        : avatar;

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(avatarSize / 2),
        child: avatarWithStatus,
      );
    }

    return avatarWithStatus;
  }

  Widget _buildContent(Color foregroundColor) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallback(foregroundColor);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildFallback(foregroundColor);
        },
      );
    }

    return _buildFallback(foregroundColor);
  }

  Widget _buildFallback(Color foregroundColor) {
    if (fallbackText != null && fallbackText!.isNotEmpty) {
      return Center(
        child: Text(
          _getInitials(fallbackText!),
          style: TextStyle(
            color: foregroundColor,
            fontSize: _getFontSize(),
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Icon(
      fallbackIcon,
      size: _getIconSize(),
      color: foregroundColor,
    );
  }

  Widget _buildStatusIndicator(
    DesignSystemThemeExtension? design,
    ThemeData theme,
  ) {
    final statusSize = _getStatusSize();
    final offset = _getStatusOffset();
    final color = statusColor ??
        design?.designSystemColors.success ??
        Colors.green;

    return Positioned(
      top: statusPosition == StatusPosition.topRight ||
              statusPosition == StatusPosition.topLeft
          ? offset
          : null,
      bottom: statusPosition == StatusPosition.bottomRight ||
              statusPosition == StatusPosition.bottomLeft
          ? offset
          : null,
      right: statusPosition == StatusPosition.topRight ||
              statusPosition == StatusPosition.bottomRight
          ? offset
          : null,
      left: statusPosition == StatusPosition.topLeft ||
              statusPosition == StatusPosition.bottomLeft
          ? offset
          : null,
      child: Container(
        width: statusSize,
        height: statusSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(
            color: theme.colorScheme.surface,
            width: 2,
          ),
        ),
      ),
    );
  }

  String _getInitials(String text) {
    final words = text.trim().split(' ');
    if (words.isEmpty) return '';
    if (words.length == 1) {
      return words[0].substring(0, words[0].length > 2 ? 2 : words[0].length).toUpperCase();
    }
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }

  double _getSize() {
    switch (size) {
      case AvatarSize.small:
        return 32;
      case AvatarSize.medium:
        return 48;
      case AvatarSize.large:
        return 64;
      case AvatarSize.extraLarge:
        return 96;
    }
  }

  double _getFontSize() {
    switch (size) {
      case AvatarSize.small:
        return 12;
      case AvatarSize.medium:
        return 16;
      case AvatarSize.large:
        return 20;
      case AvatarSize.extraLarge:
        return 28;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AvatarSize.small:
        return 16;
      case AvatarSize.medium:
        return 24;
      case AvatarSize.large:
        return 32;
      case AvatarSize.extraLarge:
        return 48;
    }
  }

  double _getStatusSize() {
    switch (size) {
      case AvatarSize.small:
        return 8;
      case AvatarSize.medium:
        return 12;
      case AvatarSize.large:
        return 14;
      case AvatarSize.extraLarge:
        return 18;
    }
  }

  double _getStatusOffset() {
    switch (size) {
      case AvatarSize.small:
        return 2;
      case AvatarSize.medium:
        return 3;
      case AvatarSize.large:
        return 4;
      case AvatarSize.extraLarge:
        return 6;
    }
  }
}

/// Avatar group showing multiple avatars in a stack
class AvatarGroup extends StatelessWidget {
  const AvatarGroup({
    super.key,
    required this.avatars,
    this.size = AvatarSize.medium,
    this.maxVisible = 3,
    this.spacing = 8.0,
  });

  final List<String?> avatars;
  final AvatarSize size;
  final int maxVisible;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final visible = avatars.take(maxVisible).toList();
    final remaining = avatars.length - maxVisible;

    return SizedBox(
      width: _calculateWidth(visible.length),
      height: _getAvatarSize(),
      child: Stack(
        children: [
          ...List.generate(
            visible.length,
            (index) => Positioned(
              left: index * spacing,
              child: Avatar(
                imageUrl: visible[index],
                size: size,
                borderWidth: 2,
              ),
            ),
          ),
          if (remaining > 0)
            Positioned(
              left: visible.length * spacing,
              child: Avatar(
                size: size,
                fallbackText: '+$remaining',
                borderWidth: 2,
              ),
            ),
        ],
      ),
    );
  }

  double _getAvatarSize() {
    switch (size) {
      case AvatarSize.small:
        return 32;
      case AvatarSize.medium:
        return 48;
      case AvatarSize.large:
        return 64;
      case AvatarSize.extraLarge:
        return 96;
    }
  }

  double _calculateWidth(int count) {
    final avatarSize = _getAvatarSize();
    final hasRemaining = avatars.length > maxVisible;
    final totalAvatars = hasRemaining ? count + 1 : count;
    return (totalAvatars * spacing) + avatarSize;
  }
}
