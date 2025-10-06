import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/comprehensive_chat/comprehensive_chat_bloc.dart';
import '../../../blocs/comprehensive_chat/comprehensive_chat_event.dart';
import '../../../blocs/comprehensive_chat/comprehensive_chat_state.dart';
import '../../../core/theme/design_system.dart';
import 'chat_header_widget.dart';
import 'message_list_widget.dart';
import 'message_input_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load chat data when page initializes
    context.read<ComprehensiveChatBloc>().add(ChannelsRequested());
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      final message = _messageController.text.trim();
      // Send message through ComprehensiveChatBloc
      context.read<ComprehensiveChatBloc>().add(
        MessageSent(
          channelId: 'current_channel_id', // TODO: Get from route arguments or state
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<ComprehensiveChatBloc, ComprehensiveChatState>(
      listener: (context, state) {
        if (state is ComprehensiveChatError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: DesignSystem.error,
            ),
          );
        } else if (state is MessageSentSuccess) {
          // Message sent successfully
          _scrollToBottom();
        }
      },
      child: BlocBuilder<ComprehensiveChatBloc, ComprehensiveChatState>(
        builder: (context, state) {
          // Extract messages and user info from ComprehensiveChatBloc state
          List<dynamic> chats = [];
          String userName = 'User';
          String avatarUrl = '';
          String status = 'Offline';
          if (state is ChannelsLoaded) {
            chats = state.channels.map((channel) => {
              'message': 'Channel: ${channel.name}',
              'is_me': false,
              'timestamp': DateTime.now(),
            }).toList();
            userName = 'Channel List';
          } else if (state is MessagesLoaded) {
            chats = state.messages.map((message) => {
              'message': message.content,
              'is_me': false,
              'timestamp': message.createdAt,
            }).toList();
            userName = 'Chat';
          }

          return Container(
            decoration: BoxDecoration(
              gradient: DesignSystem.gradientBackground,
            ),
            child: Column(
              children: [
                // Chat Header
                ChatHeaderWidget(
                  userName: userName,
                  avatarUrl: avatarUrl,
                  status: status,
                  onBackPressed: () {
                    // TODO: Handle back navigation
                  },
                  onVideoCallPressed: () {
                    // TODO: Handle video call
                  },
                  onVoiceCallPressed: () {
                    // TODO: Handle voice call
                  },
                ),

                // Messages Area
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: state is ChannelsLoaded || state is MessagesLoaded
                        ? MessageListWidget(
                            messages: chats,
                            scrollController: _scrollController,
                          )
                        : state is ComprehensiveChatLoading
                            ? _buildLoadingState()
                            : _buildEmptyState(),
                  ),
                ),

                // Message Input Area
                MessageInputWidget(
                  messageController: _messageController,
                  onSendPressed: _sendMessage,
                  onMessageChanged: (value) {
                    // Handle input changes
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

 Widget _buildLoadingState() {
   final theme = Theme.of(context);
   final colors = theme.designSystem?.designSystemColors;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colors?.surface ?? Colors.grey.shade100,
              borderRadius: BorderRadius.circular(50),
            ),
            child: CircularProgressIndicator(
              color: colors?.primary ?? Colors.blue,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading chat...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors?.onSurfaceVariant ?? Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final colors = theme.designSystem?.designSystemColors;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: colors?.surface ?? Colors.grey.shade100,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: colors?.onSurfaceVariant ?? Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No messages yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colors?.onSurface ?? Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a conversation by typing a message',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors?.onSurfaceVariant ?? Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}