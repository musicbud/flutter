import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/dynamic_config_service.dart';
import '../../../services/dynamic_theme_service.dart';
import '../../../services/dynamic_navigation_service.dart';
import '../../../services/mock_data_service.dart';
import '../../../blocs/chat/chat_bloc.dart';
import '../../../blocs/chat/chat_event.dart';
import '../../../blocs/chat/chat_state.dart';
import '../../../models/channel.dart';
import '../../../models/user_profile.dart';

/// Dynamic chat screen with adaptive features
class DynamicChatScreen extends StatefulWidget {
  const DynamicChatScreen({super.key});

  @override
  State<DynamicChatScreen> createState() => _DynamicChatScreenState();
}

class _DynamicChatScreenState extends State<DynamicChatScreen>
    with TickerProviderStateMixin {
  final DynamicConfigService _config = DynamicConfigService.instance;
  final DynamicThemeService _theme = DynamicThemeService.instance;
  final DynamicNavigationService _navigation = DynamicNavigationService.instance;

  late TabController _tabController;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<UserProfile> _users = [];
  List<Channel> _channels = [];
  String _selectedChatId = '';
  bool _isLoading = false;
  bool _isOffline = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final tabs = _getAvailableTabs();
    _tabController = TabController(
      length: tabs.length,
      vsync: this,
    );
    _loadChats();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = _getAvailableTabs();

    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        setState(() {
          _isLoading = state is ChatLoading;
        });

        if (state is ChatError) {
          setState(() {
            _errorMessage = state.error;
            _isOffline = state.error.contains('network') || state.error.contains('offline');
          });
          _showErrorDialog(state.error);
        } else if (state is ChatUserListLoaded) {
          setState(() {
            _users = state.users;
            _errorMessage = null;
            _isOffline = false;
          });
        } else if (state is ChatChannelListLoaded) {
          setState(() {
            _channels = state.channels;
            _errorMessage = null;
            _isOffline = false;
          });
        } else if (state is ChatChannelCreatedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Channel "${state.channel.name}" created successfully'),
              backgroundColor: Colors.green,
            ),
          );
          _loadChannels();
        } else if (state is ChatChannelJoinedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully joined channel'),
              backgroundColor: Colors.green,
            ),
          );
          _loadChannels();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text('Chat'),
              if (_isOffline) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.cloud_off,
                        size: 12,
                        color: Colors.orange.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Offline',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          bottom: tabs.length > 1 ? TabBar(
            controller: _tabController,
            tabs: tabs.map((tab) => Tab(text: tab['title'])).toList(),
          ) : null,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _showSearchDialog,
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _showNewChatOptions,
            ),
            if (_isOffline)
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _retryConnection,
                tooltip: 'Retry Connection',
              ),
          ],
        ),
        body: _buildBody(),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  Widget _buildBody() {
    if (!_config.isFeatureEnabled('chat_system')) {
      return _buildFeatureDisabledState();
    }

    final tabs = _getAvailableTabs();
    if (tabs.isEmpty) {
      return _buildEmptyState();
    }

    return TabBarView(
      controller: _tabController,
      children: tabs.map((tab) => _buildTabContent(tab)).toList(),
    );
  }

  Widget _buildFeatureDisabledState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: _theme.getDynamicFontSize(64),
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(height: _theme.getDynamicSpacing(16)),
          Text(
            'Chat System Disabled',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: _theme.getDynamicFontSize(20),
            ),
          ),
          SizedBox(height: _theme.getDynamicSpacing(8)),
          Text(
            'Enable chat system in settings to start conversations',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: _theme.getDynamicFontSize(14),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: _theme.getDynamicSpacing(24)),
          ElevatedButton(
            onPressed: () => _navigation.navigateTo('/settings'),
            child: const Text('Enable Feature'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: _theme.getDynamicFontSize(64),
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(height: _theme.getDynamicSpacing(16)),
          Text(
            'No Chats Available',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: _theme.getDynamicFontSize(20),
            ),
          ),
          SizedBox(height: _theme.getDynamicSpacing(8)),
          Text(
            'Start a conversation with your music buds',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: _theme.getDynamicFontSize(14),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: _theme.getDynamicSpacing(24)),
          ElevatedButton.icon(
            onPressed: _showNewChatOptions,
            icon: const Icon(Icons.add),
            label: const Text('Start Chat'),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(Map<String, dynamic> tab) {
    switch (tab['type']) {
      case 'direct':
        return _buildDirectChatsList();
      case 'channels':
        return _buildChannelsList();
      case 'groups':
        return _buildGroupsList();
      default:
        return _buildGenericChatList(tab);
    }
  }

  Widget _buildDirectChatsList() {
    if (_isLoading && _users.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_users.isEmpty && !_isLoading) {
      return _buildEmptyChatsState();
    }

    return RefreshIndicator(
      onRefresh: _loadChats,
      child: Stack(
        children: [
          ListView.builder(
            padding: EdgeInsets.all(_theme.getDynamicSpacing(8)),
            itemCount: _users.length,
            itemBuilder: (context, index) {
              return _buildUserChatItem(_users[index], index);
            },
          ),
          if (_isLoading && _users.isNotEmpty)
            Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Refreshing...'),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUserChatItem(UserProfile user, int index) {
    final isOnline = user.isActive; // Use isActive property for online status
    const unreadCount = 0; // TODO: Implement unread message count

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: _theme.getDynamicSpacing(8),
        vertical: _theme.getDynamicSpacing(4),
      ),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              radius: _theme.getDynamicFontSize(25),
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
              child: user.avatarUrl == null
                  ? Text(
                      user.displayName?.substring(0, 1).toUpperCase() ?? user.username.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        fontSize: _theme.getDynamicFontSize(20),
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : null,
            ),
            if (isOnline)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: _theme.getDynamicFontSize(16),
                  height: _theme.getDynamicFontSize(16),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          user.displayName ?? user.username,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: _theme.getDynamicFontSize(16),
            fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          user.bio ?? 'No recent messages',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: _theme.getDynamicFontSize(12),
            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Online',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: _theme.getDynamicFontSize(10),
                color: isOnline ? Colors.green : Theme.of(context).colorScheme.outline,
              ),
            ),
            if (unreadCount > 0) ...[
              SizedBox(height: _theme.getDynamicSpacing(4)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: _theme.getDynamicSpacing(6),
                  vertical: _theme.getDynamicSpacing(2),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  unreadCount > 99 ? '99+' : unreadCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _theme.getDynamicFontSize(10),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        onTap: () => _openUserChat(user, index),
      ),
    );
  }

  Widget _buildChannelsList() {
    if (_isLoading && _channels.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_channels.isEmpty && !_isLoading) {
      return _buildEmptyChannelsState();
    }

    return RefreshIndicator(
      onRefresh: _loadChannels,
      child: Stack(
        children: [
          ListView.builder(
            padding: EdgeInsets.all(_theme.getDynamicSpacing(8)),
            itemCount: _channels.length,
            itemBuilder: (context, index) {
              return _buildChannelItem(_channels[index], index);
            },
          ),
          if (_isLoading && _channels.isNotEmpty)
            Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Refreshing...'),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChannelItem(Channel channel, int index) {
    const memberCount = 0; // TODO: Get from channel model
    const isJoined = false; // TODO: Get from channel model

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: _theme.getDynamicSpacing(8),
        vertical: _theme.getDynamicSpacing(4),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: _theme.getDynamicFontSize(25),
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          child: Icon(
            Icons.group, // TODO: Use channel.isPrivate when available
            color: Theme.of(context).colorScheme.onSecondary,
            size: _theme.getDynamicFontSize(20),
          ),
        ),
          title: Text(
            channel.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: _theme.getDynamicFontSize(16),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              channel.description ?? 'No description',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: _theme.getDynamicFontSize(12),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              children: [
                Text(
                  '$memberCount members',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: _theme.getDynamicFontSize(10),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                // TODO: Add private channel indicator when available
                // if (channel.isPrivate == true) ...[private indicator widgets],
              ],
            ),
          ],
        ),
        trailing: _isLoading
            ? SizedBox(
                width: _theme.getDynamicFontSize(20),
                height: _theme.getDynamicFontSize(20),
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
            : isJoined
                ? IconButton(
                    icon: const Icon(Icons.exit_to_app),
                    onPressed: () => _leaveChannel(channel, index),
                    tooltip: 'Leave Channel',
                  )
                : ElevatedButton(
                    onPressed: () => _joinChannel(channel, index),
                    child: const Text('Join'),
                  ),
        onTap: () => _openChannel(channel, index),
      ),
    );
  }

  Widget _buildGroupsList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.group_outlined,
            size: _theme.getDynamicFontSize(64),
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(height: _theme.getDynamicSpacing(16)),
          Text(
            'Groups Coming Soon',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: _theme.getDynamicFontSize(20),
            ),
          ),
          SizedBox(height: _theme.getDynamicSpacing(8)),
          Text(
            'Group chat functionality will be available soon',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: _theme.getDynamicFontSize(14),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGenericChatList(Map<String, dynamic> tab) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: _theme.getDynamicFontSize(64),
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(height: _theme.getDynamicSpacing(16)),
          Text(
            '${tab['title']} Chat',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: _theme.getDynamicFontSize(20),
            ),
          ),
          SizedBox(height: _theme.getDynamicSpacing(8)),
          Text(
            'This chat type is not yet implemented',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: _theme.getDynamicFontSize(14),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    if (!_config.isFeatureEnabled('chat_system')) {
      return null;
    }

    return FloatingActionButton(
      heroTag: "chat_new_comment_fab",
      onPressed: _showNewChatOptions,
      child: const Icon(Icons.add_comment),
    );
  }

  List<Map<String, dynamic>> _getAvailableTabs() {
    if (!_config.isFeatureEnabled('chat_system')) {
      return [];
    }

    final tabs = <Map<String, dynamic>>[
      {'title': 'Direct', 'type': 'direct'},
    ];

    if (_config.isFeatureEnabled('group_chat')) {
      tabs.addAll([
        {'title': 'Channels', 'type': 'channels'},
        {'title': 'Groups', 'type': 'groups'},
      ]);
    }

    return tabs;
  }

  Future<void> _loadChats() async {
    try {
      context.read<ChatBloc>().add(ChatUserListRequested());
    } catch (e) {
      // Fallback to mock data if BLoC call fails
      _loadMockChats();
    }
  }

  Future<void> _loadChannels() async {
    try {
      context.read<ChatBloc>().add(ChatChannelListRequested());
    } catch (e) {
      // Fallback to mock data if BLoC call fails
      _loadMockChannels();
    }
  }

  void _loadMockChats() {
    setState(() {
      // Generate mock users using the static methods
      final mockUsers = <UserProfile>[];
      for (int i = 0; i < 8; i++) {
        final userData = MockDataService.generateUserProfile();
        mockUsers.add(UserProfile(
          id: userData['id'],
          username: userData['username'],
          displayName: userData['displayName'],
          email: userData['email'],
          avatarUrl: userData['profileImageUrl'],
          bio: userData['bio'],
          isActive: DateTime.now().difference(DateTime.parse(userData['lastActiveAt'])).inMinutes < 30,
        ));
      }
      _users = mockUsers;
      _isOffline = true;
    });
  }

  void _loadMockChannels() {
    setState(() {
      // For now, use empty list as Channel model structure is not clear
      _channels = [];
      _isOffline = true;
    });
  }

  void _openUserChat(UserProfile user, int index) {
    _selectedChatId = user.id;
    _navigation.navigateTo('/chat-conversation', arguments: {
      'userId': user.id,
      'userName': user.displayName ?? user.username,
      'userProfile': user,
    });
  }

  void _openChannel(Channel channel, int index) {
    _navigation.navigateTo('/channel-chat', arguments: {
      'channelId': channel.id,
      'channelName': channel.name,
      'channel': channel,
    });
  }

  void _joinChannel(Channel channel, int index) {
    if (_isOffline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot join channel while offline'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (channel.id.isNotEmpty) {
      context.read<ChatBloc>().add(ChatChannelJoinRequested(channelId: channel.id));
    }
  }

  void _leaveChannel(Channel channel, int index) {
    if (_isOffline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot leave channel while offline'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Channel'),
        content: Text('Are you sure you want to leave ${channel.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement leave channel API call
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Left ${channel.name}')),
              );
            },
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Chats'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Search by name or message...',
            prefixIcon: Icon(Icons.search),
          ),
          onSubmitted: (value) {
            Navigator.pop(context);
            _searchChats(value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement search
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _searchChats(String query) {
    // TODO: Implement chat search
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Searching for: $query')),
    );
  }

  void _showNewChatOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Start New Chat',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: _theme.getDynamicFontSize(20),
              ),
            ),
            SizedBox(height: _theme.getDynamicSpacing(16)),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('New Direct Chat'),
              subtitle: const Text('Start a conversation with a user'),
              onTap: () {
                Navigator.pop(context);
                _startDirectChat();
              },
            ),
            if (_config.isFeatureEnabled('group_chat')) ...[
              ListTile(
                leading: const Icon(Icons.group_add),
                title: const Text('Create Channel'),
                subtitle: const Text('Create a new public channel'),
                onTap: () {
                  Navigator.pop(context);
                  _createChannel();
                },
              ),
              ListTile(
                leading: const Icon(Icons.group),
                title: const Text('Create Group'),
                subtitle: const Text('Create a private group chat'),
                onTap: () {
                  Navigator.pop(context);
                  _createGroup();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _startDirectChat() {
    if (_isOffline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot start new chat while offline'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    _showUserSelectionDialog();
  }

  void _createChannel() {
    if (_isOffline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot create channel while offline'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    _showChannelCreationDialog();
  }

  void _createGroup() {
    if (_isOffline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot create group while offline'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Group creation coming soon')),
    );
  }

  Widget _buildEmptyChatsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: _theme.getDynamicFontSize(64),
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(height: _theme.getDynamicSpacing(16)),
          Text(
            _isOffline ? 'No Cached Chats' : 'No Direct Chats',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: _theme.getDynamicFontSize(20),
            ),
          ),
          SizedBox(height: _theme.getDynamicSpacing(8)),
          Text(
            _isOffline 
                ? 'Connect to internet to load your conversations'
                : 'Start a conversation with your music buds',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: _theme.getDynamicFontSize(14),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: _theme.getDynamicSpacing(24)),
          if (_isOffline)
            ElevatedButton.icon(
              onPressed: _retryConnection,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry Connection'),
            )
          else
            ElevatedButton.icon(
              onPressed: _showNewChatOptions,
              icon: const Icon(Icons.add),
              label: const Text('Start Chat'),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyChannelsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.group_outlined,
            size: _theme.getDynamicFontSize(64),
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(height: _theme.getDynamicSpacing(16)),
          Text(
            _isOffline ? 'No Cached Channels' : 'No Channels Available',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: _theme.getDynamicFontSize(20),
            ),
          ),
          SizedBox(height: _theme.getDynamicSpacing(8)),
          Text(
            _isOffline
                ? 'Connect to internet to load available channels'
                : 'Join or create channels to discuss music with communities',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: _theme.getDynamicFontSize(14),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: _theme.getDynamicSpacing(24)),
          if (_isOffline)
            ElevatedButton.icon(
              onPressed: _retryConnection,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry Connection'),
            )
          else
            ElevatedButton.icon(
              onPressed: _createChannel,
              icon: const Icon(Icons.add),
              label: const Text('Create Channel'),
            ),
        ],
      ),
    );
  }

  void _retryConnection() {
    setState(() {
      _isOffline = false;
      _errorMessage = null;
    });
    _loadChats();
    _loadChannels();
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 8),
            const Text('Connection Error'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Failed to load chat data:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.orange.shade700,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Using cached data while offline',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade700,
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
            child: const Text('Dismiss'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _retryConnection();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showUserSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Direct Chat'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: 'Enter username to chat with',
                prefixIcon: Icon(Icons.person),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  Navigator.pop(context);
                  _navigation.navigateTo('/chat-conversation', arguments: {
                    'username': value,
                    'isNew': true,
                  });
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Show user search/selection interface
            },
            child: const Text('Browse Users'),
          ),
        ],
      ),
    );
  }

  void _showChannelCreationDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    bool isPrivate = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Create Channel'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Channel Name',
                    hintText: 'Enter channel name',
                    prefixIcon: Icon(Icons.group),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'What is this channel about?',
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('Private Channel'),
                  subtitle: const Text('Only invited members can join'),
                  value: isPrivate,
                  onChanged: (value) => setState(() => isPrivate = value ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  Navigator.pop(context);
                  context.read<ChatBloc>().add(
                    ChatChannelCreated(
                      name: nameController.text,
                      description: descriptionController.text,
                      isPrivate: isPrivate,
                    ),
                  );
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

}
