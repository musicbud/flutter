import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';
import '../../navigation/navigation_constants.dart';

/// Custom app bar for the main navigation screen
class CustomAppBar extends StatelessWidget {
  final VoidCallback? onMenuPressed;
  final VoidCallback? onNotificationsPressed;
  final String title;
  final Color? backgroundColor;
  final Color? textColor;
  final NavigationConfig? config;

  const CustomAppBar({
    super.key,
    this.onMenuPressed,
    this.onNotificationsPressed,
    this.title = NavigationConstants.defaultAppTitle,
    this.backgroundColor,
    this.textColor,
    this.config,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveConfig = config ?? const NavigationConfig();
    final effectiveBackgroundColor = backgroundColor ??
        effectiveConfig.backgroundColor ??
        DesignSystem.primary;
    final effectiveTextColor = textColor ??
        effectiveConfig.selectedColor ??
        Colors.white;

    return Container(
      color: effectiveBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.menu, color: effectiveTextColor),
              onPressed: onMenuPressed,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: effectiveTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.notifications_outlined, color: effectiveTextColor),
              onPressed: onNotificationsPressed,
            ),
          ],
        ),
      ),
    );
  }
}