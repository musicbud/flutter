import 'package:flutter/material.dart';
import 'main_navigation.dart';
import '../utils/logger.dart';
import '../navigation/navigation_items.dart';
import '../navigation/navigation_constants.dart';
import '../presentation/screens/home/dynamic_home_screen.dart';
import '../presentation/screens/discover/dynamic_discover_screen.dart';
import '../presentation/screens/library/dynamic_library_screen.dart';
import '../presentation/screens/chat/dynamic_chat_screen.dart';
import '../presentation/screens/profile/dynamic_profile_screen.dart';

class MainNavigationScaffold extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScaffold({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigationScaffold> createState() => MainNavigationScaffoldState();
}

class MainNavigationScaffoldState extends State<MainNavigationScaffold> {
  late int _currentIndex;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pages = mainNavigationItems.map((item) => _getPageForRoute(item.route)).toList();
    logger.d('MainNavigationScaffold initialized with initialIndex: ${widget.initialIndex}');
  }

  Widget _getPageForRoute(String route) {
    logger.d('Getting page for route: $route');
    switch (route) {
      case NavigationConstants.home:
        return const DynamicHomeScreen();
      case NavigationConstants.discover:
        return const DynamicDiscoverScreen();
      case NavigationConstants.library:
        return const DynamicLibraryScreen();
      case NavigationConstants.chat:
        return const DynamicChatScreen();
      case NavigationConstants.profile:
        return const DynamicProfileScreen();
      default:
        logger.w('Unknown route: $route, returning empty widget');
        return const SizedBox();
    }
  }

  void _onTap(int index) {
    logger.d('Navigation item tapped in MainNavigationScaffold: $index, route: ${mainNavigationItems[index].route}');
    setState(() {
      _currentIndex = index;
    });
    logger.d('State updated, currentIndex: $_currentIndex, showing page: ${mainNavigationItems[_currentIndex].label}');
  }

  @override
  Widget build(BuildContext context) {
    logger.d('Building MainNavigationScaffold with currentIndex: $_currentIndex');
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: MainNavigation(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}