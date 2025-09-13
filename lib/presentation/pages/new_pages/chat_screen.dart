import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/chat/chat_bloc.dart';
import '../../../blocs/chat/chat_event.dart';
import '../../../blocs/chat/chat_state.dart';
import '../../../blocs/chat_room/chat_room_bloc.dart';
import '../../../blocs/chat_room/chat_room_state.dart';
import '../../../blocs/profile/profile_bloc.dart';
import '../../../blocs/profile/profile_state.dart';
import '../../widgets/common/unified_navigation_scaffold.dart';
import '../../constants/app_constants.dart';
import '../../mixins/page_mixin.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> with PageMixin, TickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  final List<String> _tabs = ['Chats', 'Channels', 'Invitations'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_onTabChanged);

    // Load initial data
    context.read<ChatBloc>().add(ChatUserListRequested());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
      _loadTabData(_currentTabIndex);
    }
  }

  void _loadTabData(int index) {
    switch (index) {
      case 0: // Chats
        context.read<ChatBloc>().add(ChatUserListRequested());
        break;
      case 1: // Channels
        context.read<ChatBloc>().add(ChatChannelListRequested());
        break;
      case 2: // Invitations
        context.read<ChatBloc>().add(ChatUserInvitationsRequested('current_user'));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ContentPageScaffold(
      title: 'Messages',
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: _showSearchDialog,
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: _handleMenuAction,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'create_channel',
              child: Row(
                children: [
                  Icon(Icons.add_circle_outline),
                  SizedBox(width: 8),
                  Text('Create Channel'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'join_channel',
              child: Row(
                children: [
                  Icon(Icons.group_add),
                  SizedBox(width: 8),
                  Text('Join Channel'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.settings),
                  SizedBox(width: 8),
                  Text('Chat Settings'),
                ],
              ),
            ),
          ],
        ),
      ],
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateOptions,
        backgroundColor: AppConstants.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppConstants.primaryColor,
          borderRadius: BorderRadius.circular(25),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppConstants.textSecondaryColor,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
      ),
    );
  }

  Widget _buildContent() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildChatsTab(),
        _buildChannelsTab(),
        _buildInvitationsTab(),
      ],
    );
  }

  Widget _buildChatsTab() {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ChatUserListLoaded) {
          final users = state.users;

          if (users.isEmpty) {
            return _buildEmptyState(
              'No conversations yet',
              'Start a conversation with your music buds!',
              Icons.chat_bubble_outline,
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final user = users[index];
              return _buildChatItem(
                user.displayName ?? user.username,
                'No messages yet',
                '',
                user.avatarUrl,
                0,
                () => _openChat(user),
              );
            },
          );
        }

        if (state is ChatError) {
          return _buildErrorState(state.error);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildChannelsTab() {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ChatChannelListLoaded) {
          final channels = state.channels;

          if (channels.isEmpty) {
            return _buildEmptyState(
              'No channels joined',
              'Join or create channels to discuss music topics!',
              Icons.group_outlined,
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: channels.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final channel = channels[index];
              return _buildChannelItem(
                channel.name,
                channel.description ?? 'No description',
                channel.memberCount,
                '',
                () => _openChannel(channel),
              );
            },
          );
        }

        if (state is ChatError) {
          return _buildErrorState(state.error);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildInvitationsTab() {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ChatUserInvitationsLoaded) {
          final invitations = state.invitations;

          if (invitations.isEmpty) {
            return _buildEmptyState(
              'No pending invitations',
              'Channel invitations will appear here',
              Icons.person_add_outlined,
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: invitations.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final invitation = invitations[index];
              return _buildInvitationItem(
                invitation.channel.name,
                'Invitation to join channel',
                '',
                null,
                () => _acceptInvitation(invitation.id),
                () => _declineInvitation(invitation.id),
              );
            },
          );
        }

        if (state is ChatError) {
          return _buildErrorState(state.error);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildChatItem(
    String username,
    String lastMessage,
    String timestamp,
    String? profileImage,
    int unreadCount,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppConstants.borderColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Profile Image
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppConstants.primaryColor.withValues(alpha: 0.2),
                  image: profileImage != null
                      ? DecorationImage(
                          image: NetworkImage(profileImage),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: profileImage == null
                    ? Icon(
                        Icons.person,
                        color: AppConstants.primaryColor,
                        size: 24,
                      )
                    : null,
              ),

              const SizedBox(width: 16),

              // Chat Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          username,
                          style: AppConstants.subheadingStyle.copyWith(fontSize: 16),
                        ),
                        if (timestamp.isNotEmpty)
                          Text(
                            timestamp,
                            style: AppConstants.captionStyle.copyWith(fontSize: 12),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            lastMessage,
                            style: AppConstants.captionStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (unreadCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppConstants.primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChannelItem(
    String name,
    String description,
    int memberCount,
    String lastActivity,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppConstants.borderColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Channel Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppConstants.primaryColor.withValues(alpha: 0.2),
                ),
                child: Icon(
                  Icons.group,
                  color: AppConstants.primaryColor,
                  size: 24,
                ),
              ),

              const SizedBox(width: 16),

              // Channel Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: AppConstants.subheadingStyle.copyWith(fontSize: 16),
                        ),
                        Text(
                          '$memberCount members',
                          style: AppConstants.captionStyle.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: AppConstants.captionStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (lastActivity.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Last activity: $lastActivity',
                        style: AppConstants.captionStyle.copyWith(
                          fontSize: 12,
                          color: AppConstants.textSecondaryColor.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInvitationItem(
    String channelName,
    String message,
    String timestamp,
    String? profileImage,
    VoidCallback onAccept,
    VoidCallback onDecline,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppConstants.borderColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Channel Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppConstants.primaryColor.withValues(alpha: 0.2),
              ),
              child: Icon(
                Icons.group_add,
                color: AppConstants.primaryColor,
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            // Invitation Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        channelName,
                        style: AppConstants.subheadingStyle.copyWith(fontSize: 16),
                      ),
                      if (timestamp.isNotEmpty)
                        Text(
                          timestamp,
                          style: AppConstants.captionStyle.copyWith(fontSize: 12),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: AppConstants.captionStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onAccept,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: const Text(
                            'Accept',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onDecline,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppConstants.textSecondaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: Text(
                            'Decline',
                            style: TextStyle(
                              color: AppConstants.textSecondaryColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppConstants.textSecondaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppConstants.headingStyle.copyWith(
                color: AppConstants.textSecondaryColor,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppConstants.captionStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppConstants.errorColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: AppConstants.headingStyle.copyWith(
                color: AppConstants.errorColor,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppConstants.captionStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _loadTabData(_currentTabIndex),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppConstants.surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Search Conversations',
                style: AppConstants.headingStyle.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 16),
              TextField(
                autofocus: true,
                style: AppConstants.bodyStyle,
                decoration: InputDecoration(
                  hintText: 'Search users, channels, or messages',
                  hintStyle: AppConstants.captionStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppConstants.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppConstants.primaryColor),
                  ),
                ),
                onSubmitted: (query) {
                  Navigator.of(context).pop();
                  _performSearch(query);
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'create_channel':
        _showCreateChannelDialog();
        break;
      case 'join_channel':
        _showJoinChannelDialog();
        break;
      case 'settings':
        navigateTo('/chat/settings');
        break;
    }
  }

  void _showCreateOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Start New Conversation',
              style: AppConstants.headingStyle.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.person_add, color: AppConstants.primaryColor),
              title: const Text('New Chat', style: AppConstants.bodyStyle),
              subtitle: const Text('Start a private conversation', style: AppConstants.captionStyle),
              onTap: () {
                Navigator.pop(context);
                _showNewChatDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.group_add, color: AppConstants.primaryColor),
              title: const Text('Create Channel', style: AppConstants.bodyStyle),
              subtitle: const Text('Create a public discussion channel', style: AppConstants.captionStyle),
              onTap: () {
                Navigator.pop(context);
                _showCreateChannelDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.search, color: AppConstants.primaryColor),
              title: const Text('Join Channel', style: AppConstants.bodyStyle),
              subtitle: const Text('Find and join existing channels', style: AppConstants.captionStyle),
              onTap: () {
                Navigator.pop(context);
                _showJoinChannelDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showNewChatDialog() {
    showInfoSnackBar('New chat dialog coming soon!');
  }

  void _showCreateChannelDialog() {
    showInfoSnackBar('Create channel dialog coming soon!');
  }

  void _showJoinChannelDialog() {
    showInfoSnackBar('Join channel dialog coming soon!');
  }

  void _performSearch(String query) {
    showInfoSnackBar('Searching for "$query"...');
  }

  void _openChat(dynamic user) {
    navigateTo('/chat/${user.id}');
  }

  void _openChannel(dynamic channel) {
    navigateTo('/channel/${channel.id}');
  }

  void _acceptInvitation(String invitationId) {
    showSuccessSnackBar('Invitation accepted!');
  }

  void _declineInvitation(String invitationId) {
    showInfoSnackBar('Invitation declined');
  }
}

