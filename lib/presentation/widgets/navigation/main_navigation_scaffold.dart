import 'package:flutter/material.dart';
import '../../navigation/main_navigation.dart';
import '../../navigation/navigation_drawer.dart';
import '../../navigation/navigation_items.dart';
import 'custom_app_bar.dart';
import '../../widgets/common/app_bottom_navigation_bar.dart';

/// Main navigation scaffold that combines app bar, drawer, and bottom navigation
class MainNavigationScaffold extends StatefulWidget {
  final MainNavigationController navigationController;
  final Widget? body;
  final Color backgroundColor;
  final VoidCallback? onNotificationsPressed;

  const MainNavigationScaffold({
    super.key,
    required this.navigationController,
    this.body,
    this.backgroundColor = Colors.black,
    this.onNotificationsPressed,
  });

  @override
  State<MainNavigationScaffold> createState() => _MainNavigationScaffoldState();
}

class _MainNavigationScaffoldState extends State<MainNavigationScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MainNavigationDrawer(
        navigationController: widget.navigationController,
      ),
      backgroundColor: widget.backgroundColor,
      body: Column(
        children: [
          // Custom App Bar
          CustomAppBar(
            onMenuPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            onNotificationsPressed: widget.onNotificationsPressed,
          ),
          // Main Navigation Content
          Expanded(
            child: widget.body ?? _buildNavigationContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationContent() {
    return Column(
      children: [
        Expanded(
          child: widget.navigationController.getCurrentPage(context),
        ),
        // Bottom navigation
        AppBottomNavigationBar(
          currentIndex: widget.navigationController.selectedIndex,
          onTap: (index) => widget.navigationController.onNavigationItemTapped(index, context),
          items: mainNavigationItems,
        ),
      ],
    );
  }
}