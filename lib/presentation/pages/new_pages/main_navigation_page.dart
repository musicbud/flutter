import 'package:flutter/material.dart';
import 'admin_dashboard_page.dart';
import 'channel_management_page.dart';
import 'user_management_page.dart';
import 'service_connection_page.dart';
import 'settings_page.dart';
import 'chat_screen.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ChatListScreen(),
    const AdminDashboardPage(),
    const ChannelManagementPage(),
    const UserManagementPage(),
    const ServiceConnectionPage(),
    const SettingsPage(),
  ];

  final List<String> _pageTitles = [
    'Chats',
    'Admin',
    'Channels',
    'Users',
    'Services',
    'Settings',
  ];

  final List<IconData> _pageIcons = [
    Icons.chat_bubble_outline,
    Icons.admin_panel_settings,
    Icons.chat_bubble_outline,
    Icons.people_outline,
    Icons.link,
    Icons.settings,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.9),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.pinkAccent,
                  unselectedItemColor: Colors.white.withValues(alpha: 0.6),
        selectedLabelStyle: const TextStyle(
          color: Colors.pinkAccent,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.6),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
          items: List.generate(
            _pages.length,
            (index) => BottomNavigationBarItem(
              icon: Icon(_pageIcons[index]),
              label: _pageTitles[index],
            ),
          ),
        ),
      ),
    );
  }
}

// Enhanced Chat List Screen with navigation
class EnhancedChatListScreen extends StatelessWidget {
  const EnhancedChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'MusicBud Chat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/pixiled_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Quick Actions Row
            _buildQuickActionsRow(context),
            const SizedBox(height: 24),

            // Chats List
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: _buildChatsList(),
              ),
            ),

            // Music Genres Row
            SizedBox(
              height: 120,
              child: _buildMusicGenresRow(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickActionButton(
              'Create Channel',
              Icons.add_circle_outline,
              Colors.pinkAccent,
              () => _navigateToPage(context, 2), // Channel Management
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildQuickActionButton(
              'Invite Friends',
              Icons.person_add,
              Colors.blue,
              () => _navigateToPage(context, 3), // User Management
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildQuickActionButton(
              'Connect Services',
              Icons.link,
              Colors.green,
              () => _navigateToPage(context, 4), // Service Connection
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatsList() {
    // Mock data for now - replace with actual data from bloc
    final users = [
      User("Liam Carter", "See what they're listening to", true, 'assets/profile.jpg'),
      User("Ava Sinclair", "You: Alright!", false, 'assets/profile2.jpg'),
      User("Noah Bennett", "You: what you doing lately", false, 'assets/profile6.jpg'),
      User("Ethan Reed", "😂😂😂😂", false, 'assets/white_card.jpg'),
      User("Mia Thompson", "See what they're listening to", false, 'assets/music_cover2.jpg'),
      User("Zoe Patel", "Hope we meet again 💙💙", false, 'assets/cover.jpg'),
      User("Sia Patel", "Hope we meet again 💙💙", true, 'assets/cover2.jpg'),
      User("Patel jack", "Hope we meet again", false, 'assets/cover4.jpg'),
    ];

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return ChatTile(user: users[index]);
      },
    );
  }

  Widget _buildMusicGenresRow() {
    final genres = [
      MusicGenre("Melodic Fusion", 'assets/cover.jpg'),
      MusicGenre("Bassline Society", 'assets/cover2.jpg'),
      MusicGenre("Echo Chamber", 'assets/cover3.jpg'),
      MusicGenre("Sound Collective", 'assets/cover4.jpg'),
      MusicGenre("Melodic Fusion", 'assets/cover.jpg'),
      MusicGenre("Bassline Society", 'assets/cover6.jpg'),
      MusicGenre("Echo Chamber", 'assets/music_cover4.jpg'),
      MusicGenre("Sound Collective", 'assets/profile2.jpg'),
      MusicGenre("Melodic Fusion", 'assets/profile4.jpg'),
      MusicGenre("Bassline Society", 'assets/cover2.jpg'),
      MusicGenre("Echo Chamber", 'assets/music_cover6.jpg'),
      MusicGenre("Sound Collective", 'assets/music_cover7.jpg'),
    ];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: genres.length,
      itemBuilder: (context, index) {
        return GenreCard(genre: genres[index]);
      },
    );
  }

  void _navigateToPage(BuildContext context, int pageIndex) {
    // This would typically navigate to the specific page
    // For now, we'll just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigating to ${_getPageTitle(pageIndex)}'),
        backgroundColor: Colors.pinkAccent,
      ),
    );
  }

  String _getPageTitle(int index) {
    final titles = ['Chats', 'Admin', 'Channels', 'Users', 'Services', 'Settings'];
    return titles[index];
  }
}

// Reuse existing classes from chat_screen.dart
class User {
  final String name;
  final String status;
  final bool isSpecial;
  final String imageUrl;

  User(this.name, this.status, this.isSpecial, this.imageUrl);
}

class MusicGenre {
  final String name;
  final String imageUrl;

  MusicGenre(this.name, this.imageUrl);
}

class ChatTile extends StatelessWidget {
  final User user;
  const ChatTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.pinkAccent,
            radius: 24,
            child: ClipOval(
              child: Image.asset(
                user.imageUrl,
                fit: BoxFit.cover,
                width: 48,
                height: 48,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user.status,
                  style: TextStyle(
                    color: user.isSpecial ? Colors.pinkAccent : Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          MatchNowButton(isHighlighted: user.isSpecial),
        ],
      ),
    );
  }
}

class MatchNowButton extends StatelessWidget {
  final bool isHighlighted;
  const MatchNowButton({super.key, required this.isHighlighted});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isHighlighted) ...[
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 13,
                      backgroundColor: Colors.pinkAccent,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/profile.jpg',
                          fit: BoxFit.cover,
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 15,
                      child: CircleAvatar(
                        radius: 13,
                        backgroundColor: Colors.pinkAccent,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/profile4.jpg',
                            fit: BoxFit.cover,
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
              ],
              const Text(
                "Match now",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GenreCard extends StatelessWidget {
  final MusicGenre genre;
  const GenreCard({super.key, required this.genre});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(genre.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            genre.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}