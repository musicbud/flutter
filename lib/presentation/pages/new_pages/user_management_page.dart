import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/chat/chat_bloc.dart';
import '../../../blocs/chat/chat_state.dart';

class UserManagementPage extends StatelessWidget {
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'User Management',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: Colors.white),
            onPressed: () => _showInviteUserDialog(context),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Search and Filter Bar
              _buildSearchAndFilterBar(),
              const SizedBox(height: 24),

              // User Stats
              _buildUserStats(),
              const SizedBox(height: 24),

              // User List
              Expanded(
                child: _buildUserList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.white70, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Search users...',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: const Icon(Icons.filter_list, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildUserStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Users',
            '1,234',
            Icons.people_outline,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Online',
            '89',
            Icons.circle,
            Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Banned',
            '12',
            Icons.block,
            Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.pinkAccent),
          );
        }

        if (state is ChatError) {
          return Center(
            child: Text(
              'Error: ${state.message}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        // Mock data for now - replace with actual data from bloc
        final users = [
          UserData('Liam Carter', 'Online', 'Admin', true, 'assets/profile.jpg'),
          UserData('Ava Sinclair', 'Online', 'Moderator', false, 'assets/profile2.jpg'),
          UserData('Noah Bennett', 'Offline', 'Member', false, 'assets/profile6.jpg'),
          UserData('Ethan Reed', 'Online', 'Member', false, 'assets/white_card.jpg'),
          UserData('Mia Thompson', 'Away', 'Member', false, 'assets/music_cover2.jpg'),
          UserData('Zoe Patel', 'Online', 'Member', false, 'assets/cover.jpg'),
          UserData('Sia Patel', 'Banned', 'Banned', false, 'assets/cover2.jpg'),
        ];

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            return _buildUserItem(context, users[index]);
          },
        );
      },
    );
  }

  Widget _buildUserItem(BuildContext context, UserData user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getStatusColor(user.status).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          // User Avatar
          Stack(
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
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _getStatusColor(user.status),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getRoleColor(user.role).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _getRoleColor(user.role)),
                      ),
                      child: Text(
                        user.role,
                        style: TextStyle(
                          color: _getRoleColor(user.role),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  user.status,
                  style: TextStyle(
                    color: _getStatusColor(user.status),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons
          Column(
            children: [
              if (user.isAdmin)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.pinkAccent),
                  ),
                  child: const Text(
                    'Admin',
                    style: TextStyle(
                      color: Colors.pinkAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.message, color: Colors.white70, size: 20),
                    onPressed: () => _showMessageDialog(user),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white70, size: 20),
                    onPressed: () => _showUserOptionsDialog(context, user),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'online':
        return Colors.green;
      case 'offline':
        return Colors.grey;
      case 'away':
        return Colors.orange;
      case 'banned':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.pinkAccent;
      case 'moderator':
        return Colors.blue;
      case 'member':
        return Colors.green;
      case 'banned':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showInviteUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Invite User',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Username or Email',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white30),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.pinkAccent),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                    ),
                    child: const Text('Invite'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showMessageDialog(UserData user) {
    // Implement message dialog
  }

  void _showUserOptionsDialog(BuildContext context, UserData user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: const Text('View Profile', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.message, color: Colors.white),
              title: const Text('Send Message', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            if (user.role != 'Admin')
              ListTile(
                leading: const Icon(Icons.admin_panel_settings, color: Colors.white),
                title: const Text('Make Admin', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
            if (user.status != 'Banned')
              ListTile(
                leading: const Icon(Icons.block, color: Colors.red),
                title: const Text('Ban User', style: TextStyle(color: Colors.red)),
                onTap: () => Navigator.pop(context),
              ),
            if (user.status == 'Banned')
              ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: const Text('Unban User', style: TextStyle(color: Colors.green)),
                onTap: () => Navigator.pop(context),
              ),
          ],
        ),
      ),
    );
  }
}

class UserData {
  final String name;
  final String status;
  final String role;
  final bool isAdmin;
  final String imageUrl;

  UserData(this.name, this.status, this.role, this.isAdmin, this.imageUrl);
}