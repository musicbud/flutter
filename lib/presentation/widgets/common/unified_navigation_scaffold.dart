import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../mixins/page_mixin.dart';
import 'app_bottom_navigation_bar.dart';

/// A unified scaffold that manages all navigation elements to prevent overlapping
class UnifiedNavigationScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final List<Widget>? appBarActions;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool showAppBar;
  final bool showBottomNavigation;
  final bool showTopActions;
  final int? currentBottomNavIndex;
  final ValueChanged<int>? onBottomNavTap;
  final List<NavigationItem>? bottomNavItems;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;
  final EdgeInsets? bodyPadding;

  const UnifiedNavigationScaffold({
    Key? key,
    required this.body,
    this.title,
    this.appBarActions,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.showAppBar = true,
    this.showBottomNavigation = false,
    this.showTopActions = false,
    this.currentBottomNavIndex,
    this.onBottomNavTap,
    this.bottomNavItems,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.bodyPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppConstants.backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: showAppBar ? _buildAppBar(context) : null,
      body: _buildBody(context),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: _getFloatingActionButtonLocation(),
      bottomNavigationBar: showBottomNavigation ? _buildBottomNavigation() : null,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppConstants.backgroundColor,
      elevation: 0,
      title: title != null
          ? Text(
              title!,
              style: AppConstants.headingStyle.copyWith(fontSize: 20),
            )
          : null,
      actions: _buildAppBarActions(context),
      leading: Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: AppConstants.textColor,
              ),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      automaticallyImplyLeading: Navigator.canPop(context),
    );
  }

  List<Widget>? _buildAppBarActions(BuildContext context) {
    final actions = <Widget>[];

    // Add custom actions first
    if (appBarActions != null) {
      actions.addAll(appBarActions!);
    }

    // Add top actions if enabled
    if (showTopActions) {
      actions.addAll([
        IconButton(
          icon: const Icon(
            Icons.notifications_outlined,
            color: AppConstants.textColor,
          ),
          onPressed: () => _showNotifications(context),
        ),
        PopupMenuButton<String>(
          icon: const Icon(
            Icons.more_vert,
            color: AppConstants.textColor,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (value) => _handleTopAction(context, value),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  Icon(Icons.person_outline),
                  SizedBox(width: 8),
                  Text('Profile'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.settings_outlined),
                  SizedBox(width: 8),
                  Text('Settings'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'services',
              child: Row(
                children: [
                  Icon(Icons.connect_without_contact),
                  SizedBox(width: 8),
                  Text('Connect Services'),
                ],
              ),
            ),
          ],
        ),
      ]);
    }

    return actions.isNotEmpty ? actions : null;
  }

  Widget _buildBody(BuildContext context) {
    Widget bodyWidget = body;

    // Add padding if specified
    if (bodyPadding != null) {
      bodyWidget = Padding(
        padding: bodyPadding!,
        child: bodyWidget,
      );
    }

    // Add safe area for proper spacing
    bodyWidget = SafeArea(
      child: bodyWidget,
    );

    return bodyWidget;
  }

  Widget? _buildFloatingActionButton() {
    if (floatingActionButton == null) return null;

    // Ensure FAB doesn't overlap with bottom navigation
    if (showBottomNavigation) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16), // Add space above bottom nav
        child: floatingActionButton,
      );
    }

    return floatingActionButton;
  }

  FloatingActionButtonLocation _getFloatingActionButtonLocation() {
    if (floatingActionButtonLocation != null) {
      return floatingActionButtonLocation!;
    }

    // Default location that works with bottom navigation
    if (showBottomNavigation) {
      return FloatingActionButtonLocation.endFloat;
    }

    return FloatingActionButtonLocation.endFloat;
  }

  Widget? _buildBottomNavigation() {
    if (!showBottomNavigation ||
        bottomNavItems == null ||
        currentBottomNavIndex == null ||
        onBottomNavTap == null) {
      return null;
    }

    return AppBottomNavigationBar(
      currentIndex: currentBottomNavIndex!,
      onTap: onBottomNavTap!,
      items: bottomNavItems!,
      borderColor: AppConstants.primaryColor,
      enableBlur: true,
      enableGradient: true,
    );
  }

  void _showNotifications(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notifications clicked'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _handleTopAction(BuildContext context, String action) {
    switch (action) {
      case 'profile':
        Navigator.of(context).pushNamed(AppConstants.profileRoute);
        break;
      case 'settings':
        Navigator.of(context).pushNamed('/settings');
        break;
      case 'services':
        Navigator.of(context).pushNamed('/services');
        break;
    }
  }
}

/// Extension to provide easy access to unified scaffold from any widget with PageMixin
extension UnifiedNavigationExtension on State {
  Widget buildUnifiedPage({
    required Widget body,
    String? title,
    List<Widget>? appBarActions,
    Widget? floatingActionButton,
    bool showAppBar = true,
    bool showBottomNavigation = false,
    bool showTopActions = false,
    int? currentBottomNavIndex,
    ValueChanged<int>? onBottomNavTap,
    List<NavigationItem>? bottomNavItems,
    EdgeInsets? bodyPadding,
  }) {
    return UnifiedNavigationScaffold(
      body: body,
      title: title,
      appBarActions: appBarActions,
      floatingActionButton: floatingActionButton,
      showAppBar: showAppBar,
      showBottomNavigation: showBottomNavigation,
      showTopActions: showTopActions,
      currentBottomNavIndex: currentBottomNavIndex,
      onBottomNavTap: onBottomNavTap,
      bottomNavItems: bottomNavItems,
      bodyPadding: bodyPadding,
    );
  }
}

/// Specialized scaffold for main navigation screens
class MainNavigationScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onNavigationTap;
  final List<NavigationItem> navigationItems;
  final Widget? floatingActionButton;

  const MainNavigationScaffold({
    Key? key,
    required this.body,
    required this.currentIndex,
    required this.onNavigationTap,
    required this.navigationItems,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedNavigationScaffold(
      body: body,
      showAppBar: false, // Main navigation handles its own header
      showBottomNavigation: true,
      showTopActions: false, // Handled by individual pages
      currentBottomNavIndex: currentIndex,
      onBottomNavTap: onNavigationTap,
      bottomNavItems: navigationItems,
      floatingActionButton: floatingActionButton,
      bodyPadding: EdgeInsets.zero, // No padding for main navigation
    );
  }
}

/// Specialized scaffold for content pages
class ContentPageScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showTopActions;

  const ContentPageScaffold({
    Key? key,
    required this.body,
    required this.title,
    this.actions,
    this.floatingActionButton,
    this.showTopActions = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedNavigationScaffold(
      body: body,
      title: title,
      appBarActions: actions,
      floatingActionButton: floatingActionButton,
      showAppBar: true,
      showBottomNavigation: false,
      showTopActions: showTopActions,
      bodyPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}