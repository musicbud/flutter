import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/simple_content_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SimpleContentBloc, SimpleContentState>(
      builder: (context, state) {
        return Column(
          children: [
            _buildChatHeader(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<SimpleContentBloc>().add(LoadChats());
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: _buildChatList(state),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildChatHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.indigo.withValues(alpha: 0.8),
            Colors.cyan.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.chat, color: Colors.white, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Messages',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Chat with your music buddies',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList(SimpleContentState state) {
    if (state is SimpleContentLoaded && state.chats.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: state.chats.length,
        itemBuilder: (context, index) {
          final chat = state.chats[index];
          return _buildChatTile(chat);
        },
      );
    } else if (state is SimpleContentLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is SimpleContentError) {
      return _buildErrorState(state.message);
    } else {
      return _buildEmptyState();
    }
  }

  Widget _buildChatTile(Map<String, dynamic> chat) {
    final hasUnread = chat['unreadCount'] != null && chat['unreadCount'] > 0;
    final isOnline = chat['isOnline'] == true;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: _getChatColor(chat['name'] ?? ''),
              child: Text(
                _getInitials(chat['name'] ?? 'U'),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (isOnline)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                chat['name'] ?? 'Unknown',
                style: TextStyle(
                  fontWeight: hasUnread ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
            Text(
              _formatTime(chat['lastMessageAt']),
              style: TextStyle(
                fontSize: 12,
                color: hasUnread ? Theme.of(context).colorScheme.primary : Colors.grey,
                fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
        subtitle: Text(
          chat['lastMessage'] ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
            color: hasUnread ? Colors.black87 : Colors.grey[600],
          ),
        ),
        trailing: hasUnread
            ? Badge(
                label: Text('${chat['unreadCount']}'),
                backgroundColor: Theme.of(context).colorScheme.primary,
              )
            : null,
        onTap: () => _openChat(chat),
      ),
    );
  }

  Color _getChatColor(String name) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
      Colors.cyan,
    ];
    return colors[name.hashCode % colors.length].withValues(alpha: 0.8);
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';
    final words = name.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  String _formatTime(String? timestamp) {
    if (timestamp == null) return '';
    try {
      final time = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(time);

      if (difference.inMinutes < 1) {
        return 'Now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d';
      } else {
        return '${(difference.inDays / 7).floor()}w';
      }
    } catch (e) {
      return '';
    }
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text('Failed to load chats'),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<SimpleContentBloc>().add(LoadChats()),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64),
          SizedBox(height: 16),
          Text('No conversations yet'),
          SizedBox(height: 8),
          Text('Connect with music buds to start chatting!'),
        ],
      ),
    );
  }

  void _openChat(Map<String, dynamic> chat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: _getChatColor(chat['name'] ?? ''),
              child: Text(
                _getInitials(chat['name'] ?? 'U'),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat['name'] ?? 'Unknown',
                    style: const TextStyle(fontSize: 16),
                  ),
                  if (chat['isOnline'] == true)
                    const Text(
                      'Online',
                      style: TextStyle(fontSize: 12, color: Colors.green),
                    ),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Chat feature coming soon!'),
            const SizedBox(height: 16),
            const Text('For now, you can:'),
            const SizedBox(height: 8),
            const Text('• View conversation history'),
            const Text('• See online status'),
            const Text('• Send friend requests'),
            const SizedBox(height: 16),
            Text(
              'Last message: "${chat['lastMessage'] ?? 'No messages yet'}"',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Opening chat with ${chat['name']}...');
            },
            child: const Text('Open Chat'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }
}