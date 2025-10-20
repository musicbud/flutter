import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/comprehensive_chat/comprehensive_chat_bloc.dart';
import '../../../blocs/comprehensive_chat/comprehensive_chat_event.dart';
import '../../../blocs/comprehensive_chat/comprehensive_chat_state.dart';
import '../../widgets/imported/index.dart';
import '../../../presentation/navigation/main_navigation.dart';
import '../../../presentation/navigation/navigation_drawer.dart';
import 'message_list_widget.dart';
import 'message_input_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with LoadingStateMixin, ErrorStateMixin, TickerProviderStateMixin {
  
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late final MainNavigationController _navigationController;
  
  String? _selectedChannelId;
  bool _isSearchMode = false;
  List<dynamic> _filteredChannels = [];
  List<dynamic> _allChannels = [];

  @override
  void initState() {
    super.initState();
    _navigationController = MainNavigationController();
    _initializeData();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    _navigationController.dispose();
    super.dispose();
  }

  void _initializeData() {
    setLoadingState(LoadingState.loading);
    context.read<ComprehensiveChatBloc>().add(ChannelsRequested());
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty && _selectedChannelId != null) {
      final message = _messageController.text.trim();
      context.read<ComprehensiveChatBloc>().add(
        MessageSent(
          channelId: _selectedChannelId!,
          content: message,
        ),
      );
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _selectChannel(String channelId, String channelName) {
    setState(() {
      _selectedChannelId = channelId;
    });
    // Load messages for selected channel
    context.read<ComprehensiveChatBloc>().add(
      MessagesRequested(channelId: channelId),
    );
  }

  void _toggleSearchMode() {
    setState(() {
      _isSearchMode = !_isSearchMode;
      if (!_isSearchMode) {
        _searchController.clear();
        _filteredChannels = _allChannels;
      }
    });
  }

  void _filterChannels(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredChannels = _allChannels;
      } else {
        _filteredChannels = _allChannels.where((channel) {
          return channel.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ComprehensiveChatBloc, ComprehensiveChatState>(
      listener: (context, state) {
        if (state is ComprehensiveChatError) {
          setError(
            state.message,
            type: ErrorType.network,
            retryable: true,
          );
          setLoadingState(LoadingState.error);
        } else if (state is MessageSentSuccess) {
          _scrollToBottom();
        } else if (state is ChannelsLoaded) {
          _allChannels = state.channels;
          _filteredChannels = state.channels;
          setLoadingState(LoadingState.loaded);
        } else if (state is MessagesLoaded) {
          setLoadingState(LoadingState.loaded);
        } else if (state is ComprehensiveChatLoading) {
          setLoadingState(LoadingState.loading);
        }
      },
      builder: (context, state) {
        return AppScaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(_selectedChannelId != null ? 'Chat' : 'Messages'),
            centerTitle: true,
            actions: [
              if (_selectedChannelId == null) ...[
                IconButton(
                  icon: Icon(_isSearchMode ? Icons.close : Icons.search),
                  onPressed: _toggleSearchMode,
                  tooltip: _isSearchMode ? 'Close Search' : 'Search Channels',
                ),
              ],
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _initializeData,
                tooltip: 'Refresh',
              ),
            ],
            leading: _selectedChannelId != null
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => setState(() => _selectedChannelId = null),
                  )
                : IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
          ),
          drawer: MainNavigationDrawer(
            navigationController: _navigationController,
          ),
          body: ResponsiveLayout(
            builder: (context, breakpoint) {
              switch (breakpoint) {
                case ResponsiveBreakpoint.xs:
                case ResponsiveBreakpoint.sm:
                  return _buildMobileLayout(state);
                case ResponsiveBreakpoint.md:
                case ResponsiveBreakpoint.lg:
                case ResponsiveBreakpoint.xl:
                  return _buildDesktopLayout(state);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout(ComprehensiveChatState state) {
    if (_selectedChannelId == null) {
      return _buildChannelList(state);
    } else {
      return _buildChatInterface(state);
    }
  }

  Widget _buildDesktopLayout(ComprehensiveChatState state) {
    return Row(
      children: [
        SizedBox(
          width: 350,
          child: _buildChannelSidebar(state),
        ),
        Expanded(
          child: _selectedChannelId != null
              ? _buildChatInterface(state)
              : _buildNoChatSelected(),
        ),
      ],
    );
  }

  Widget _buildChannelList(ComprehensiveChatState state) {
    return buildLoadingState(
      context: context,
      loadedWidget: Column(
        children: [
          if (_isSearchMode) _buildSearchBar(),
          Expanded(child: _buildChannelListContent(state)),
        ],
      ),
      loadingWidget: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading your conversations...',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      errorWidget: buildDefaultErrorWidget(
        context: context,
        onRetry: _initializeData,
      ),
    );
  }

  Widget _buildChannelSidebar(ComprehensiveChatState state) {
    return ModernCard(
      variant: ModernCardVariant.outlined,
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Conversations',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(_isSearchMode ? Icons.close : Icons.search),
                  onPressed: _toggleSearchMode,
                  tooltip: _isSearchMode ? 'Close Search' : 'Search Channels',
                ),
              ],
            ),
          ),
          if (_isSearchMode) _buildSearchBar(),
          Expanded(child: _buildChannelListContent(state)),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ModernInputField(
        controller: _searchController,
        hintText: 'Search conversations...',
        prefixIcon: const Icon(Icons.search),
        onChanged: _filterChannels,
      ),
    );
  }

  Widget _buildChannelListContent(ComprehensiveChatState state) {
    if (state is ChannelsLoaded) {
      if (_filteredChannels.isEmpty) {
        return EmptyState(
          icon: Icons.search_off,
          title: _isSearchMode ? 'No Results Found' : 'No Conversations',
          message: _isSearchMode 
              ? 'Try a different search term'
              : 'Start chatting with your music buds',
          actionText: _isSearchMode ? 'Clear Search' : 'Find Buds',
          actionCallback: _isSearchMode 
              ? () => _searchController.clear()
              : () => _showComingSoon('Bud Discovery'),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          _initializeData();
          await Future.delayed(const Duration(seconds: 1));
        },
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _filteredChannels.length,
          itemBuilder: (context, index) {
            final channel = _filteredChannels[index];
            return _buildChannelCard(channel);
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildChannelCard(dynamic channel) {
    final isSelected = _selectedChannelId == channel.id;
    
    return ModernCard(
      variant: isSelected 
          ? ModernCardVariant.elevated 
          : ModernCardVariant.primary,
      margin: const EdgeInsets.only(bottom: 8),
      onTap: () => _selectChannel(channel.id, channel.name),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blue.withValues(alpha: 0.1),
              child: Text(
                channel.name.isNotEmpty ? channel.name[0].toUpperCase() : '#',
                style: TextStyle(
                  color: Colors.blue[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    channel.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    channel.description ?? 'Music chat channel',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.blue[700],
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatInterface(ComprehensiveChatState state) {
    return Column(
      children: [
        // Chat Header with channel info
        _buildChatHeader(state),
        
        // Messages Area
        Expanded(
          child: _buildMessagesArea(state),
        ),
        
        // Message Input
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildChatHeader(ComprehensiveChatState state) {
    final channelName = _getSelectedChannelName(state);
    
    return ModernCard(
      variant: ModernCardVariant.outlined,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.green.withValues(alpha: 0.1),
              child: const Icon(Icons.chat, color: Colors.green),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    channelName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Music chat channel',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showComingSoon('Channel Options'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesArea(ComprehensiveChatState state) {
    return buildLoadingState(
      context: context,
      loadedWidget: _buildMessagesList(state),
      loadingWidget: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading messages...',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      errorWidget: buildDefaultErrorWidget(
        context: context,
        onRetry: () => _initializeData(),
      ),
    );
  }

  Widget _buildMessagesList(ComprehensiveChatState state) {
    if (state is MessagesLoaded) {
      if (state.messages.isEmpty) {
        return EmptyState(
          icon: Icons.chat_bubble_outline,
          title: 'No Messages Yet',
          message: 'Start the conversation by sending a message',
          actionText: 'Send Hi! 👋',
          actionCallback: () {
            _messageController.text = 'Hi! 👋';
            _sendMessage();
          },
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: MessageListWidget(
          messages: state.messages.map((message) => {
            'message': message.content,
            'is_me': false, // TODO: Determine if message is from current user
            'timestamp': message.createdAt,
          }).toList(),
          scrollController: _scrollController,
        ),
      );
    }

    return EmptyState(
      icon: Icons.chat_bubble_outline,
      title: 'Select a Channel',
      message: 'Choose a conversation to start chatting',
      actionText: 'View Channels',
      actionCallback: () => setState(() => _selectedChannelId = null),
    );
  }

  Widget _buildMessageInput() {
    return ModernCard(
      variant: ModernCardVariant.elevated,
      margin: const EdgeInsets.all(16),
      child: MessageInputWidget(
        messageController: _messageController,
        onSendPressed: _sendMessage,
        onMessageChanged: (value) {
          // Handle input changes if needed
        },
      ),
    );
  }

  Widget _buildNoChatSelected() {
    return EmptyState(
      icon: Icons.chat,
      title: 'Welcome to Chat',
      message: 'Select a conversation from the sidebar to start chatting with your music buds',
      actionText: 'Create New Chat',
      actionCallback: () => _showComingSoon('Create Chat'),
    );
  }

  String _getSelectedChannelName(ComprehensiveChatState state) {
    if (_selectedChannelId != null && state is ChannelsLoaded) {
      try {
        final channel = state.channels.firstWhere(
          (c) => c.id == _selectedChannelId,
        );
        return channel.name;
      } catch (e) {
        return 'Chat';
      }
    }
    return 'Chat';
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  VoidCallback? get retryLoading => _initializeData;

  @override
  VoidCallback? get onLoadingStarted => () {
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  };

  @override
  VoidCallback? get onLoadingCompleted => () {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chat loaded!'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  };
}
