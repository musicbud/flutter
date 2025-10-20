import 'package:flutter/material.dart';

/// Enhanced scaffold components for consistent app structure and navigation
/// 
/// This file provides reusable scaffold variations for different use cases:
/// - UnifiedNavigationScaffold: Complete navigation wrapper
/// - MainNavigationScaffold: Simple main navigation
/// - ContentPageScaffold: Content pages with optional nav
/// - ModalScaffold: Modal/dialog-style pages

/// A unified scaffold that manages all navigation elements consistently
/// 
/// Perfect for main app pages with bottom navigation.
/// 
/// Example:
/// ```dart
/// UnifiedNavigationScaffold(
///   body: HomePageContent(),
///   currentIndex: 0,
///   onNavigationTap: (index) => navigateTo(index),
///   items: [
///     NavigationItem(icon: Icons.home, label: 'Home'),
///     NavigationItem(icon: Icons.search, label: 'Search'),
///   ],
///   floatingActionButton: FloatingActionButton(...),
/// )
/// ```
class UnifiedNavigationScaffold extends StatelessWidget {
  /// Main content body
  final Widget body;
  
  /// Current selected navigation index
  final int currentIndex;
  
  /// Callback when navigation item is tapped
  final ValueChanged<int> onNavigationTap;
  
  /// Navigation items for bottom nav bar
  final List<BottomNavigationBarItem> items;
  
  /// Whether to show app bar
  final bool showAppBar;
  
  /// App bar title (if showAppBar is true)
  final String? appBarTitle;
  
  /// App bar actions (if showAppBar is true)
  final List<Widget>? appBarActions;
  
  /// Floating action button (optional)
  final Widget? floatingActionButton;
  
  /// Location for the floating action button
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  
  /// Background color for the scaffold
  final Color? backgroundColor;
  
  /// Whether bottom nav should be elevated
  final bool elevateBottomNav;

  const UnifiedNavigationScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onNavigationTap,
    required this.items,
    this.showAppBar = false,
    this.appBarTitle,
    this.appBarActions,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backgroundColor,
    this.elevateBottomNav = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: showAppBar
          ? AppBar(
              title: Text(appBarTitle ?? ''),
              actions: appBarActions,
              elevation: 0,
            )
          : null,
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onNavigationTap,
        items: items,
        type: BottomNavigationBarType.fixed,
        elevation: elevateBottomNav ? 8 : 0,
        selectedFontSize: 12,
        unselectedFontSize: 12,
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}

/// Main navigation scaffold without app bar - pure bottom nav layout
/// 
/// Perfect for main screens where body has its own header/title.
/// 
/// Example:
/// ```dart
/// MainNavigationScaffold(
///   body: CustomScrollView(...),
///   currentIndex: _selectedIndex,
///   onNavigationTap: (index) => setState(() => _selectedIndex = index),
///   items: bottomNavItems,
/// )
/// ```
class MainNavigationScaffold extends StatelessWidget {
  /// Main content body
  final Widget body;
  
  /// Current selected navigation index
  final int currentIndex;
  
  /// Callback when navigation item is tapped
  final ValueChanged<int> onNavigationTap;
  
  /// Navigation items for bottom nav bar
  final List<BottomNavigationBarItem> items;
  
  /// Optional floating action button
  final Widget? floatingActionButton;
  
  /// Background color for the scaffold
  final Color? backgroundColor;

  const MainNavigationScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onNavigationTap,
    required this.items,
    this.floatingActionButton,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Expanded(child: body),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onNavigationTap,
        items: items,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}

/// Content page scaffold for detail/content pages
/// 
/// Perfect for detail pages, settings, profiles with optional navigation.
/// 
/// Example:
/// ```dart
/// ContentPageScaffold(
///   title: 'Song Details',
///   body: SongDetailsContent(),
///   actions: [
///     IconButton(icon: Icon(Icons.share), onPressed: () => share()),
///   ],
///   showBottomNav: false, // Hide bottom nav for detail pages
/// )
/// ```
class ContentPageScaffold extends StatelessWidget {
  /// Main content body
  final Widget body;
  
  /// Page title for app bar
  final String title;
  
  /// App bar actions (optional)
  final List<Widget>? actions;
  
  /// Optional floating action button
  final Widget? floatingActionButton;
  
  /// Whether to show app bar leading (back button)
  final bool showBackButton;
  
  /// Whether to show bottom navigation
  final bool showBottomNav;
  
  /// Bottom navigation items (if showBottomNav is true)
  final List<BottomNavigationBarItem>? bottomNavItems;
  
  /// Current bottom nav index (if showBottomNav is true)
  final int bottomNavIndex;
  
  /// Bottom nav tap callback (if showBottomNav is true)
  final ValueChanged<int>? onBottomNavTap;
  
  /// Background color
  final Color? backgroundColor;
  
  /// App bar elevation
  final double appBarElevation;

  const ContentPageScaffold({
    super.key,
    required this.body,
    required this.title,
    this.actions,
    this.floatingActionButton,
    this.showBackButton = true,
    this.showBottomNav = false,
    this.bottomNavItems,
    this.bottomNavIndex = 0,
    this.onBottomNavTap,
    this.backgroundColor,
    this.appBarElevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(title),
        actions: actions,
        automaticallyImplyLeading: showBackButton,
        elevation: appBarElevation,
      ),
      body: body,
      bottomNavigationBar: showBottomNav && bottomNavItems != null
          ? BottomNavigationBar(
              currentIndex: bottomNavIndex,
              onTap: onBottomNavTap,
              items: bottomNavItems!,
              type: BottomNavigationBarType.fixed,
            )
          : null,
      floatingActionButton: floatingActionButton,
    );
  }
}

/// Modal/dialog-style scaffold for full-screen modals
/// 
/// Perfect for full-screen dialogs, forms, wizards.
/// 
/// Example:
/// ```dart
/// ModalScaffold(
///   title: 'Create Playlist',
///   body: PlaylistForm(),
///   onClose: () => Navigator.pop(context),
///   actions: [
///     TextButton(
///       onPressed: () => saveAndClose(),
///       child: Text('Save'),
///     ),
///   ],
/// )
/// ```
class ModalScaffold extends StatelessWidget {
  /// Modal content body
  final Widget body;
  
  /// Modal title
  final String title;
  
  /// Close button callback
  final VoidCallback? onClose;
  
  /// App bar actions (typically Save, Done, etc.)
  final List<Widget>? actions;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Whether to show close button (X icon)
  final bool showCloseButton;

  const ModalScaffold({
    super.key,
    required this.body,
    required this.title,
    this.onClose,
    this.actions,
    this.backgroundColor,
    this.showCloseButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(title),
        elevation: 0,
        leading: showCloseButton
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClose ?? () => Navigator.of(context).pop(),
              )
            : null,
        actions: actions,
      ),
      body: body,
    );
  }
}

/// Simple scaffold with just body - no app bar, no nav
/// 
/// Perfect for splash screens, onboarding, custom full-screen layouts.
/// 
/// Example:
/// ```dart
/// SimpleScaffold(
///   body: OnboardingFlow(),
///   backgroundColor: Colors.black,
/// )
/// ```
class SimpleScaffold extends StatelessWidget {
  /// Main content body
  final Widget body;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Whether to use SafeArea
  final bool useSafeArea;

  const SimpleScaffold({
    super.key,
    required this.body,
    this.backgroundColor,
    this.useSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = useSafeArea ? SafeArea(child: body) : body;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      body: content,
    );
  }
}
