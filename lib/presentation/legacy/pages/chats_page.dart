import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../blocs/chats/chats_bloc.dart';
import '../../blocs/chats/chats_event.dart';
import '../../blocs/chats/chats_state.dart';
import '../widgets/loading_indicator.dart';
import 'direct_message_screen.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ChatsBloc>().add(const ChatsRequested());
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return DateFormat('MMM d').format(timestamp);
    } else {
      return DateFormat('HH:mm').format(timestamp);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatsBloc, ChatsState>(
      listener: (context, state) {
        if (state is ChatsFailure) {
          _showErrorSnackBar(state.error);
        }
      },
      builder: (context, state) {
        if (state is ChatsLoading) {
          return const LoadingIndicator();
        }

        if (state is ChatsLoaded) {
          if (state.chats.isEmpty) {
            return const Center(
              child: Text('No chats yet'),
            );
          }

          return ListView.builder(
            itemCount: state.chats.length,
            itemBuilder: (context, index) {
              final chat = state.chats[index];
              return Dismissible(
                key: Key(chat.userId),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  context
                      .read<ChatsBloc>()
                      .add(ChatDeleted(userId: chat.userId));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: chat.unreadCount > 0
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: chat.avatarUrl != null
                          ? NetworkImage(chat.avatarUrl!)
                          : null,
                      child: chat.avatarUrl == null
                          ? Text(chat.username[0].toUpperCase())
                          : null,
                    ),
                    title: Text(chat.username),
                    subtitle: Text(
                      chat.lastMessage ?? 'No messages yet',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (chat.lastMessageAt != null)
                          Text(_formatTimestamp(chat.lastMessageAt!)),
                        if (chat.unreadCount > 0)
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              chat.unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DirectMessageScreen(userId: chat.userId),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        }

        return const Center(
          child: Text('Something went wrong'),
        );
      },
    );
  }
}
