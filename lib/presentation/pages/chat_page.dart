import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/comprehensive_chat/comprehensive_chat_bloc.dart';
import '../../blocs/comprehensive_chat/comprehensive_chat_event.dart';
import '../../blocs/comprehensive_chat/comprehensive_chat_state.dart';
import '../widgets/common/index.dart';
import '../theme/app_theme.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final bool _isTyping = false;

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
    final appTheme = AppTheme.of(context);
    return BlocListener<ComprehensiveChatBloc, ComprehensiveChatState>(
      listener: (context, state) {
        if (state is ComprehensiveChatError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: const Color(0xFFCF6679),
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
              gradient: appTheme.gradients.backgroundGradient,
            ),
            child: Column(
              children: [
                // Enhanced Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF282828),
                    boxShadow: appTheme.shadows.shadowCard,
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        // Back Button
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3E3E3E),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Chat Partner Info
                        Expanded(
                          child: Row(
                            children: [
                              // Avatar
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: const Color(0xFFCF6679).withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 24,
                                  backgroundColor: appTheme.primaryRed,
                                  backgroundImage: avatarUrl.isNotEmpty
                                      ? NetworkImage(avatarUrl)
                                      : null,
                                  child: avatarUrl.isEmpty ? const Icon(Icons.person, color: Colors.white) : null,
                                ),
                              ),

                              const SizedBox(width: 16),

                              // Name and Status
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userName,
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: status == 'Online'
                                                ? const Color(0xFF1ED760)
                                                : const Color(0x80FFFFFF),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          status,
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: const Color(0x80FFFFFF),
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

                        // Action Buttons
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3E3E3E),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.video_call,
                                color: const Color(0xB3FFFFFF),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3E3E3E),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.call,
                                color: const Color(0xB3FFFFFF),
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Messages Area
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: state is ChannelsLoaded || state is MessagesLoaded
                        ? _buildMessagesList(chats, appTheme)
                        : state is ComprehensiveChatLoading
                            ? _buildLoadingState(appTheme)
                            : _buildEmptyState(appTheme),
                  ),
                ),

                // Message Input Area
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF282828),
                    boxShadow: appTheme.shadows.shadowCard,
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        // Attachment Button
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3E3E3E),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.attach_file,
                            color: const Color(0xB3FFFFFF),
                            size: 20,
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Message Input
                        Expanded(
                          child: ModernInputField(
                            hintText: 'Type a message...',
                            controller: _messageController,
                            onChanged: (value) {
                              // Handle input changes
                            },
                            onSubmitted: (_) => _sendMessage(),
                            size: ModernInputFieldSize.medium,
                            customBackgroundColor: const Color(0xFF3E3E3E),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Send Button
                        GestureDetector(
                          onTap: _sendMessage,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFCF6679),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: appTheme.shadows.shadowMedium,
                            ),
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessagesList(List<dynamic> chats, dynamic appTheme) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(vertical: appTheme.spacing.md),
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return _buildChatMessage(
          chat['message'] ?? 'Hello! How are you?',
          chat['is_me'] ?? false,
          chat['timestamp'] ?? DateTime.now(),
          appTheme,
        );
      },
    );
  }

  Widget _buildChatMessage(String text, bool isMe, DateTime timestamp, dynamic appTheme) {
    return Container(
      margin: EdgeInsets.only(bottom: appTheme.spacing.md),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            // Avatar for other person
            Container(
              margin: EdgeInsets.only(right: appTheme.spacing.sm),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFFCF6679),
                backgroundImage: const NetworkImage(
                  'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
                ),
              ),
            ),
          ],

          // Message Bubble
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: appTheme.spacing.md,
                vertical: appTheme.spacing.sm,
              ),
              decoration: BoxDecoration(
                color: isMe
                    ? appTheme.colors.primaryRed
                    : appTheme.colors.surfaceLight,
                borderRadius: BorderRadius.circular(appTheme.radius.lg),
                boxShadow: appTheme.shadows.shadowSmall,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: appTheme.typography.bodyMedium.copyWith(
                      color: isMe
                          ? appTheme.colors.white
                          : appTheme.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: appTheme.spacing.xs),
                  Text(
                    _formatTime(timestamp),
                    style: appTheme.typography.caption.copyWith(
                      color: isMe
                          ? appTheme.colors.white.withValues(alpha: 0.7)
                          : appTheme.colors.textMuted,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (isMe) ...[
            // Avatar for current user
            Container(
              margin: EdgeInsets.only(left: appTheme.spacing.sm),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: appTheme.colors.accentBlue,
                backgroundImage: const NetworkImage(
                  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingState(dynamic appTheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(appTheme.spacing.lg),
            decoration: BoxDecoration(
              color: appTheme.colors.surfaceDark,
              borderRadius: BorderRadius.circular(appTheme.radius.circular),
            ),
            child: CircularProgressIndicator(
              color: appTheme.colors.primaryRed,
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: appTheme.spacing.md),
          Text(
            'Loading chat...',
            style: appTheme.typography.bodyMedium.copyWith(
              color: appTheme.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(dynamic appTheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(appTheme.spacing.xl),
            decoration: BoxDecoration(
              color: appTheme.colors.surfaceDark,
              borderRadius: BorderRadius.circular(appTheme.radius.circular),
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: appTheme.colors.textSecondary,
            ),
          ),
          SizedBox(height: appTheme.spacing.md),
          Text(
            'No messages yet',
            style: appTheme.typography.titleMedium.copyWith(
              color: appTheme.colors.textPrimary,
            ),
          ),
          SizedBox(height: appTheme.spacing.sm),
          Text(
            'Start a conversation by typing a message',
            style: appTheme.typography.bodyMedium.copyWith(
              color: appTheme.colors.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }

  List<dynamic> _extractChatsFromState(Map<String, dynamic> chatHome) {
    // Extract chats from the chatHome state
    // This is a fallback in case the structure is different
    if (chatHome.containsKey('chats')) {
      return chatHome['chats'] as List<dynamic>;
    } else if (chatHome.containsKey('messages')) {
      return chatHome['messages'] as List<dynamic>;
    } else {
      // Return empty list if no chats found
      return [];
    }
  }
}

class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.timestamp,
  });
}