import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/chat/chat_bloc.dart';
import '../../../blocs/chat/chat_event.dart';
import '../../../blocs/chat/chat_state.dart';
import '../../../domain/models/user_profile.dart';
import '../../constants/app_constants.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../widgets/common/app_app_bar.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _inviteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load users when page initializes
    context.read<ChatBloc>().add(ChatUsersRequested());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _inviteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppAppBar(
        title: 'User Management',
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => _showInviteUserDialog(context),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLimitationsNotice(),
          const SizedBox(height: 16),
          _buildSearchAndFilterBar(),
          const SizedBox(height: 16),
          _buildUserStats(),
          const SizedBox(height: 16),
          Expanded(
            child: _buildUserList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLimitationsNotice() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info, color: Colors.orange, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'User management is limited. You can only view users and send basic messages. Advanced features like role management, banning, and user invitations are not supported by the API.',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: AppTextField(
              controller: _searchController,
              labelText: 'Search users',
              hintText: 'Enter username or name...',
              prefixIcon: const Icon(Icons.search),
              onChanged: (value) {
                // Search functionality is not implemented due to API limitations
                if (value.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('User search is not supported by the API'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppConstants.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppConstants.borderColor.withValues(alpha: 0.3)),
            ),
            child: const Icon(
              Icons.filter_list,
              color: AppConstants.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Users',
              'Loading...',
              Icons.people_outline,
              Colors.blue,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Online',
              'N/A',
              Icons.circle,
              Colors.green,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Active',
              'N/A',
              Icons.person,
              Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
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
              color: AppConstants.textSecondaryColor,
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
            child: CircularProgressIndicator(),
          );
        }

        if (state is ChatError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  _getUserFriendlyErrorMessage(state.error),
                  style: const TextStyle(color: AppConstants.textColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                if (_isServerError(state.error))
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                    ),
                    child: const Text(
                      'The server is experiencing issues. This is not a problem with your app.',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 16),
                AppButton(
                  text: 'Retry',
                  onPressed: () {
                    context.read<ChatBloc>().add(ChatUsersRequested());
                  },
                ),
              ],
            ),
          );
        }

        if (state is ChatUsersLoaded) {
          if (state.users.isEmpty) {
            return _buildEmptyState();
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              return _buildUserItem(context, state.users[index]);
            },
          );
        }

        // Default state - show empty state
        return _buildEmptyState();
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: AppConstants.textSecondaryColor,
          ),
          SizedBox(height: 16),
          Text(
            'No users found',
            style: TextStyle(
              color: AppConstants.textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Users will appear here once they join the platform',
            style: TextStyle(
              color: AppConstants.textSecondaryColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserItem(BuildContext context, UserProfile user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppConstants.borderColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          // User Avatar
          CircleAvatar(
            backgroundColor: AppConstants.primaryColor,
            radius: 24,
            backgroundImage: user.avatarUrl != null
                ? NetworkImage(user.avatarUrl!)
                : null,
            child: user.avatarUrl == null
                ? Text(
                    user.username.isNotEmpty ? user.username[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
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
                      user.displayName ?? user.username,
                      style: const TextStyle(
                        color: AppConstants.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppConstants.primaryColor),
                      ),
                      child: const Text(
                        'Member',
                        style: TextStyle(
                          color: AppConstants.primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  user.bio ?? 'No bio available',
                  style: const TextStyle(
                    color: AppConstants.textSecondaryColor,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Action Buttons
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppConstants.primaryColor),
                ),
                child: const Text(
                  'View',
                  style: TextStyle(
                    color: AppConstants.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.message, color: AppConstants.textSecondaryColor, size: 20),
                    onPressed: () => _showMessageDialog(user),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: AppConstants.textSecondaryColor, size: 20),
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

  void _showInviteUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.surfaceColor,
        title: const Text(
          'Invite User',
          style: TextStyle(color: AppConstants.textColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              controller: _inviteController,
              labelText: 'Username or Email',
              hintText: 'Enter username or email',
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info, color: Colors.orange, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'User invitations are not supported by the API',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppConstants.textSecondaryColor),
            ),
          ),
          AppButton(
            text: 'Invite',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User invitations are not supported by the API'),
                  backgroundColor: Colors.orange,
                ),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showMessageDialog(UserProfile user) {
    // Basic message functionality - can be implemented
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Messaging ${user.username} is not yet implemented'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showUserOptionsDialog(BuildContext context, UserProfile user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.surfaceColor,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person, color: AppConstants.textColor),
              title: const Text('View Profile', style: TextStyle(color: AppConstants.textColor)),
              onTap: () {
                Navigator.pop(context);
                _showProfileNotImplemented();
              },
            ),
            ListTile(
              leading: const Icon(Icons.message, color: AppConstants.textColor),
              title: const Text('Send Message', style: TextStyle(color: AppConstants.textColor)),
              onTap: () {
                Navigator.pop(context);
                _showMessageDialog(user);
              },
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings, color: AppConstants.textSecondaryColor),
              title: const Text('Make Admin', style: TextStyle(color: AppConstants.textSecondaryColor)),
              onTap: () {
                Navigator.pop(context);
                _showAdminNotSupported();
              },
            ),
            ListTile(
              leading: const Icon(Icons.block, color: AppConstants.textSecondaryColor),
              title: const Text('Ban User', style: TextStyle(color: AppConstants.textSecondaryColor)),
              onTap: () {
                Navigator.pop(context);
                _showBanNotSupported();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileNotImplemented() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User profile viewing is not yet implemented'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showAdminNotSupported() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Role management is not supported by the API'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showBanNotSupported() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User banning is not supported by the API'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  String _getUserFriendlyErrorMessage(String error) {
    if (_isServerError(error)) {
      return 'Server Error: The user service is temporarily unavailable';
    }
    if (error.contains('Failed to get users')) {
      return 'Unable to load users at this time';
    }
    return 'Error: $error';
  }

  bool _isServerError(String error) {
    return error.contains('Server error') ||
           error.contains('500') ||
           error.contains('temporarily unavailable');
  }
}