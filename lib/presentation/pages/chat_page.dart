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
            return Scaffold(
              backgroundColor: appTheme.colors.darkTone,
              appBar: AppBar(
                backgroundColor: appTheme.colors.darkTone,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: appTheme.colors.pureWhite),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: appTheme.colors.primaryRed,
                      backgroundImage: NetworkImage('https://via.placeholder.com/100'),
                    ),
                    SizedBox(width: appTheme.spacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sarah Johnson',
                            style: appTheme.typography.titleMedium.copyWith(
                              color: appTheme.colors.pureWhite,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Online',
                            style: appTheme.typography.bodySmall.copyWith(
                              color: appTheme.colors.successGreen,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.video_call, color: appTheme.colors.pureWhite),
                    onPressed: () {
                      // Handle video call
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.call, color: appTheme.colors.pureWhite),
                    onPressed: () {
                      // Handle voice call
                    },
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: appTheme.colors.pureWhite),
                    onSelected: (value) {
                      switch (value) {
                        case 'profile':
                          // Navigate to profile
                          break;
                        case 'block':
                          // Block user
                          break;
                        case 'report':
                          // Report user
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'profile',
                        child: Row(
                          children: [
                            Icon(Icons.person, size: 20),
                            SizedBox(width: appTheme.spacing.sm),
                            Text('View Profile'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'block',
                        child: Row(
                          children: [
                            Icon(Icons.block, size: 20),
                            SizedBox(width: appTheme.spacing.sm),
                            Text('Block User'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'report',
                        child: Row(
                          children: [
                            Icon(Icons.report, size: 20),
                            SizedBox(width: appTheme.spacing.sm),
                            Text('Report'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              body: Column(
                children: [
                  // Chat Messages
                  Expanded(
                    child: _messages.isEmpty
                        ? _buildEmptyChatState(appTheme)
                        : ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.all(appTheme.spacing.md),
                            itemCount: _messages.length,
                            itemBuilder: (context, index) {
                              final message = _messages[index];
                              return _buildMessageBubble(message, appTheme);
                            },
                          ),
                  ),

                  // Typing Indicator
                  if (_isTyping)
                    Container(
                      padding: EdgeInsets.all(appTheme.spacing.md),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: appTheme.colors.primaryRed,
                            backgroundImage: NetworkImage('https://via.placeholder.com/100'),
                          ),
                          SizedBox(width: appTheme.spacing.sm),
                          Container(
                            padding: EdgeInsets.all(appTheme.spacing.sm),
                            decoration: BoxDecoration(
                              color: appTheme.colors.neutralGray.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(appTheme.radius.lg),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildTypingDot(appTheme, 0),
                                _buildTypingDot(appTheme, 1),
                                _buildTypingDot(appTheme, 2),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Message Input
                  Container(
                    padding: EdgeInsets.all(appTheme.spacing.md),
                    decoration: BoxDecoration(
                      color: appTheme.colors.darkTone,
                      border: Border(
                        top: BorderSide(
                          color: appTheme.colors.lightGray.withOpacity(0.2),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.attach_file,
                            color: appTheme.colors.lightGray,
                          ),
                          onPressed: () {
                            // Handle file attachment
                          },
                        ),
                        Expanded(
                          child: AppInputField(
                            controller: _messageController,
                            hintText: 'Type a message...',
                            variant: AppInputVariant.chat,
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        SizedBox(width: appTheme.spacing.sm),
                        IconButton(
                          icon: Icon(
                            Icons.send,
                            color: appTheme.colors.primaryRed,
                          ),
                          onPressed: _sendMessage,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
  }

  Widget _buildEmptyChatState(AppTheme appTheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: appTheme.colors.lightGray,
          ),
          SizedBox(height: appTheme.spacing.md),
          Text(
            'Start a conversation',
            style: appTheme.typography.titleMedium.copyWith(
              color: appTheme.colors.pureWhite,
            ),
          ),
          SizedBox(height: appTheme.spacing.sm),
          Text(
            'Send a message to begin chatting',
            style: appTheme.typography.bodyMedium.copyWith(
              color: appTheme.colors.lightGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, AppTheme appTheme) {
    return Container(
      margin: EdgeInsets.only(bottom: appTheme.spacing.md),
      child: Row(
        mainAxisAlignment: message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isMe) ...[
            CircleAvatar(
              radius: 18,
              backgroundColor: appTheme.colors.primaryRed,
              backgroundImage: NetworkImage('https://via.placeholder.com/100'),
            ),
            SizedBox(width: appTheme.spacing.sm),
          ],

          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: EdgeInsets.all(appTheme.spacing.md),
              decoration: BoxDecoration(
                color: message.isMe
                    ? appTheme.colors.primaryRed
                    : appTheme.colors.darkTone,
                borderRadius: BorderRadius.circular(appTheme.radius.lg),
                border: message.isMe ? null : Border.all(
                  color: appTheme.colors.lightGray.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!message.isMe && message.senderName != null)
                    Text(
                      message.senderName!,
                      style: appTheme.typography.bodyH8.copyWith(
                        color: appTheme.colors.primaryRed,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  if (!message.isMe && message.senderName != null)
                    SizedBox(height: appTheme.spacing.xs),
                  Text(
                    message.text,
                    style: appTheme.typography.bodyH8.copyWith(
                      color: message.isMe
                          ? appTheme.colors.pureWhite
                          : appTheme.colors.lightGray,
                    ),
                  ),
                  SizedBox(height: appTheme.spacing.xs),
                  Text(
                    _formatTime(message.timestamp),
                    style: appTheme.typography.bodyH8.copyWith(
                      color: message.isMe
                          ? appTheme.colors.pureWhite.withOpacity(0.7)
                          : appTheme.colors.lightGray.withOpacity(0.7),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(AppTheme appTheme, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: appTheme.colors.primaryRed,
        borderRadius: BorderRadius.circular(4),
      ),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 600),
        builder: (context, value, child) {
          return Transform.scale(
            scale: 0.5 + (0.5 * value),
            child: child,
          );
        },
        child: Container(),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }
}

class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final String? senderName;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.timestamp,
    this.senderName,
  });
}