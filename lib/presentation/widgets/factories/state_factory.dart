import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';
import '../builders/state_builder.dart';

/// A factory class for creating state displays.
/// Provides pre-configured state widgets for common scenarios in the music app.
///
/// **Features:**
/// - Pre-configured state displays for music app scenarios
/// - Consistent styling and behavior
/// - Easy customization and extension
/// - Integration with existing state widgets
/// - Support for music-specific state patterns
///
/// **Usage:**
/// ```dart
/// final factory = StateFactory();
///
/// // Create different state displays
/// final loadingState = factory.createLoadingState(
///   message: 'Loading your music...',
///   showProgress: true,
/// );
///
/// final emptyState = factory.createEmptyState(
///   type: EmptyStateType.playlist,
///   actionText: 'Create Playlist',
///   onActionPressed: () => createNewPlaylist(),
/// );
///
/// final errorState = factory.createErrorState(
///   type: ErrorStateType.network,
///   onRetry: () => retryLoadData(),
/// );
/// ```
class StateFactory {
  /// Creates a loading state widget
  Widget createLoadingState({
    required BuildContext context,
    String? message,
    bool showProgress = true,
    double? progressSize,
    Widget? customIndicator,
    EdgeInsetsGeometry? padding,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return StateBuilder()
        .withState(StateType.loading)
        .withLoadingMessage(message ?? 'Loading...')
        .withLoadingWidget(
          showProgress
              ? (customIndicator ?? SizedBox(
                  width: progressSize ?? 48,
                  height: progressSize ?? 48,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(design.designSystemColors.primary),
                  ),
                ))
              : const SizedBox.shrink(),
        )
        .withPadding(padding ?? EdgeInsets.all(design.designSystemSpacing.xl))
        .build();
  }

