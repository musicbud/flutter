import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// Utility class for showing snackbars and toasts
///
/// Example:
/// ```dart
/// SnackbarUtils.showSuccess(context, 'Song added to playlist');
/// SnackbarUtils.showError(context, 'Failed to load music');
/// ```
class SnackbarUtils {
  SnackbarUtils._(); // Private constructor to prevent instantiation

  /// Show a success snackbar
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _show(
      context,
      message,
      backgroundColor: DesignSystem.success,
      icon: Icons.check_circle,
      duration: duration,
      action: action,
    );
  }

  /// Show an error snackbar
  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    _show(
      context,
      message,
      backgroundColor: DesignSystem.error,
      icon: Icons.error,
      duration: duration,
      action: action,
    );
  }

  /// Show a warning snackbar
  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _show(
      context,
      message,
      backgroundColor: DesignSystem.warning,
      icon: Icons.warning,
      duration: duration,
      action: action,
    );
  }

  /// Show an info snackbar
  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _show(
      context,
      message,
      backgroundColor: DesignSystem.info,
      icon: Icons.info,
      duration: duration,
      action: action,
    );
  }

  /// Show a basic snackbar
  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    IconData? icon,
    SnackBarAction? action,
  }) {
    _show(
      context,
      message,
      backgroundColor: backgroundColor ?? DesignSystem.surfaceContainer,
      icon: icon,
      duration: duration,
      action: action,
    );
  }

  /// Internal method to show snackbar
  static void _show(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    IconData? icon,
    required Duration duration,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final snackBar = SnackBar(
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: DesignSystem.spacingSM),
          ],
          Expanded(
            child: Text(
              message,
              style: DesignSystem.bodyMedium.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
      ),
      action: action,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Show a snackbar with an undo action
  static void showWithUndo(
    BuildContext context,
    String message,
    VoidCallback onUndo, {
    Duration duration = const Duration(seconds: 5),
  }) {
    _show(
      context,
      message,
      backgroundColor: DesignSystem.surfaceContainerHigh,
      duration: duration,
      action: SnackBarAction(
        label: 'Undo',
        textColor: DesignSystem.primary,
        onPressed: onUndo,
      ),
    );
  }

  /// Show a loading snackbar
  static void showLoading(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final snackBar = SnackBar(
      content: Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(width: DesignSystem.spacingMD),
          Expanded(
            child: Text(
              message,
              style: DesignSystem.bodyMedium.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: DesignSystem.surfaceContainerHigh,
      duration: const Duration(days: 1), // Won't auto-dismiss
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Hide the current snackbar
  static void hide(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}

/// Extension on BuildContext for easier snackbar access
extension SnackbarExtension on BuildContext {
  /// Show success snackbar
  void showSuccess(String message) {
    SnackbarUtils.showSuccess(this, message);
  }

  /// Show error snackbar
  void showError(String message) {
    SnackbarUtils.showError(this, message);
  }

  /// Show warning snackbar
  void showWarning(String message) {
    SnackbarUtils.showWarning(this, message);
  }

  /// Show info snackbar
  void showInfo(String message) {
    SnackbarUtils.showInfo(this, message);
  }

  /// Show basic snackbar
  void showSnackbar(String message) {
    SnackbarUtils.show(this, message);
  }

  /// Hide current snackbar
  void hideSnackbar() {
    SnackbarUtils.hide(this);
  }
}

/// Toast-style notifications (shorter duration, less obtrusive)
class ToastUtils {
  ToastUtils._();

  /// Show a short toast message
  static void show(BuildContext context, String message) {
    SnackbarUtils.show(
      context,
      message,
      duration: const Duration(seconds: 2),
    );
  }

  /// Show a success toast
  static void showSuccess(BuildContext context, String message) {
    SnackbarUtils.showSuccess(
      context,
      message,
      duration: const Duration(seconds: 2),
    );
  }

  /// Show an error toast
  static void showError(BuildContext context, String message) {
    SnackbarUtils.showError(
      context,
      message,
      duration: const Duration(seconds: 2),
    );
  }
}
