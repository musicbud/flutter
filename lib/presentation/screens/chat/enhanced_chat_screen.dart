import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/components/musicbud_components.dart';
import '../../../core/theme/design_system.dart';
import '../../../services/dynamic_navigation_service.dart';
import '../../../services/mock_data_service.dart';
import '../../../blocs/chat/chat_bloc.dart';
import '../../../blocs/chat/chat_event.dart';
import '../../../blocs/chat/chat_state.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../../blocs/user/user_state.dart';

/// Enhanced Chat Screen using MusicBud Components Library
/// Preserves all BLoC architecture and real data consumption
class EnhancedChatScreen extends StatefulWidget {
  const EnhancedChatScreen({super.key});

  @override
  State<EnhancedChatScreen> createState() => _EnhancedChatScreenState();
}

class _EnhancedChatScreenState extends State<EnhancedChatScreen> {
  final DynamicNavigationService _navigation = DynamicNavigationService.instance;
  final TextEditingController _searchController = TextEditingController();
  
  // State variables
  bool _hasTriggeredInitialLoad = false;
  bool _isOffline = false;
  bool _isSearching = false;
  String _searchQuery = '';
  
  // Mock data for offline fallback
  List<Map<String, dynamic>>? _mockConversations;
  List<Map<String, dynamic>>? _mockActiveFriends;