  /// Creates an empty state widget
  Widget createEmptyState({
    required BuildContext context,
    EmptyStateType type = EmptyStateType.general,
    String? message,
    String? actionText,
    VoidCallback? onActionPressed,
    IconData? customIcon,
    EdgeInsetsGeometry? padding,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return StateBuilder()
        .withState(StateType.empty)
        .withEmptyMessage(message ?? _getDefaultEmptyMessage(type))
        .withEmptyIcon(customIcon ?? _getDefaultEmptyIcon(type))
        .withPadding(padding ?? EdgeInsets.all(design.designSystemSpacing.xl))
        .build();
  }

  /// Creates an error state widget
  Widget createErrorState({
    required BuildContext context,
    ErrorStateType type = ErrorStateType.general,
    String? message,
    String? actionText,
    VoidCallback? onRetry,
    IconData? customIcon,
    EdgeInsetsGeometry? padding,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return StateBuilder()
        .withState(StateType.error)
        .withErrorMessage(message ?? _getDefaultErrorMessage(type))
        .withErrorIcon(customIcon ?? _getDefaultErrorIcon(type))
        .withOnRetry(onRetry ?? () {})
        .withPadding(padding ?? EdgeInsets.all(design.designSystemSpacing.xl))
        .build();
  }

  /// Creates a success state widget
  Widget createSuccessState({
    required BuildContext context,
    String? message,
    String? actionText,
    VoidCallback? onActionPressed,
    IconData? customIcon,
    EdgeInsetsGeometry? padding,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return StateBuilder()
        .withState(StateType.success)
        .withSuccessMessage(message ?? 'Success!')
        .withSuccessIcon(customIcon ?? Icons.check_circle_outline)
        .withPadding(padding ?? EdgeInsets.all(design.designSystemSpacing.xl))
        .build();
  }

  /// Creates a compact loading indicator for inline use
  Widget createInlineLoading({
    double size = 20,
    Color? color,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? DesignSystem.primary,
        ),
      ),
    );
  }

  /// Creates a loading overlay for covering content
  Widget createLoadingOverlay({
    required BuildContext context,
    String? message,
    bool dismissible = false,
    VoidCallback? onDismiss,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Container(
      color: design.designSystemColors.overlay,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(design.designSystemSpacing.lg),
          decoration: BoxDecoration(
            color: design.designSystemColors.surface,
            borderRadius: BorderRadius.circular(design.designSystemRadius.lg),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(design.designSystemColors.primary),
                ),
              ),
              SizedBox(height: design.designSystemSpacing.lg),
              Text(
                message ?? 'Loading...',
                style: design.designSystemTypography.bodyMedium.copyWith(
                  color: design.designSystemColors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Creates a skeleton loading placeholder
  Widget createSkeletonLoader({
    required BuildContext context,
    double height = 60,
    int lines = 1,
    EdgeInsetsGeometry? margin,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Container(
      height: height,
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          lines,
          (index) => Container(
            height: height / lines,
            margin: EdgeInsets.only(
              bottom: index < lines - 1 ? design.designSystemSpacing.xs : 0,
            ),
            decoration: BoxDecoration(
              color: design.designSystemColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(design.designSystemRadius.sm),
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    design.designSystemColors.surfaceContainerHigh,
                    design.designSystemColors.surfaceContainer,
                    design.designSystemColors.surfaceContainerHigh,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Creates a shimmer loading effect
  Widget createShimmerEffect({
    required BuildContext context,
    double height = 200,
    EdgeInsetsGeometry? margin,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Container(
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: design.designSystemColors.surfaceContainer,
        borderRadius: BorderRadius.circular(design.designSystemRadius.md),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(design.designSystemRadius.md),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                design.designSystemColors.surfaceContainer,
                design.designSystemColors.surfaceContainerHigh.withOpacity(0.5),
                design.designSystemColors.surfaceContainer,
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods for default messages and icons
  String _getDefaultEmptyMessage(EmptyStateType type) {
    switch (type) {
      case EmptyStateType.playlist:
        return 'No playlists yet';
      case EmptyStateType.track:
        return 'No tracks found';
      case EmptyStateType.artist:
        return 'No artists found';
      case EmptyStateType.album:
        return 'No albums found';
      case EmptyStateType.search:
        return 'No search results';
      case EmptyStateType.library:
        return 'Your library is empty';
      case EmptyStateType.downloads:
        return 'No downloads yet';
      case EmptyStateType.general:
        return 'No items found';
    }
  }

  IconData _getDefaultEmptyIcon(EmptyStateType type) {
    switch (type) {
      case EmptyStateType.playlist:
        return Icons.playlist_play;
      case EmptyStateType.track:
        return Icons.music_note;
      case EmptyStateType.artist:
        return Icons.person;
      case EmptyStateType.album:
        return Icons.album;
      case EmptyStateType.search:
        return Icons.search;
      case EmptyStateType.library:
        return Icons.library_music;
      case EmptyStateType.downloads:
        return Icons.download;
      case EmptyStateType.general:
        return Icons.inbox_outlined;
    }
  }

  String _getDefaultErrorMessage(ErrorStateType type) {
    switch (type) {
      case ErrorStateType.network:
        return 'Network error occurred';
      case ErrorStateType.permission:
        return 'Permission denied';
      case ErrorStateType.notFound:
        return 'Content not found';
      case ErrorStateType.server:
        return 'Server error occurred';
      case ErrorStateType.playback:
        return 'Playback error occurred';
      case ErrorStateType.general:
        return 'Something went wrong';
    }
  }

  IconData _getDefaultErrorIcon(ErrorStateType type) {
    switch (type) {
      case ErrorStateType.network:
        return Icons.wifi_off;
      case ErrorStateType.permission:
        return Icons.lock;
      case ErrorStateType.notFound:
        return Icons.search_off;
      case ErrorStateType.server:
        return Icons.cloud_off;
      case ErrorStateType.playback:
        return Icons.play_disabled;
      case ErrorStateType.general:
        return Icons.error_outline;
    }
  }
}

/// Empty state types for different scenarios
enum EmptyStateType {
  /// General empty state
  general,

  /// Empty playlist state
  playlist,

  /// Empty track/song state
  track,

  /// Empty artist state
  artist,

  /// Empty album state
  album,

  /// Empty search results state
  search,

  /// Empty library state
  library,

  /// Empty downloads state
  downloads,
}

/// Error state types for different scenarios
enum ErrorStateType {
  /// General error state
  general,

  /// Network connectivity error
  network,

  /// Permission denied error
  permission,

  /// Content not found error
  notFound,

  /// Server error
  server,

  /// Playback error
  playback,
}

/// Extension for quick state factory access
extension StateFactoryExtension on StateFactory {
  /// Creates a StateFactory instance (singleton pattern)
  static StateFactory get instance => StateFactory();
}