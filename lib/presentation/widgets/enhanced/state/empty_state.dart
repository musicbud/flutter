import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// A widget for displaying empty state with icon, message, and optional action
/// 
/// Use this when lists or content areas have no data to display.
/// Provides a consistent empty state design across the app.
/// 
/// Example:
/// ```dart
/// if (tracks.isEmpty) {
///   return EmptyState(
///     icon: Icons.music_note_outlined,
///     title: 'No tracks yet',
///     message: 'Start adding tracks to your library',
///     actionLabel: 'Browse Music',
///     onAction: () => Navigator.pushNamed(context, '/discover'),
///   );
/// }
/// ```
class EmptyState extends StatelessWidget {
  /// Icon to display
  final IconData icon;

  /// Main title text
  final String title;

  /// Optional description message
  final String? message;

  /// Optional action button label
  final String? actionLabel;

  /// Optional action button callback
  final VoidCallback? onAction;

  /// Icon size (default: 64)
  final double iconSize;

  /// Icon color
  final Color? iconColor;

  /// Custom padding
  final EdgeInsetsGeometry? padding;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.iconSize = 64,
    this.iconColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding ?? const EdgeInsets.all(DesignSystem.spacingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Icon(
              icon,
              size: iconSize,
              color: iconColor ?? DesignSystem.onSurfaceVariant.withValues(alpha: 0.6),
            ),

            const SizedBox(height: DesignSystem.spacingLG),

            // Title
            Text(
              title,
              style: DesignSystem.headlineSmall.copyWith(
                color: DesignSystem.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            // Message
            if (message != null) ...[
              const SizedBox(height: DesignSystem.spacingSM),
              Text(
                message!,
                style: DesignSystem.bodyMedium.copyWith(
                  color: DesignSystem.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Action Button
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: DesignSystem.spacingLG),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: DesignSystem.primary,
                  foregroundColor: DesignSystem.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignSystem.spacingXL,
                    vertical: DesignSystem.spacingMD,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
                  ),
                ),
                child: Text(
                  actionLabel!,
                  style: DesignSystem.titleMedium.copyWith(
                    color: DesignSystem.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Preset for empty search results
  factory EmptyState.noResults({
    String? message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return EmptyState(
      icon: Icons.search_off,
      title: 'No results found',
      message: message ?? 'Try adjusting your search or filters',
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Preset for empty playlist
  factory EmptyState.noTracks({
    String? message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return EmptyState(
      icon: Icons.music_note_outlined,
      title: 'No tracks yet',
      message: message ?? 'Start adding tracks to your library',
      actionLabel: actionLabel ?? 'Browse Music',
      onAction: onAction,
    );
  }

  /// Preset for no followers/following
  factory EmptyState.noConnections({
    String? message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return EmptyState(
      icon: Icons.people_outline,
      title: 'No connections yet',
      message: message ?? 'Find and connect with music buds',
      actionLabel: actionLabel ?? 'Find Buds',
      onAction: onAction,
    );
  }

  /// Preset for no chats
  factory EmptyState.noChats({
    String? message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return EmptyState(
      icon: Icons.chat_bubble_outline,
      title: 'No conversations',
      message: message ?? 'Start chatting with your music buds',
      actionLabel: actionLabel ?? 'Find Buds',
      onAction: onAction,
    );
  }

  /// Preset for no events
  factory EmptyState.noEvents({
    String? message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return EmptyState(
      icon: Icons.event_outlined,
      title: 'No events',
      message: message ?? 'Check back later for upcoming events',
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
}
