import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/chat/chat_management_bloc.dart';
import '../constants/app_theme.dart';
import '../widgets/common/index.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // Load chat data when page initializes
    context.read<ChatManagementBloc>().add(GetChatHome());
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

      // Send message through bloc
      context.read<ChatManagementBloc>().add(
        SendMessage(
          message: message,
          username: 'sarahjohnson', // This would come from the current chat
        ),
      );

      // Add message to local list for immediate UI update
      setState(() {
        _messages.add(ChatMessage(
          text: message,
          isMe: true,
          timestamp: DateTime.now(),
        ));
      });

      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return BlocListener<ChatManagementBloc, ChatManagementState>(
      listener: (context, state) {
        if (state is ChatManagementError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: appTheme.colors.errorRed,
            ),
          );
        } else if (state is MessageSent) {
          // Message was sent successfully
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Message sent!'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      },
      child: BlocBuilder<ChatManagementBloc, ChatManagementState>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              gradient: appTheme.gradients.backgroundGradient,
            ),
            child: Column(
              children: [
                // Enhanced Header
                Container(
                  padding: EdgeInsets.all(appTheme.spacing.lg),
                  decoration: BoxDecoration(
                    color: appTheme.colors.surfaceDark,
                    boxShadow: appTheme.shadows.shadowCard,
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        // Back Button
                        Container(
                          padding: EdgeInsets.all(appTheme.spacing.sm),
                          decoration: BoxDecoration(
                            color: appTheme.colors.surfaceLight,
                            borderRadius: BorderRadius.circular(appTheme.radius.md),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: appTheme.colors.textPrimary,
                            size: 20,
                          ),
                        ),

                        SizedBox(width: appTheme.spacing.md),

                        // Chat Partner Info
                        Expanded(
                          child: Row(
                            children: [
                              // Avatar
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(appTheme.radius.circular),
                                  border: Border.all(
                                    color: appTheme.colors.primaryRed.withValues(alpha: 0.3),
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 24,
                                  backgroundColor: appTheme.colors.primaryRed,
                                  backgroundImage: NetworkImage(
                                    'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
                                  ),
                                ),
                              ),

                              SizedBox(width: appTheme.spacing.md),

                              // Name and Status
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sarah Johnson',
                                      style: appTheme.typography.titleMedium.copyWith(
                                        color: appTheme.colors.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: appTheme.colors.accentGreen,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ),
                                        SizedBox(width: appTheme.spacing.xs),
                                        Text(
                                          'Online',
                                          style: appTheme.typography.caption.copyWith(
                                            color: appTheme.colors.textMuted,
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
                              padding: EdgeInsets.all(appTheme.spacing.sm),
                              decoration: BoxDecoration(
                                color: appTheme.colors.surfaceLight,
                                borderRadius: BorderRadius.circular(appTheme.radius.md),
                              ),
                              child: Icon(
                                Icons.video_call,
                                color: appTheme.colors.textSecondary,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: appTheme.spacing.sm),
                            Container(
                              padding: EdgeInsets.all(appTheme.spacing.sm),
                              decoration: BoxDecoration(
                                color: appTheme.colors.surfaceLight,
                                borderRadius: BorderRadius.circular(appTheme.radius.md),
                              ),
                              child: Icon(
                                Icons.call,
                                color: appTheme.colors.textSecondary,
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
                    padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                    child: state is ChatHomeLoaded
                        ? _buildMessagesList(_extractChatsFromState(state.chatHome), appTheme)
                        : state is ChatManagementLoading
                            ? _buildLoadingState(appTheme)
                            : _buildEmptyState(appTheme),
                  ),
                ),

                // Message Input Area
                Container(
                  padding: EdgeInsets.all(appTheme.spacing.lg),
                  decoration: BoxDecoration(
                    color: appTheme.colors.surfaceDark,
                    boxShadow: appTheme.shadows.shadowCard,
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        // Attachment Button
                        Container(
                          padding: EdgeInsets.all(appTheme.spacing.sm),
                          decoration: BoxDecoration(
                            color: appTheme.colors.surfaceLight,
                            borderRadius: BorderRadius.circular(appTheme.radius.md),
                          ),
                          child: Icon(
                            Icons.attach_file,
                            color: appTheme.colors.textSecondary,
                            size: 20,
                          ),
                        ),

                        SizedBox(width: appTheme.spacing.md),

                        // Message Input
                        Expanded(
                          child: ModernInputField(
                            hintText: 'Type a message...',
                            controller: _messageController,
                            onChanged: (value) {
                              // Handle input changes
                            },
                            
                            size: ModernInputFieldSize.medium,
                            customBackgroundColor: appTheme.colors.surfaceLight,
                          ),
                        ),

                        SizedBox(width: appTheme.spacing.md),

                        // Send Button
                        Container(
                          padding: EdgeInsets.all(appTheme.spacing.sm),
                          decoration: BoxDecoration(
                            color: appTheme.colors.primaryRed,
                            borderRadius: BorderRadius.circular(appTheme.radius.md),
                            boxShadow: appTheme.shadows.shadowMedium,
                          ),
                          child: Icon(
                            Icons.send,
                            color: appTheme.colors.white,
                            size: 20,
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

  Widget _buildMessagesList(List<dynamic> chats, AppTheme appTheme) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(vertical: appTheme.spacing.md),
      itemCount: chats.length + _messages.length,
      itemBuilder: (context, index) {
        if (index < chats.length) {
          final chat = chats[index];
          return _buildChatMessage(
            chat['message'] ?? 'Hello! How are you?',
            chat['is_me'] ?? false,
            chat['timestamp'] ?? DateTime.now(),
            appTheme,
          );
        } else {
          final messageIndex = index - chats.length;
          final message = _messages[messageIndex];
          return _buildChatMessage(
            message.text,
            message.isMe,
            message.timestamp,
            appTheme,
          );
        }
      },
    );
  }

  Widget _buildChatMessage(String text, bool isMe, DateTime timestamp, AppTheme appTheme) {
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
                backgroundColor: appTheme.colors.primaryRed,
                backgroundImage: NetworkImage(
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
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingState(AppTheme appTheme) {
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

  Widget _buildEmptyState(AppTheme appTheme) {
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