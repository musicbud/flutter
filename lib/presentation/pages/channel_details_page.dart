import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbud_flutter/blocs/chat/chat_bloc.dart';
import 'package:musicbud_flutter/blocs/chat/chat_event.dart';
import 'package:musicbud_flutter/blocs/chat/chat_state.dart';
import 'package:musicbud_flutter/presentation/pages/chat_room_page.dart';
import 'package:musicbud_flutter/presentation/pages/channel_dashboard_page.dart';

class ChannelDetailsPage extends StatefulWidget {
  final String channelId;
  final String currentUsername;

  const ChannelDetailsPage({
    Key? key,
    required this.channelId,
    required this.currentUsername,
  }) : super(key: key);

  @override
  ChannelDetailsPageState createState() => ChannelDetailsPageState();
}

class ChannelDetailsPageState extends State<ChannelDetailsPage> {
  bool isAdmin = false;
  bool isModerator = false;
  bool isMember = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    context.read<ChatBloc>().add(ChatChannelDetailsRequested(widget.channelId));
    context.read<ChatBloc>().add(ChatChannelRolesChecked(widget.channelId));
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _requestJoinChannel() {
    context.read<ChatBloc>().add(ChatChannelJoinRequested(widget.channelId));
  }

  void _enterChatRoom() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatRoomPage(
          channelId: widget.channelId,
          currentUsername: widget.currentUsername,
        ),
      ),
    );
  }

  void _navigateToDashboard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChannelDashboardPage(
          channelId: widget.channelId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatChannelRolesLoaded) {
          setState(() {
            isAdmin = state.roles['is_admin'] ?? false;
            isModerator = state.roles['is_moderator'] ?? false;
            isMember = state.roles['is_member'] ?? false;
          });
        } else if (state is ChatChannelJoinRequestedSuccess) {
          _showSnackBar('Join request sent successfully');
        } else if (state is ChatError) {
          _showSnackBar('Error: ${state.message}');
        }
      },
      builder: (context, state) {
        if (state is ChatLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final details =
            state is ChatChannelDetailsLoaded ? state.details : null;

        if (details == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Channel Details')),
            body: const Center(child: Text('Failed to load details')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Channel Details')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Details for Channel ${widget.channelId}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text('Name: ${details.channel.name}'),
                Text('Description: ${details.channel.description}'),
                const SizedBox(height: 16),
                if (isMember) ...[
                  const Text('You are a member of this channel.'),
                  if (isAdmin)
                    const Text('You are an admin of this channel.')
                  else if (isModerator)
                    const Text('You are a moderator of this channel.'),
                  ElevatedButton(
                    onPressed: _enterChatRoom,
                    child: const Text('Enter Chat'),
                  ),
                  if (isAdmin)
                    ElevatedButton(
                      onPressed: _navigateToDashboard,
                      child: const Text('Dashboard'),
                    ),
                ] else ...[
                  const Text('You are not a member of this channel.'),
                  ElevatedButton(
                    onPressed: _requestJoinChannel,
                    child: const Text('Request to Join'),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
