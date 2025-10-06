import 'package:flutter/material.dart';

/// A mixin that provides comprehensive empty state management for widgets.
///
/// This mixin handles:
/// - Empty state detection and tracking
/// - Customizable empty messages and icons
/// - Action buttons and callbacks for empty states
/// - Consistent empty state UI with theme integration
/// - Different types of empty states (no data, no results, etc.)
/// - Empty state animations and transitions
///
/// Usage:
/// ```dart
/// class MyWidget extends StatefulWidget {
///   // ...
/// }
///
/// class _MyWidgetState extends State<MyWidget>
///     with EmptyStateMixin {
///
///   @override
///   Widget build(BuildContext context) {
///     return buildEmptyState(
///       context,
///       isEmpty: _items.isEmpty,
///       emptyMessage: 'No items found',
///       emptyIcon: Icons.inbox_outlined,
///       actionText: 'Add Item',
///       onActionPressed: _showAddItemDialog,
///     );
///   }
/// }
/// ```
mixin EmptyStateMixin<T extends StatefulWidget> on State<T> {
  /// Whether the widget is in empty state
  bool _isEmpty = false;

  /// Current empty state configuration
  EmptyStateConfig? _emptyConfig;

  /// Whether currently showing empty state
  bool get isEmpty => _isEmpty;

  /// Gets the current empty state configuration
  EmptyStateConfig? get emptyConfig => _emptyConfig;

  /// Set the empty state with configuration
  void setEmptyState({
    required bool isEmpty,
    String? message,
    IconData? icon,
    String? actionText,
    VoidCallback? onActionPressed,
    Widget? customWidget,
    EmptyStateType type = EmptyStateType.noData,
  }) {
    _isEmpty = isEmpty;

    if (isEmpty) {
      _emptyConfig = EmptyStateConfig(
        message: message ?? _getDefaultMessageForType(type),
        icon: icon ?? _getDefaultIconForType(type),
        actionText: actionText,
        onActionPressed: onActionPressed,
        customWidget: customWidget,
        type: type,
      );
    } else {
      _emptyConfig = null;
    }

    onEmptyStateChanged?.call(isEmpty);
  }

  /// Build a widget based on the empty state
  Widget buildEmptyState({
    required BuildContext context,
    required bool isEmpty,
    String? emptyMessage,
    IconData? emptyIcon,
    String? actionText,
    VoidCallback? onActionPressed,
    Widget? customEmptyWidget,
    EmptyStateType type = EmptyStateType.noData,
    bool animate = true,
  }) {
    if (!isEmpty) {
      return const SizedBox.shrink();
    }

    final config = EmptyStateConfig(
      message: emptyMessage ?? _getDefaultMessageForType(type),
      icon: emptyIcon ?? _getDefaultIconForType(type),
      actionText: actionText,
      onActionPressed: onActionPressed,
      customWidget: customEmptyWidget,
      type: type,
    );

    return _buildEmptyStateWidget(context, config, animate);
  }

  /// Build the default empty state widget
  Widget _buildEmptyStateWidget(
    BuildContext context,
    EmptyStateConfig config,
    bool animate,
  ) {
    if (config.customWidget != null) {
      return config.customWidget!;
    }

    return Container(
      padding: _getEmptyStatePadding(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildEmptyStateIcon(context, config),
          SizedBox(height: _getEmptyStateSpacing(context)),
          _buildEmptyStateMessage(context, config),
          if (config.actionText != null && config.onActionPressed != null) ...[
            SizedBox(height: _getEmptyStateSpacing(context) * 1.5),
            _buildEmptyStateAction(context, config),
          ],
        ],
      ),
    );
  }

  /// Build empty state icon
  Widget _buildEmptyStateIcon(BuildContext context, EmptyStateConfig config) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Container(
      padding: EdgeInsets.all(design.designSystemSpacing.xl),
      decoration: BoxDecoration(
        color: design.designSystemColors.surfaceContainer,
        borderRadius: BorderRadius.circular(design.designSystemRadius.xl),
      ),
      child: Icon(
        config.icon,
        size: 64,
        color: design.designSystemColors.onSurfaceVariant,
      ),
    );
  }

  /// Build empty state message
  Widget _buildEmptyStateMessage(BuildContext context, EmptyStateConfig config) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Column(
      children: [
        Text(
          config.message,
          style: design.designSystemTypography.titleMedium.copyWith(
            color: design.designSystemColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        if (config.type == EmptyStateType.noResults && config.searchQuery != null) ...[
          SizedBox(height: design.designSystemSpacing.sm),
          Text(
            'Try adjusting your search terms or filters',
            style: design.designSystemTypography.bodyMedium.copyWith(
              color: design.designSystemColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  /// Build empty state action button
  Widget _buildEmptyStateAction(BuildContext context, EmptyStateConfig config) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return ElevatedButton.icon(
      onPressed: config.onActionPressed,
      icon: _getActionIcon(config.type),
      label: Text(config.actionText!),
      style: ElevatedButton.styleFrom(
        backgroundColor: design.designSystemColors.primary,
        foregroundColor: design.designSystemColors.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(design.designSystemRadius.md),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: design.designSystemSpacing.lg,
          vertical: design.designSystemSpacing.md,
        ),
      ),
    );
  }

  /// Get default message for empty state type
  String _getDefaultMessageForType(EmptyStateType type) {
    switch (type) {
      case EmptyStateType.noData:
        return 'No items found';
      case EmptyStateType.noResults:
        return 'No results found';
      case EmptyStateType.emptyList:
        return 'Your list is empty';
      case EmptyStateType.noFavorites:
        return 'No favorites yet';
      case EmptyStateType.noHistory:
        return 'No history available';
      case EmptyStateType.noNotifications:
        return 'No notifications';
      case EmptyStateType.noMessages:
        return 'No messages yet';
      case EmptyStateType.custom:
      default:
        return 'Nothing to show';
    }
  }

  /// Get default icon for empty state type
  IconData _getDefaultIconForType(EmptyStateType type) {
    switch (type) {
      case EmptyStateType.noData:
        return Icons.inbox_outlined;
      case EmptyStateType.noResults:
        return Icons.search_off;
      case EmptyStateType.emptyList:
        return Icons.list_alt;
      case EmptyStateType.noFavorites:
        return Icons.favorite_border;
      case EmptyStateType.noHistory:
        return Icons.history;
      case EmptyStateType.noNotifications:
        return Icons.notifications_none;
      case EmptyStateType.noMessages:
        return Icons.message_outlined;
      case EmptyStateType.custom:
      default:
        return Icons.info_outline;
    }
  }

  /// Get action icon for empty state type
  IconData _getActionIcon(EmptyStateType type) {
    switch (type) {
      case EmptyStateType.noData:
        return Icons.add;
      case EmptyStateType.noResults:
        return Icons.tune;
      case EmptyStateType.emptyList:
        return Icons.add;
      case EmptyStateType.noFavorites:
        return Icons.favorite;
      case EmptyStateType.noHistory:
        return Icons.refresh;
      case EmptyStateType.noNotifications:
        return Icons.settings;
      case EmptyStateType.noMessages:
        return Icons.send;
      case EmptyStateType.custom:
      default:
        return Icons.arrow_forward;
    }
  }

  /// Get empty state padding based on context
  EdgeInsetsGeometry _getEmptyStatePadding(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;
    return EdgeInsets.all(design.designSystemSpacing.xl);
  }

  /// Get empty state spacing based on context
  double _getEmptyStateSpacing(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;
    return design.designSystemSpacing.lg;
  }

  /// Callback when empty state changes
  void Function(bool isEmpty)? get onEmptyStateChanged => null;
}

/// Configuration for empty state display
class EmptyStateConfig {
  /// Message to display in empty state
  final String message;

  /// Icon to display in empty state
  final IconData icon;

  /// Text for action button (if any)
  final String? actionText;

  /// Callback when action button is pressed
  final VoidCallback? onActionPressed;

  /// Custom widget to display instead of default empty state
  final Widget? customWidget;

  /// Type of empty state
  final EmptyStateType type;

  /// Search query for no results state
  final String? searchQuery;

  const EmptyStateConfig({
    required this.message,
    required this.icon,
    this.actionText,
    this.onActionPressed,
    this.customWidget,
    required this.type,
    this.searchQuery,
  });
}

/// Types of empty states
enum EmptyStateType {
  /// No data available
  noData,

  /// No search results found
  noResults,

  /// List/collection is empty
  emptyList,

  /// No favorite items
  noFavorites,

  /// No history available
  noHistory,

  /// No notifications
  noNotifications,

  /// No messages
  noMessages,

  /// Custom empty state
  custom,
}