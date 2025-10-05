import 'package:flutter/material.dart';
import 'app_back_button.dart';
import '../../theme/app_theme.dart';

/// A reusable app bar widget that provides consistent styling across the app
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool centerTitle;
  final Widget? titleWidget;
  final double height;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const AppAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.centerTitle = true,
    this.titleWidget,
    this.height = kToolbarHeight,
    this.showBackButton = true,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasDrawer = Scaffold.maybeOf(context)?.hasDrawer ?? false;
    final appTheme = AppTheme.of(context);
    final canPop = Navigator.of(context).canPop();
    final effectiveBackgroundColor = backgroundColor ?? Colors.black;
    final effectiveForegroundColor = foregroundColor ?? Colors.white;

    return AppBar(
      title: titleWidget ?? Text(
        title,
        style: TextStyle(
          color: effectiveForegroundColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: actions,
      leading: leading ?? (
        hasDrawer && automaticallyImplyLeading
          ? IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            )
          : (canPop && showBackButton
              ? AppBackButton(
                  color: effectiveForegroundColor,
                  onPressed: onBackPressed,
                )
              : null)
      ),
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
      iconTheme: IconThemeData(
        color: effectiveForegroundColor,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}