  @override
  void initState() {
    super.initState();
    _initializeMockData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _initializeMockData() {
    _mockConversations = MockDataService.generateMockConversations(count: 15);
    _mockActiveFriends = MockDataService.generateMockUsers(count: 10);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _isSearching = _searchQuery.isNotEmpty;
    });
  }

  void _triggerInitialDataLoad() {
    if (!_hasTriggeredInitialLoad && !_isOffline) {
      _hasTriggeredInitialLoad = true;
      try {
        context.read<ChatBloc>().add(const LoadConversations());
      } catch (e) {
        setState(() => _isOffline = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Trigger initial data load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerInitialDataLoad();
    });

    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatError) {
          setState(() {
            if (state.message.contains('network') || state.message.contains('connection')) {
              _isOffline = true;
            }
          });
        } else if (state is ConversationsLoaded) {
          setState(() => _isOffline = false);
        }
      },
      child: Scaffold(
        backgroundColor: DesignSystem.background,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            // Active Friends Stories
            _buildActiveFriendsSection(),

            // Search Bar
            _buildSearchBar(),

            const SizedBox(height: DesignSystem.spacingMD),

            // Conversations List
            Expanded(
              child: _buildConversationsList(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _navigation.navigateTo('/chat/new');
          },
          backgroundColor: DesignSystem.pinkAccent,
          child: const Icon(Icons.chat, color: DesignSystem.onPrimary),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: DesignSystem.surfaceContainer,
      elevation: 0,
      title: Text(
        'Messages',
        style: DesignSystem.headlineSmall.copyWith(
          color: DesignSystem.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        if (_isOffline)
          IconButton(
            icon: const Icon(Icons.refresh, color: DesignSystem.onSurface),
            onPressed: _retryConnection,
          ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: DesignSystem.onSurface),
          onPressed: () {
            _showOptionsMenu();
          },
        ),
      ],
    );
  }

  Widget _buildActiveFriendsSection() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        List<Map<String, dynamic>> activeFriends = [];
        
        if (state is UserProfileLoaded) {
          // TODO: Get active friends from state when available
          activeFriends = _mockActiveFriends ?? [];
        } else if (_isOffline && _mockActiveFriends != null) {
          activeFriends = _mockActiveFriends!;
        } else {
          activeFriends = _mockActiveFriends ?? [];
        }

        if (activeFriends.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 100,
          margin: const EdgeInsets.only(top: DesignSystem.spacingMD),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingLG),
            itemCount: activeFriends.length,
            itemBuilder: (context, index) {
              final friend = activeFriends[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index < activeFriends.length - 1 ? DesignSystem.spacingMD : 0,
                ),
                child: _buildActiveStoryItem(friend),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildActiveStoryItem(Map<String, dynamic> friend) {
    return GestureDetector(
      onTap: () {
        debugPrint('Story tapped: ${friend['username']}');
      },
      child: Column(
        children: [
          Stack(
            children: [
              MusicBudAvatar(
                imageUrl: friend['imageUrl'],
                size: 60,
                hasBorder: true,
                borderColor: DesignSystem.pinkAccent,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: DesignSystem.successGreen,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: DesignSystem.background,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignSystem.spacingXXS),
          SizedBox(
            width: 60,
            child: Text(
              friend['username'] ?? 'User',
              style: DesignSystem.bodySmall.copyWith(
                color: DesignSystem.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.spacingLG,
        vertical: DesignSystem.spacingMD,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingMD),
        decoration: BoxDecoration(
          color: DesignSystem.surfaceContainer,
          borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search,
              color: DesignSystem.onSurfaceVariant,
              size: 20,
            ),
            const SizedBox(width: DesignSystem.spacingSM),
            Expanded(
              child: TextField(
                controller: _searchController,
                style: DesignSystem.bodyMedium.copyWith(
                  color: DesignSystem.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'Search conversations...',
                  hintStyle: DesignSystem.bodyMedium.copyWith(
                    color: DesignSystem.onSurfaceVariant,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            if (_isSearching)
              IconButton(
                icon: const Icon(
                  Icons.clear,
                  color: DesignSystem.onSurfaceVariant,
                  size: 20,
                ),
                onPressed: () {
                  _searchController.clear();
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationsList() {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        List<Map<String, dynamic>> conversations = [];

        if (state is ConversationsLoaded) {
          conversations = state.conversations.map((conv) => {
            'id': conv.id,
            'username': conv.otherUserName,
            'lastMessage': conv.lastMessage,
            'timestamp': conv.lastMessageTime,
            'unreadCount': conv.unreadCount,
            'imageUrl': conv.otherUserAvatar,
            'isOnline': conv.isOtherUserOnline,
          }).toList();
        } else if (_isOffline && _mockConversations != null) {
          conversations = _mockConversations!;
        } else if (state is ChatInitial) {
          conversations = _mockConversations ?? [];
        }

        // Apply search filter
        if (_isSearching) {
          conversations = conversations.where((conv) {
            final username = (conv['username'] ?? '').toLowerCase();
            final lastMessage = (conv['lastMessage'] ?? '').toLowerCase();
            return username.contains(_searchQuery) || lastMessage.contains(_searchQuery);
          }).toList();
        }

        if (state is ChatLoading && !_isOffline) {
          return _buildLoadingState();
        }

        if (conversations.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<ChatBloc>().add(const LoadConversations());
            await Future.delayed(const Duration(seconds: 1));
          },
          backgroundColor: DesignSystem.surfaceContainer,
          color: DesignSystem.pinkAccent,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingLG),
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              return _buildConversationItem(conversation);
            },
          ),
        );
      },
    );
  }

  Widget _buildConversationItem(Map<String, dynamic> conversation) {
    final String username = conversation['username'] ?? 'Unknown User';
    final String lastMessage = conversation['lastMessage'] ?? 'No messages yet';
    final String timestamp = conversation['timestamp'] ?? '';
    final int unreadCount = conversation['unreadCount'] ?? 0;
    final String? imageUrl = conversation['imageUrl'];
    final bool isOnline = conversation['isOnline'] ?? false;

    return MessageListItem(
      avatarUrl: imageUrl,
      name: username,
      message: lastMessage,
      timestamp: timestamp,
      unreadCount: unreadCount,
      isOnline: isOnline,
      onTap: () {
        _navigation.navigateTo('/chat/${conversation['id']}');
      },
      onLongPress: () {
        _showConversationOptions(conversation);
      },
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingLG),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: DesignSystem.spacingMD),
          padding: const EdgeInsets.all(DesignSystem.spacingMD),
          decoration: BoxDecoration(
            color: DesignSystem.surfaceContainer,
            borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: DesignSystem.surface,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: DesignSystem.spacingMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 14,
                      decoration: BoxDecoration(
                        color: DesignSystem.surface,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: DesignSystem.spacingXXS),
                    Container(
                      width: double.infinity,
                      height: 12,
                      decoration: BoxDecoration(
                        color: DesignSystem.surface,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _isSearching ? Icons.search_off : Icons.chat_bubble_outline,
            size: 64,
            color: DesignSystem.onSurfaceVariant,
          ),
          const SizedBox(height: DesignSystem.spacingLG),
          Text(
            _isSearching ? 'No conversations found' : 'No messages yet',
            style: DesignSystem.titleMedium.copyWith(
              color: DesignSystem.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: DesignSystem.spacingSM),
          Text(
            _isSearching
                ? 'Try a different search term'
                : 'Start a conversation to connect\nwith music enthusiasts!',
            style: DesignSystem.bodyMedium.copyWith(
              color: DesignSystem.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (!_isSearching) ...[
            const SizedBox(height: DesignSystem.spacingXL),
            MusicBudButton(
              text: 'Start a Chat',
              onPressed: () {
                _navigation.navigateTo('/chat/new');
              },
              icon: Icons.add_comment,
            ),
          ],
        ],
      ),
    );
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: DesignSystem.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(DesignSystem.radiusLG)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.mark_chat_read, color: DesignSystem.onSurface),
                title: const Text('Mark all as read', style: DesignSystem.bodyMedium),
                onTap: () {
                  Navigator.pop(context);
                  debugPrint('Mark all as read');
                },
              ),
              ListTile(
                leading: const Icon(Icons.archive, color: DesignSystem.onSurface),
                title: const Text('Archived chats', style: DesignSystem.bodyMedium),
                onTap: () {
                  Navigator.pop(context);
                  _navigation.navigateTo('/chat/archived');
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: DesignSystem.onSurface),
                title: const Text('Chat settings', style: DesignSystem.bodyMedium),
                onTap: () {
                  Navigator.pop(context);
                  _navigation.navigateTo('/settings/chat');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showConversationOptions(Map<String, dynamic> conversation) {
    showModalBottomSheet(
      context: context,
      backgroundColor: DesignSystem.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(DesignSystem.radiusLG)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.mark_chat_read, color: DesignSystem.onSurface),
                title: const Text('Mark as read', style: DesignSystem.bodyMedium),
                onTap: () {
                  Navigator.pop(context);
                  debugPrint('Mark as read: ${conversation['id']}');
                },
              ),
              ListTile(
                leading: const Icon(Icons.push_pin, color: DesignSystem.onSurface),
                title: const Text('Pin conversation', style: DesignSystem.bodyMedium),
                onTap: () {
                  Navigator.pop(context);
                  debugPrint('Pin conversation: ${conversation['id']}');
                },
              ),
              ListTile(
                leading: const Icon(Icons.archive, color: DesignSystem.onSurface),
                title: const Text('Archive', style: DesignSystem.bodyMedium),
                onTap: () {
                  Navigator.pop(context);
                  debugPrint('Archive conversation: ${conversation['id']}');
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: DesignSystem.errorRed),
                title: Text(
                  'Delete conversation',
                  style: DesignSystem.bodyMedium.copyWith(color: DesignSystem.errorRed),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDeleteConversation(conversation);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDeleteConversation(Map<String, dynamic> conversation) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: DesignSystem.surfaceContainer,
          title: Text(
            'Delete Conversation?',
            style: DesignSystem.titleMedium.copyWith(color: DesignSystem.onSurface),
          ),
          content: Text(
            'This will delete the conversation with ${conversation['username']}. This action cannot be undone.',
            style: DesignSystem.bodyMedium.copyWith(color: DesignSystem.onSurfaceVariant),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: DesignSystem.onSurface)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<ChatBloc>().add(DeleteConversation(conversation['id']));
              },
              child: const Text('Delete', style: TextStyle(color: DesignSystem.errorRed)),
            ),
          ],
        );
      },
    );
  }

  void _retryConnection() {
    setState(() {
      _isOffline = false;
      _hasTriggeredInitialLoad = false;
    });
    _triggerInitialDataLoad();
  }
}
