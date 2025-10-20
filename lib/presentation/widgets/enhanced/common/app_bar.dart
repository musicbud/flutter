import 'package:flutter/material.dart';

/// Enhanced app bar components for consistent top navigation
/// 
/// This file provides reusable app bar variations:
/// - EnhancedAppBar: Feature-rich customizable app bar
/// - SimpleAppBar: Minimal app bar for basic needs
/// - TransparentAppBar: Transparent overlay app bar
/// - GradientAppBar: App bar with gradient background

/// A feature-rich customizable app bar with advanced options
/// 
/// Perfect for most screen headers with flexible customization.
/// 
/// Example:
/// ```dart
/// EnhancedAppBar(
///   title: 'My Library',
///   actions: [
///     IconButton(icon: Icon(Icons.search), onPressed: () => search()),
///     IconButton(icon: Icon(Icons.more_vert), onPressed: () => showMenu()),
///   ],
///   showBackButton: true,
///   centerTitle: true,
/// )
/// ```
class EnhancedAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// App bar title text
  final String title;
  
  /// Custom title widget (overrides title text)
  final Widget? titleWidget;
  
  /// Action buttons (right side)
  final List<Widget>? actions;
  
  /// Custom leading widget (left side)
  final Widget? leading;
  
  /// Whether to show back button automatically
  final bool showBackButton;
  
  /// Whether to automatically show leading (back or menu)
  final bool automaticallyImplyLeading;
  
  /// Background color for the app bar
  final Color? backgroundColor;
  
  /// Foreground color (text and icons)
  final Color? foregroundColor;
  
  /// Elevation (shadow depth)
  final double elevation;
  
  /// Whether to center the title
  final bool centerTitle;
  
  /// App bar height
  final double height;
  
  /// Custom back button callback
  final VoidCallback? onBackPressed;
  
  /// Text style for the title
  final TextStyle? titleStyle;
  
  /// Whether to show a bottom border
  final bool showBottomBorder;
  
  /// Color for the bottom border
  final Color? borderColor;

  const EnhancedAppBar({
    super.key,
    required this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.centerTitle = true,
    this.height = kToolbarHeight,
    this.onBackPressed,
    this.titleStyle,
    this.showBottomBorder = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDrawer = Scaffold.maybeOf(context)?.hasDrawer ?? false;
    final canPop = Navigator.of(context).canPop();
    final effectiveBackgroundColor = backgroundColor ?? theme.appBarTheme.backgroundColor;
    final effectiveForegroundColor = foregroundColor ?? theme.appBarTheme.foregroundColor;

    Widget appBar = AppBar(
      title: titleWidget ??
          Text(
            title,
            style: titleStyle ??
                TextStyle(
                  color: effectiveForegroundColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
          ),
      actions: actions,
      leading: leading ??
          (hasDrawer && automaticallyImplyLeading
              ? IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                )
              : (canPop && showBackButton
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                    )
                  : null)),
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
      iconTheme: IconThemeData(
        color: effectiveForegroundColor,
      ),
    );

    if (showBottomBorder) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          appBar,
          Container(
            height: 1,
            color: borderColor ?? theme.dividerColor,
          ),
        ],
      );
    }

    return appBar;
  }

  @override
  Size get preferredSize => Size.fromHeight(height + (showBottomBorder ? 1 : 0));
}

/// Simple minimal app bar for basic needs
/// 
/// Perfect for simple pages that just need a title and maybe a back button.
/// 
/// Example:
/// ```dart
/// SimpleAppBar(
///   title: 'Settings',
/// )
/// ```
class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// App bar title
  final String title;
  
  /// Action buttons
  final List<Widget>? actions;
  
  /// Whether to show back button
  final bool showBackButton;

  const SimpleAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: actions,
      automaticallyImplyLeading: showBackButton,
      elevation: 0,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Transparent app bar that overlays content
/// 
/// Perfect for image headers, video players, photo galleries.
/// 
/// Example:
/// ```dart
/// TransparentAppBar(
///   title: 'Photo Gallery',
///   iconColor: Colors.white,
/// )
/// ```
class TransparentAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// App bar title
  final String title;
  
  /// Custom title widget
  final Widget? titleWidget;
  
  /// Action buttons
  final List<Widget>? actions;
  
  /// Icon color for buttons
  final Color iconColor;
  
  /// Text color for title
  final Color textColor;
  
  /// Whether to show back button
  final bool showBackButton;
  
  /// Custom back button callback
  final VoidCallback? onBackPressed;

  const TransparentAppBar({
    super.key,
    required this.title,
    this.titleWidget,
    this.actions,
    this.iconColor = Colors.white,
    this.textColor = Colors.white,
    this.showBackButton = true,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: titleWidget ??
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
      actions: actions,
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: iconColor),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: iconColor),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// App bar with gradient background
/// 
/// Perfect for colorful headers, branded pages, themed sections.
/// 
/// Example:
/// ```dart
/// GradientAppBar(
///   title: 'Discover',
///   gradient: LinearGradient(
///     colors: [Colors.purple, Colors.blue],
///   ),
/// )
/// ```
class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// App bar title
  final String title;
  
  /// Custom title widget
  final Widget? titleWidget;
  
  /// Action buttons
  final List<Widget>? actions;
  
  /// Gradient for background
  final Gradient gradient;
  
  /// Whether to show back button
  final bool showBackButton;
  
  /// Text color
  final Color textColor;
  
  /// Icon color
  final Color iconColor;
  
  /// Whether to center title
  final bool centerTitle;

  const GradientAppBar({
    super.key,
    required this.title,
    required this.gradient,
    this.titleWidget,
    this.actions,
    this.showBackButton = true,
    this.textColor = Colors.white,
    this.iconColor = Colors.white,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: gradient),
      child: AppBar(
        title: titleWidget ??
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
        actions: actions,
        leading: showBackButton && Navigator.of(context).canPop()
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: iconColor),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: centerTitle,
        iconTheme: IconThemeData(color: iconColor),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Collapsible app bar that shrinks on scroll
/// 
/// Perfect for detail pages with large headers.
/// 
/// Example:
/// ```dart
/// SliverAppBar(
///   expandedHeight: 200,
///   flexibleSpace: FlexibleSpaceBar(
///     title: Text('Song Title'),
///     background: Image.network(albumArt),
///   ),
/// )
/// ```
/// 
/// Note: Use this directly as SliverAppBar in CustomScrollView
class CollapsibleAppBar extends SliverAppBar {
  const CollapsibleAppBar({
    super.key,
    required super.title,
    super.actions,
    super.expandedHeight = 200,
    super.flexibleSpace,
    super.pinned = true,
    super.floating = false,
    super.snap = false,
  });
}
