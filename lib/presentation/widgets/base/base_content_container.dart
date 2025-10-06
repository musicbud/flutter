import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// Abstract base class for content containers that display lists or grids of items.
/// Provides common functionality for loading states, empty states, and pagination.
///
/// **Common Properties:**
/// - [items] - List of items to display
/// - [itemBuilder] - Function to build widgets for each item
/// - [isLoading] - Whether content is currently loading
/// - [emptyState] - Custom widget for empty state
/// - [onLoadMore] - Callback for pagination
/// - [hasMoreItems] - Whether more items can be loaded
/// - [scrollController] - Controller for scrollable content
/// - [physics] - Scroll physics for the content
///
/// **Common Methods:**
/// - [_buildLoadingState] - Loading state widget (must be implemented)
/// - [_buildEmptyState] - Empty state widget (must be implemented)
/// - [_handlePagination] - Pagination logic (must be implemented)
/// - [_buildDefaultLoadingIndicator] - Default loading indicator
/// - [_buildDefaultEmptyState] - Default empty state
///
/// **Usage:**
/// ```dart
/// class CustomList extends BaseContentContainer<Item> {
///   const CustomList({
///     super.key,
///     required super.items,
///     required super.itemBuilder,
///     super.isLoading = false,
///   });
///
///   @override
///   Widget _buildLoadingState() {
///     return ListView(
///       // Custom loading layout
///     );
///   }
///
///   @override
///   Widget _buildEmptyState() {
///     return Center(child: Text('No items'));
///   }
///
///   @override
///   void _handlePagination() {
///     // Custom pagination logic
///   }
/// }
/// ```
abstract class BaseContentContainer<T> extends StatelessWidget {
  /// List of items to display in the container
  final List<T> items;

  /// Function to build widgets for each item
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// Whether the container is currently loading
  final bool isLoading;

  /// Custom widget to display when items is empty
  final Widget? emptyState;

  /// Callback when more items should be loaded (pagination)
  final VoidCallback? onLoadMore;

  /// Whether there are more items available for loading
  final bool hasMoreItems;

  /// Controller for the scrollable content
  final ScrollController? scrollController;

  /// Scroll physics for the content
  final ScrollPhysics? physics;

  /// Padding around the entire content container
  final EdgeInsetsGeometry? padding;

  /// Whether to shrink wrap the content
  final bool shrinkWrap;

  /// Constructor for BaseContentContainer
  const BaseContentContainer({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.isLoading = false,
    this.emptyState,
    this.onLoadMore,
    this.hasMoreItems = false,
    this.scrollController,
    this.physics,
    this.padding,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    // Show loading state if items are empty and currently loading
    if (items.isEmpty && isLoading) {
      return _buildLoadingState();
    }

    // Show empty state if no items and not loading
    if (items.isEmpty) {
      return emptyState ?? _buildDefaultEmptyState();
    }

    // Build main content with pagination support
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: _buildContent(context),
    );
  }

  /// Build the main content layout - must be implemented by subclasses
  /// This should return the primary list/grid layout
  @protected
  Widget _buildContent(BuildContext context);

  /// Build loading state widget - must be implemented by subclasses
  /// This should return the loading UI when items are empty and loading
  @protected
  Widget _buildLoadingState();

  /// Build empty state widget - must be implemented by subclasses
  /// This should return the empty state UI when no items are available
  @protected
  Widget _buildEmptyState();

  /// Handle pagination logic - must be implemented by subclasses
  /// This should trigger loading more items when appropriate
  @protected
  void _handlePagination();

  /// Build default loading indicator for pagination
  @protected
  Widget _buildDefaultLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }

  /// Build default empty state widget
  @protected
  Widget _buildDefaultEmptyState() {
    return Center(
      child: Text(
        'No items to display',
        style: TextStyle(
          color: DesignSystem.onSurfaceVariant,
          fontSize: 16,
        ),
      ),
    );
  }

  /// Helper method to trigger pagination with post-frame callback
  @protected
  void triggerLoadMore() {
    if (onLoadMore != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onLoadMore!();
      });
    }
  }

  /// Helper method to get responsive cross axis count for grids
  @protected
  int getResponsiveCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) return 2;        // Mobile: 2 columns
    if (width < 900) return 3;        // Tablet: 3 columns
    if (width < 1200) return 4;       // Small desktop: 4 columns
    return 5;                         // Large desktop: 5 columns
  }

  /// Helper method to get default scroll physics
  @protected
  ScrollPhysics getDefaultScrollPhysics() {
    return const AlwaysScrollableScrollPhysics();
  }

  /// Helper method to get design system colors
  @protected
  DesignSystemColors getDesignSystemColors(BuildContext context) {
    return Theme.of(context).designSystemColors ?? DesignSystemColors(
      primary: DesignSystem.primary,
      secondary: DesignSystem.secondary,
      surface: DesignSystem.surface,
      background: DesignSystem.background,
      onSurface: DesignSystem.onSurface,
      onSurfaceVariant: DesignSystem.onSurfaceVariant,
      error: DesignSystem.error,
      success: DesignSystem.success,
      warning: DesignSystem.warning,
      info: DesignSystem.info,
      accentBlue: DesignSystem.accentBlue,
      accentPurple: DesignSystem.accentPurple,
      accentGreen: DesignSystem.accentGreen,
      accentOrange: DesignSystem.accentOrange,
      border: DesignSystem.border,
      overlay: DesignSystem.overlay,
      surfaceContainer: DesignSystem.surfaceContainer,
      surfaceContainerHigh: DesignSystem.surfaceContainerHigh,
      surfaceContainerHighest: DesignSystem.surfaceContainerHighest,
      onPrimary: DesignSystem.onPrimary,
      onError: DesignSystem.onError,
      onErrorContainer: DesignSystem.onErrorContainer,
    );
  }

  /// Helper method to get design system typography
  @protected
  DesignSystemTypography getDesignSystemTypography(BuildContext context) {
    return Theme.of(context).designSystemTypography ?? DesignSystemTypography(
      displayLarge: DesignSystem.displayLarge,
      displayMedium: DesignSystem.displayMedium,
      displaySmall: DesignSystem.displaySmall,
      headlineLarge: DesignSystem.headlineLarge,
      headlineMedium: DesignSystem.headlineMedium,
      headlineSmall: DesignSystem.headlineSmall,
      titleLarge: DesignSystem.titleLarge,
      titleMedium: DesignSystem.titleMedium,
      titleSmall: DesignSystem.titleSmall,
      bodyLarge: DesignSystem.bodyLarge,
      bodyMedium: DesignSystem.bodyMedium,
      bodySmall: DesignSystem.bodySmall,
      labelLarge: DesignSystem.labelLarge,
      labelMedium: DesignSystem.labelMedium,
      labelSmall: DesignSystem.labelSmall,
      caption: DesignSystem.caption,
      overline: DesignSystem.overline,
      arabicText: DesignSystem.arabicText,
    );
  }

  /// Helper method to get design system spacing
  @protected
  DesignSystemSpacing getDesignSystemSpacing(BuildContext context) {
    return Theme.of(context).designSystemSpacing ?? const DesignSystemSpacing();
  }

  /// Helper method to get design system radius
  @protected
  DesignSystemRadius getDesignSystemRadius(BuildContext context) {
    return Theme.of(context).designSystemRadius ?? const DesignSystemRadius();
  }
}