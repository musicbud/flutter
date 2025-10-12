import 'package:flutter/material.dart';
import '../theme/design_system.dart';

/// MusicBud UI Components Library
/// Based on Figma designs with consistent styling

// ============================================================================
// AVATAR COMPONENTS
// ============================================================================

/// Circular avatar with optional border (used in stories, profiles)
class MusicBudAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final bool hasBorder;
  final Color borderColor;
  final Widget? child;
  final VoidCallback? onTap;

  const MusicBudAvatar({
    Key? key,
    this.imageUrl,
    this.size = 60,
    this.hasBorder = false,
    this.borderColor = DesignSystem.pinkAccent,
    this.child,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: hasBorder
              ? Border.all(color: borderColor, width: 2)
              : null,
        ),
        child: ClipOval(
          child: child ??
              (imageUrl != null
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildDefaultAvatar(),
                    )
                  : _buildDefaultAvatar()),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: DesignSystem.surfaceContainerHigh,
      child: Icon(
        Icons.person,
        size: size * 0.5,
        color: DesignSystem.onSurfaceVariant,
      ),
    );
  }
}

// ============================================================================
// CARD COMPONENTS
// ============================================================================

/// Content card for music/movies/anime (used in Home screen)
class ContentCard extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String subtitle;
  final double width;
  final double height;
  final VoidCallback? onTap;
  final Widget? tag;

  const ContentCard({
    Key? key,
    this.imageUrl,
    required this.title,
    required this.subtitle,
    this.width = 120,
    this.height = 180,
    this.onTap,
    this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: DesignSystem.spacingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image container
            Container(
              width: width,
              height: height - 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
                color: DesignSystem.surfaceContainer,
                image: imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Stack(
                children: [
                  if (tag != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: tag!,
                    ),
                  if (imageUrl == null)
                    const Center(
                      child: Icon(
                        Icons.music_note,
                        size: 40,
                        color: DesignSystem.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: DesignSystem.spacingXS),
            // Title
            Text(
              title,
              style: DesignSystem.titleSmall.copyWith(
                color: DesignSystem.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            // Subtitle
            Text(
              subtitle,
              style: DesignSystem.bodySmall.copyWith(
                color: DesignSystem.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Large hero card with gradient overlay
class HeroCard extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String subtitle;
  final VoidCallback? onPlayTap;
  final VoidCallback? onSaveTap;

  const HeroCard({
    Key? key,
    this.imageUrl,
    required this.title,
    required this.subtitle,
    this.onPlayTap,
    this.onSaveTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      margin: const EdgeInsets.all(DesignSystem.spacingMD),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
        image: imageUrl != null
            ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
        gradient: imageUrl == null ? DesignSystem.gradientCard : null,
      ),
      child: Stack(
        children: [
          // Dark gradient overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
              gradient: DesignSystem.gradientOverlay,
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(DesignSystem.spacingLG),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                // Music icon
                const Icon(
                  Icons.music_note,
                  color: DesignSystem.onSurface,
                  size: 32,
                ),
                const SizedBox(height: DesignSystem.spacingXS),
                // Title
                Text(
                  title,
                  style: DesignSystem.headlineMedium.copyWith(
                    color: DesignSystem.onSurface,
                    shadows: DesignSystem.shadowText,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: DesignSystem.spacingXXS),
                // Subtitle
                Text(
                  subtitle,
                  style: DesignSystem.bodyMedium.copyWith(
                    color: DesignSystem.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: DesignSystem.spacingLG),
                // Action buttons
                Row(
                  children: [
                    IconButton(
                      onPressed: onSaveTap,
                      icon: const Icon(Icons.bookmark_outline),
                      color: DesignSystem.onSurface,
                      iconSize: 28,
                    ),
                    const Spacer(),
                    // Play button
                    GestureDetector(
                      onTap: onPlayTap,
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: DesignSystem.onSurface,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: DesignSystem.background,
                          size: 32,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// BUTTON COMPONENTS
// ============================================================================

/// Primary button with rounded corners
class MusicBudButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final double? width;

  const MusicBudButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? DesignSystem.onSurface;
    final fgColor = textColor ?? DesignSystem.background;

    return SizedBox(
      width: width,
      height: 48,
      child: isOutlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: bgColor,
                side: BorderSide(color: bgColor, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
                ),
              ),
              child: _buildContent(),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: bgColor,
                foregroundColor: fgColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
                ),
              ),
              child: _buildContent(),
            ),
    );
  }

  Widget _buildContent() {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(text, style: DesignSystem.labelLarge),
        ],
      );
    }
    return Text(text, style: DesignSystem.labelLarge);
  }
}

// ============================================================================
// TAB COMPONENTS
// ============================================================================

/// Pill-shaped category tabs (Music, Movies, Anime)
class CategoryTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryTab({
    Key? key,
    required this.label,
    required this.isSelected,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignSystem.spacingLG,
          vertical: DesignSystem.spacingSM,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? DesignSystem.onSurface
              : Colors.transparent,
          border: isSelected
              ? null
              : Border.all(
                  color: DesignSystem.onSurfaceVariant,
                  width: 1,
                ),
          borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
        ),
        child: Text(
          label,
          style: DesignSystem.labelMedium.copyWith(
            color: isSelected
                ? DesignSystem.background
                : DesignSystem.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// BOTTOM NAVIGATION
// ============================================================================

/// Bottom navigation bar with icon buttons
class MusicBudBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MusicBudBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: DesignSystem.surfaceContainer,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DesignSystem.radiusXL),
        ),
        boxShadow: DesignSystem.shadowCard,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, Icons.home, 0, 'Home'),
          _buildNavItem(Icons.search_outlined, Icons.search, 1, 'Search'),
          _buildNavItem(Icons.people_outline, Icons.people, 2, 'Buds'),
          _buildNavItem(Icons.chat_bubble_outline, Icons.chat_bubble, 3, 'Chat'),
          _buildNavItem(Icons.person_outline, Icons.person, 4, 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData outlinedIcon, IconData filledIcon, int index, String label) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? DesignSystem.pinkAccent.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? filledIcon : outlinedIcon,
              size: 24,
              color: isSelected
                  ? DesignSystem.pinkAccent
                  : DesignSystem.onSurfaceVariant,
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Text(
                label,
                style: DesignSystem.labelSmall.copyWith(
                  color: DesignSystem.pinkAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// LIST ITEMS
// ============================================================================

/// Message list item for chat
class MessageListItem extends StatelessWidget {
  final String name;
  final String message;
  final String? imageUrl;
  final String? avatarUrl;  // Alias for imageUrl
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool hasNewMessage;
  final String? timestamp;
  final int? unreadCount;
  final bool isOnline;

  const MessageListItem({
    Key? key,
    required this.name,
    required this.message,
    this.imageUrl,
    this.avatarUrl,
    this.onTap,
    this.onLongPress,
    this.hasNewMessage = false,
    this.timestamp,
    this.unreadCount,
    this.isOnline = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? displayImageUrl = avatarUrl ?? imageUrl;
    final bool showUnreadBadge = (unreadCount != null && unreadCount! > 0) || hasNewMessage;
    
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignSystem.spacingMD,
          vertical: DesignSystem.spacingMD,
        ),
        child: Row(
          children: [
            // Avatar with online indicator
            Stack(
              children: [
                MusicBudAvatar(
                  imageUrl: displayImageUrl,
                  size: 50,
                ),
                if (isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: DesignSystem.successGreen,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: DesignSystem.background,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: DesignSystem.spacingMD),
            // Message content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: DesignSystem.titleSmall.copyWith(
                            color: DesignSystem.onSurface,
                            fontWeight: showUnreadBadge ? FontWeight.bold : FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (timestamp != null)
                        Text(
                          timestamp!,
                          style: DesignSystem.bodySmall.copyWith(
                            color: DesignSystem.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: DesignSystem.spacingXXS),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          message,
                          style: DesignSystem.bodySmall.copyWith(
                            color: showUnreadBadge
                                ? DesignSystem.onSurface
                                : DesignSystem.onSurfaceVariant,
                            fontWeight: showUnreadBadge ? FontWeight.w600 : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (showUnreadBadge && unreadCount != null && unreadCount! > 0)
                        Container(
                          margin: const EdgeInsets.only(left: DesignSystem.spacingSM),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: DesignSystem.pinkAccent,
                            borderRadius: BorderRadius.circular(DesignSystem.radiusFull),
                          ),
                          child: Text(
                            unreadCount! > 99 ? '99+' : unreadCount.toString(),
                            style: DesignSystem.bodySmall.copyWith(
                              color: DesignSystem.onPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// SECTION HEADERS
// ============================================================================

/// Section header with title
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAllTap;

  const SectionHeader({
    Key? key,
    required this.title,
    this.onSeeAllTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.spacingMD,
        vertical: DesignSystem.spacingSM,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: DesignSystem.headlineSmall.copyWith(
              color: DesignSystem.onSurface,
            ),
          ),
          if (onSeeAllTap != null)
            TextButton(
              onPressed: onSeeAllTap,
              child: Text(
                'See all',
                style: DesignSystem.labelMedium.copyWith(
                  color: DesignSystem.pinkAccent,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
