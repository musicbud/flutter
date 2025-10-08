import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../blocs/profile/profile_event.dart';
import '../../blocs/likes/likes_bloc.dart';
import '../../blocs/likes/likes_event.dart';
import '../../blocs/chat/chat_bloc.dart';
import '../../blocs/chat/chat_event.dart';
import 'navigation_items.dart';
import '../../../utils/logger.dart';
import '../../../core/error/error_handler.dart';

/// Main navigation controller that manages navigation state and data loading
class MainNavigationController extends ChangeNotifier {
  int _selectedIndex = 0;
  final bool _isLoading = false;

  int get selectedIndex => _selectedIndex;
  bool get isLoading => _isLoading;

  /// Handle navigation item tap
  void onNavigationItemTapped(int index, BuildContext context) {
    if (index != _selectedIndex) {
      logger.d('Navigation item tapped: $index (${mainNavigationItems[index].label})');
      _selectedIndex = index;
      notifyListeners();
      _loadTabData(index, context);
      _navigateToPage(index, context);
    }
  }

  /// Load data for the selected tab
  void _loadTabData(int index, BuildContext context) {
    switch (index) {
      case 0: // Home
        _loadHomeData(context);
        break;
      case 1: // Discover
        // Discover data loaded by the discover page
        break;
      case 2: // Library
        // Library data loaded by the library page
        break;
      case 3: // Chat
        context.read<ChatBloc>().add(ChatUserListRequested());
        break;
      case 4: // Profile
        // Profile data loaded by the profile page
        break;
    }
  }

  /// Load home data
  void _loadHomeData(BuildContext context) {
    // Load home data
    context.read<ProfileBloc>().add(ProfileRequested());
    context.read<LikesBloc>().add(const LikesUpdateRequested('general'));
  }

  /// Get the current page widget
  Widget getCurrentPage(BuildContext context) {
    final pageBuilder = mainNavigationItems[_selectedIndex].pageBuilder;
    if (pageBuilder != null) {
      return pageBuilder(context);
    }
    // Fallback to a default page if pageBuilder is null
    return const Scaffold(
      body: Center(
        child: Text('Page not available'),
      ),
    );
  }

  /// Navigate to a specific page by index
  void navigateToPage(int index, BuildContext context) {
    onNavigationItemTapped(index, context);
  }

  /// Navigate to the selected page
  void _navigateToPage(int index, BuildContext context) {
    final route = mainNavigationItems[index].route;
    ErrorHandler.logNavigationEvent(
      ModalRoute.of(context)?.settings.name ?? 'unknown',
      route,
      method: 'bottom_navigation'
    );
    Navigator.pushNamedAndRemoveUntil(
      context,
      route,
      (route) => false, // Remove all previous routes
    );
  }
}