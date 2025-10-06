import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../blocs/profile/profile_event.dart';
import '../../blocs/likes/likes_bloc.dart';
import '../../blocs/likes/likes_event.dart';
import '../../blocs/chat/chat_bloc.dart';
import '../../blocs/chat/chat_event.dart';
import 'navigation_items.dart';

/// Main navigation controller that manages navigation state and data loading
class MainNavigationController extends ChangeNotifier {
  int _selectedIndex = 0;
  final bool _isLoading = false;

  int get selectedIndex => _selectedIndex;
  bool get isLoading => _isLoading;

  /// Handle navigation item tap
  void onNavigationItemTapped(int index, BuildContext context) {
    if (index != _selectedIndex) {
      _selectedIndex = index;
      notifyListeners();
      _loadTabData(index, context);
    }
  }

  /// Load data for the selected tab
  void _loadTabData(int index, BuildContext context) {
    switch (index) {
      case 0: // Home
        _loadHomeData(context);
        break;
      case 1: // Search
        // Search data loaded on demand
        break;
      case 2: // Discover
        // Discover/Buds data loaded by the discover page
        break;
      case 3: // Chat
        context.read<ChatBloc>().add(ChatUserListRequested());
        break;
      case 4: // Library/Music
        // Music data loaded by the library page
        break;
      case 5: // Profile
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
    return mainNavigationItems[_selectedIndex].pageBuilder(context);
  }

  /// Navigate to a specific page by index
  void navigateToPage(int index, BuildContext context) {
    onNavigationItemTapped(index, context);
  }
}