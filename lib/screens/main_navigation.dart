import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/simple_auth_bloc.dart';
import '../blocs/simple_content_bloc.dart';
import 'home_screen.dart';
import 'discover_screen.dart';
import 'library_screen.dart';
import 'buds_screen.dart';
import 'chat_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home,
      label: 'Home',
      screen: const HomeScreen(),
    ),
    NavigationItem(
      icon: Icons.explore,
      label: 'Discover',
      screen: const DiscoverScreen(),
    ),
    NavigationItem(
      icon: Icons.library_music,
      label: 'Library',
      screen: const LibraryScreen(),
    ),
    NavigationItem(
      icon: Icons.people,
      label: 'Buds',
      screen: const BudsScreen(),
    ),
    NavigationItem(
      icon: Icons.chat,
      label: 'Chat',
      screen: const ChatScreen(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Load initial content for all sections
    _loadInitialContent();
  }

  void _loadInitialContent() {
    final contentBloc = context.read<SimpleContentBloc>();
    contentBloc.add(LoadTopTracks());
    contentBloc.add(LoadTopArtists());
    contentBloc.add(LoadBuds());
    contentBloc.add(LoadChats());
    contentBloc.add(LoadPlaylists());
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_navigationItems[_currentIndex].label),
        actions: [
          // User profile button
          BlocBuilder<SimpleAuthBloc, SimpleAuthState>(
            builder: (context, state) {
              if (state is SimpleAuthAuthenticated) {
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.account_circle),
                  onSelected: (value) {
                    switch (value) {
                      case 'profile':
                        _showUserProfile(state.user);
                        break;
                      case 'settings':
                        _showSettings();
                        break;
                      case 'logout':
                        context.read<SimpleAuthBloc>().add(SimpleLogoutRequested());
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'profile',
                      child: Row(
                        children: [
                          const Icon(Icons.person),
                          const SizedBox(width: 8),
                          Text(state.user['displayName'] ?? 'Profile'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'settings',
                      child: Row(
                        children: [
                          Icon(Icons.settings),
                          SizedBox(width: 8),
                          Text('Settings'),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout),
                          SizedBox(width: 8),
                          Text('Logout'),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _navigationItems.map((item) => item.screen).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        items: _navigationItems
            .map((item) => BottomNavigationBarItem(
                  icon: Icon(item.icon),
                  label: item.label,
                ))
            .toList(),
      ),
      floatingActionButton: _currentIndex == 0 // Only show on Home tab
          ? FloatingActionButton(
              onPressed: () {
                context.read<SimpleContentBloc>().add(RefreshContent());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Refreshing content...')),
                );
              },
              tooltip: 'Refresh',
              child: const Icon(Icons.refresh),
            )
          : null,
    );
  }

  void _showUserProfile(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('User Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username: ${user['username'] ?? 'Unknown'}'),
            Text('Display Name: ${user['displayName'] ?? 'Unknown'}'),
            Text('Email: ${user['email'] ?? 'Unknown'}'),
            Text('Followers: ${user['followerCount'] ?? 0}'),
            Text('Following: ${user['followingCount'] ?? 0}'),
            if (user['bio'] != null) ...[
              const SizedBox(height: 8),
              Text('Bio: ${user['bio']}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              subtitle: Text('Manage notification preferences'),
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text('Privacy'),
              subtitle: Text('Control privacy settings'),
            ),
            ListTile(
              leading: Icon(Icons.palette),
              title: Text('Theme'),
              subtitle: Text('Choose app appearance'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final Widget screen;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.screen,
  });
}