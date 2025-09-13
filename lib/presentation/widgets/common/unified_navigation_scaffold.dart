import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../mixins/page_mixin.dart';
import 'app_bottom_navigation_bar.dart';

/// A unified scaffold that manages all navigation elements to prevent overlapping
class UnifiedNavigationScaffold extends StatefulWidget {
  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onNavigationTap;
  final List<NavigationItem> navigationItems;
  final bool showAppBar;
  final String? appBarTitle;
  final List<Widget>? appBarActions;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const UnifiedNavigationScaffold({
    Key? key,
    required this.body,
    required this.currentIndex,
    required this.onNavigationTap,
    required this.navigationItems,
    this.showAppBar = true,
    this.appBarTitle,
    this.appBarActions,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  }) : super(key: key);

  @override
  State<UnifiedNavigationScaffold> createState() => _UnifiedNavigationScaffoldState();
}

class _UnifiedNavigationScaffoldState extends State<UnifiedNavigationScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.body,
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: widget.onNavigationTap,
        items: widget.navigationItems,
      ),
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
    );
  }
}

/// Extension to provide easy access to unified scaffold from any widget with PageMixin
extension UnifiedNavigationExtension on State {
  Widget buildUnifiedPage({
    required Widget body,
    required int currentIndex,
    required ValueChanged<int> onNavigationTap,
    required List<NavigationItem> navigationItems,
    String? appBarTitle,
    List<Widget>? appBarActions,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    bool showAppBar = true,
  }) {
    return UnifiedNavigationScaffold(
      body: body,
      currentIndex: currentIndex,
      onNavigationTap: onNavigationTap,
      navigationItems: navigationItems,
      showAppBar: showAppBar,
      appBarTitle: appBarTitle,
      appBarActions: appBarActions,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
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
    return Column(
      children: [
        Expanded(
          child: body,
        ),
        // Bottom navigation
        AppBottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onNavigationTap,
          items: navigationItems,
        ),
      ],
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
      currentIndex: 0, // Default or pass an appropriate index
      onNavigationTap: (index) {},
      navigationItems: const [], // Default or pass an appropriate list
      showAppBar: true,
      appBarTitle: title,
      appBarActions: actions,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}