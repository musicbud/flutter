import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// A full-screen loading overlay with dimmed background
/// 
/// Prevents user interaction during loading operations.
/// Can be used with a Stack or as a modal overlay.
/// 
/// Example:
/// ```dart
/// Stack(
///   children: [
///     // Your main content
///     YourContentWidget(),
///     
///     // Show overlay when loading
///     if (isLoading)
///       LoadingOverlay(
///         message: 'Loading your music...',
///       ),
///   ],
/// )
/// ```
class LoadingOverlay extends StatelessWidget {
  /// Optional message to display below the loading indicator
  final String? message;

  /// Color of the overlay background
  final Color? backgroundColor;

  /// Opacity of the overlay (0.0 to 1.0)
  final double opacity;

  /// Color of the loading indicator
  final Color? indicatorColor;

  /// Size of the loading indicator
  final double indicatorSize;

  /// Whether to show the message
  final bool showMessage;

  const LoadingOverlay({
    super.key,
    this.message,
    this.backgroundColor,
    this.opacity = 0.7,
    this.indicatorColor,
    this.indicatorSize = 50.0,
    this.showMessage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: (backgroundColor ?? Colors.black).withValues(alpha: opacity),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Loading indicator
            SizedBox(
              width: indicatorSize,
              height: indicatorSize,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(
                  indicatorColor ?? DesignSystem.primary,
                ),
              ),
            ),

            // Message
            if (showMessage && message != null) ...[
              const SizedBox(height: DesignSystem.spacingLG),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingXL),
                child: Text(
                  message!,
                  style: DesignSystem.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Helper method to show loading overlay as a modal
  /// 
  /// Example:
  /// ```dart
  /// // Show loading
  /// LoadingOverlay.show(context, message: 'Processing...');
  /// 
  /// // Do async work
  /// await someAsyncOperation();
  /// 
  /// // Hide loading
  /// LoadingOverlay.hide(context);
  /// ```
  static void show(
    BuildContext context, {
    String? message,
    Color? backgroundColor,
    double opacity = 0.7,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) => PopScope(
        canPop: false, // Prevent back button
        child: LoadingOverlay(
          message: message,
          backgroundColor: backgroundColor,
          opacity: opacity,
        ),
      ),
    );
  }

  /// Hide the loading overlay
  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}

/// A widget that wraps content and shows loading overlay when needed
/// 
/// Example:
/// ```dart
/// LoadingOverlayWrapper(
///   isLoading: isProcessing,
///   message: 'Saving changes...',
///   child: YourFormWidget(),
/// )
/// ```
class LoadingOverlayWrapper extends StatelessWidget {
  /// The content to display
  final Widget child;

  /// Whether to show the loading overlay
  final bool isLoading;

  /// Optional message to display
  final String? message;

  /// Color of the overlay background
  final Color? backgroundColor;

  /// Opacity of the overlay
  final double opacity;

  const LoadingOverlayWrapper({
    super.key,
    required this.child,
    required this.isLoading,
    this.message,
    this.backgroundColor,
    this.opacity = 0.7,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: LoadingOverlay(
              message: message,
              backgroundColor: backgroundColor,
              opacity: opacity,
            ),
          ),
      ],
    );
  }
}
