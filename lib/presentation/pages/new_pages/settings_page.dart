import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/pixiled_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Profile Section
              _buildProfileSection(),
              const SizedBox(height: 24),

              // Settings Categories
              Expanded(
                child: _buildSettingsCategories(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:  0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha:  0.2)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.pinkAccent,
            radius: 30,
            child: ClipOval(
              child: Image.asset(
                'assets/profile.jpg',
                fit: BoxFit.cover,
                width: 60,
                height: 60,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Liam Carter',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Premium Member',
                  style: TextStyle(
                    color: Colors.pinkAccent,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'liam.carter@email.com',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha:  0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCategories() {
    return ListView(
      children: [
        _buildSettingsSection(
          'Account',
          [
            SettingsItem(
              'Profile Settings',
              'Manage your profile information',
              Icons.person_outline,
              Colors.blue,
              () {},
            ),
            SettingsItem(
              'Privacy & Security',
              'Control your privacy settings',
              Icons.security_outlined,
              Colors.green,
              () {},
            ),
            SettingsItem(
              'Notifications',
              'Customize notification preferences',
              Icons.notifications_outlined,
              Colors.orange,
              () {},
            ),
            SettingsItem(
              'Language & Region',
              'Set your language and location',
              Icons.language_outlined,
              Colors.purple,
              () {},
            ),
          ],
        ),

        const SizedBox(height: 24),

        _buildSettingsSection(
          'Music & Services',
          [
            SettingsItem(
              'Service Connections',
              'Manage your music service accounts',
              Icons.link_outlined,
              Colors.pinkAccent,
              () {},
            ),
            SettingsItem(
              'Music Preferences',
              'Set your music taste and genres',
              Icons.music_note_outlined,
              Colors.indigo,
              () {},
            ),
            SettingsItem(
              'Playlist Sync',
              'Sync playlists across services',
              Icons.sync_outlined,
              Colors.teal,
              () {},
            ),
          ],
        ),

        const SizedBox(height: 24),

        _buildSettingsSection(
          'Chat & Social',
          [
            SettingsItem(
              'Chat Preferences',
              'Customize chat settings',
              Icons.chat_bubble_outline,
              Colors.cyan,
              () {},
            ),
            SettingsItem(
              'Friend Requests',
              'Manage friend requests and privacy',
              Icons.people_outline,
              Colors.lime,
              () {},
            ),
            SettingsItem(
              'Blocked Users',
              'View and manage blocked users',
              Icons.block_outlined,
              Colors.red,
              () {},
            ),
          ],
        ),

        const SizedBox(height: 24),

        _buildSettingsSection(
          'App & System',
          [
            SettingsItem(
              'Appearance',
              'Customize app theme and colors',
              Icons.palette_outlined,
              Colors.amber,
              () {},
            ),
            SettingsItem(
              'Storage & Cache',
              'Manage app storage and cache',
              Icons.storage_outlined,
              Colors.grey,
              () {},
            ),
            SettingsItem(
              'Data Usage',
              'Control data usage and sync',
              Icons.data_usage_outlined,
              Colors.brown,
              () {},
            ),
            SettingsItem(
              'About',
              'App version and information',
              Icons.info_outline,
              Colors.blueGrey,
              () {},
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Danger Zone
        _buildDangerZone(),

        const SizedBox(height: 24),

        // Logout Button
        _buildLogoutButton(),
      ],
    );
  }

  Widget _buildSettingsSection(String title, List<SettingsItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha:  0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha:  0.1)),
          ),
          child: Column(
            children: items.map((item) => _buildSettingsItem(item)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(SettingsItem item) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha:  0.1),
            width: 0.5,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: item.color.withValues(alpha:  0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(item.icon, color: item.color, size: 20),
        ),
        title: Text(
          item.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          item.description,
          style: TextStyle(
            color: Colors.white.withValues(alpha:  0.6),
            fontSize: 14,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white30,
          size: 16,
        ),
        onTap: item.onTap,
      ),
    );
  }

  Widget _buildDangerZone() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Danger Zone',
          style: TextStyle(
            color: Colors.red[400],
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha:  0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withValues(alpha:  0.3)),
          ),
          child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha:  0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.delete_forever, color: Colors.red, size: 20),
                ),
                title: const Text(
                  'Delete Account',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: const Text(
                  'Permanently delete your account and all data',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.red,
                  size: 16,
                ),
                onTap: () => _showDeleteAccountDialog(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _showLogoutDialog(),
        style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha:  0.1),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        side: BorderSide(color: Colors.white.withValues(alpha:  0.3)),
        ),
        child: const Text(
          'Logout',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    // Implement delete account dialog
  }

  void _showLogoutDialog() {
    // Implement logout dialog
  }
}

class SettingsItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  SettingsItem(this.title, this.description, this.icon, this.color, this.onTap);
}