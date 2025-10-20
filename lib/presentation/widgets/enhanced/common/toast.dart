import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// Modern snackbar with custom styles
///
/// Example:
/// ```dart
/// ModernSnackbar.show(
///   context,
///   message: 'Song added to playlist',
///   type: SnackbarType.success,
/// )
/// ```
class ModernSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
    IconData? icon,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();
    final backgroundColor = _getBackgroundColor(type, design, theme);
    final defaultIcon = _getIcon(type);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              icon ?? defaultIcon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onAction ?? () {},
              )
            : null,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(design?.designSystemRadius.md ?? 8),
        ),
      ),
    );
  }

  static Color _getBackgroundColor(
    SnackbarType type,
    DesignSystemThemeExtension? design,
    ThemeData theme,
  ) {
    switch (type) {
      case SnackbarType.success:
        return design?.designSystemColors.success ?? Colors.green;
      case SnackbarType.error:
        return design?.designSystemColors.error ?? Colors.red;
      case SnackbarType.warning:
        return design?.designSystemColors.warning ?? Colors.orange;
      case SnackbarType.info:
        return design?.designSystemColors.info ?? Colors.blue;
    }
  }

  static IconData _getIcon(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return Icons.check_circle;
      case SnackbarType.error:
        return Icons.error;
      case SnackbarType.warning:
        return Icons.warning;
      case SnackbarType.info:
        return Icons.info;
    }
  }
}

enum SnackbarType {
  success,
  error,
  warning,
  info,
}

/// Custom toast notification
class Toast {
  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 2),
    ToastPosition position = ToastPosition.bottom,
  }) {
    final overlay = Overlay.of(context);
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();

    final overlayEntry = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        type: type,
        position: position,
        backgroundColor: _getToastColor(type, design, theme),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }

  static Color _getToastColor(
    ToastType type,
    DesignSystemThemeExtension? design,
    ThemeData theme,
  ) {
    switch (type) {
      case ToastType.success:
        return design?.designSystemColors.success ?? Colors.green;
      case ToastType.error:
        return design?.designSystemColors.error ?? Colors.red;
      case ToastType.warning:
        return design?.designSystemColors.warning ?? Colors.orange;
      case ToastType.info:
        return Colors.black87;
    }
  }
}

class _ToastWidget extends StatefulWidget {
  const _ToastWidget({
    required this.message,
    required this.type,
    required this.position,
    required this.backgroundColor,
  });

  final String message;
  final ToastType type;
  final ToastPosition position;
  final Color backgroundColor;

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = Theme.of(context).extension<DesignSystemThemeExtension>();

    return Positioned(
      left: 16,
      right: 16,
      bottom: widget.position == ToastPosition.bottom ? 80 : null,
      top: widget.position == ToastPosition.top ? 80 : null,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: design?.designSystemSpacing.lg ?? 16,
              vertical: design?.designSystemSpacing.md ?? 12,
            ),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(design?.designSystemRadius.md ?? 8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              widget.message,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

enum ToastType {
  success,
  error,
  warning,
  info,
}

enum ToastPosition {
  top,
  bottom,
}

/// Floating action snackbar
class ActionSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    required String actionLabel,
    required VoidCallback onAction,
    Duration duration = const Duration(seconds: 4),
    IconData? icon,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 12),
            ],
            Expanded(child: Text(message)),
          ],
        ),
        action: SnackBarAction(
          label: actionLabel,
          textColor: design?.designSystemColors.primary ?? theme.colorScheme.primary,
          onPressed: onAction,
        ),
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(design?.designSystemRadius.md ?? 8),
        ),
      ),
    );
  }
}

/// Loading snackbar
class LoadingSnackbar {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    BuildContext context, {
    required String message,
  }) {
    final design = Theme.of(context).extension<DesignSystemThemeExtension>();

    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(message)),
          ],
        ),
        duration: const Duration(days: 1), // Keep showing
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(design?.designSystemRadius.md ?? 8),
        ),
      ),
    );
  }

  static void hide(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}

/// Notification banner
class NotificationBanner {
  static void show(
    BuildContext context, {
    required String title,
    required String message,
    IconData? icon,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onTap,
  }) {
    final overlay = Overlay.of(context);
    final theme = Theme.of(context);

    final overlayEntry = OverlayEntry(
      builder: (context) => _NotificationBannerWidget(
        title: title,
        message: message,
        icon: icon,
        onTap: onTap,
        backgroundColor: theme.colorScheme.surface,
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}

class _NotificationBannerWidget extends StatefulWidget {
  const _NotificationBannerWidget({
    required this.title,
    required this.message,
    this.icon,
    this.onTap,
    required this.backgroundColor,
  });

  final String title;
  final String message;
  final IconData? icon;
  final VoidCallback? onTap;
  final Color backgroundColor;

  @override
  State<_NotificationBannerWidget> createState() => _NotificationBannerWidgetState();
}

class _NotificationBannerWidgetState extends State<_NotificationBannerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();

    return SlideTransition(
      position: _slideAnimation,
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(design?.designSystemSpacing.md ?? 12),
            child: GestureDetector(
              onTap: widget.onTap,
              child: Container(
                padding: EdgeInsets.all(design?.designSystemSpacing.md ?? 12),
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(design?.designSystemRadius.md ?? 8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    if (widget.icon != null) ...[
                      Icon(
                        widget.icon,
                        color: design?.designSystemColors.primary ?? theme.colorScheme.primary,
                      ),
                      SizedBox(width: design?.designSystemSpacing.md ?? 12),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.title,
                            style: (design?.designSystemTypography.bodyMedium ?? theme.textTheme.bodyMedium)?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: design?.designSystemSpacing.xs ?? 4),
                          Text(
                            widget.message,
                            style: design?.designSystemTypography.bodySmall ?? theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
