import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbud_flutter/blocs/chat/chat_bloc.dart';
import 'package:musicbud_flutter/blocs/chat/chat_event.dart';
import 'package:musicbud_flutter/blocs/chat/chat_state.dart';
import 'package:musicbud_flutter/presentation/pages/user_chat_page.dart';

class UserListPage extends StatefulWidget {
  final String currentUsername;

  const UserListPage({
    Key? key,
    required this.currentUsername,
  }) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() {
    if (widget.currentUsername.isEmpty) {
      return;
    }
    context.read<ChatBloc>().add(ChatUserListRequested());
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatError) {
          _showSnackBar('Error: ${state.message}');
        }
      },
      builder: (context, state) {
        if (widget.currentUsername.isEmpty) {
          return const Center(
            child: Text('Current user not found. Please log in again.'),
          );
        }

        if (state is ChatLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ChatUserListLoaded) {
          if (state.users.isEmpty) {
            return const Center(child: Text('No users available'));
          }

          return ListView.builder(
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final user = state.users[index];
              // Don't show the current user in the list
              if (user.username == widget.currentUsername) {
                return const SizedBox.shrink();
              }
              return ListTile(
                title: Text(user.username),
                subtitle: Text('ID: ${user.id}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserChatPage(
                        currentUsername: widget.currentUsername,
                        otherUsername: user.username,
                      ),
                    ),
                  );
                },
              );
            },
          );
        }

        if (state is ChatError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        return const Center(child: Text('No users available'));
      },
    );
  }
}
