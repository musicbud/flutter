import 'package:flutter/material.dart';

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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: titleWidget ?? Text(
        title,
        style: TextStyle(
          color: foregroundColor ?? Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor ?? Colors.black87,
      foregroundColor: foregroundColor ?? Colors.white,
      elevation: elevation,
      centerTitle: centerTitle,
      iconTheme: IconThemeData(
        color: foregroundColor ?? Colors.white,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}