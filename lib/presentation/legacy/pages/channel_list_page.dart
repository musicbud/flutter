import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbud_flutter/blocs/chat/chat_bloc.dart';
import 'package:musicbud_flutter/blocs/chat/chat_event.dart';
import 'package:musicbud_flutter/blocs/chat/chat_state.dart';
import 'package:musicbud_flutter/presentation/pages/create_channel_page.dart';
import 'package:musicbud_flutter/presentation/pages/channel_chat_page.dart';

class ChannelListPage extends StatefulWidget {
  final String currentUsername;

  const ChannelListPage({
    Key? key,
    required this.currentUsername,
  }) : super(key: key);

  @override
  ChannelListPageState createState() => ChannelListPageState();
}

class ChannelListPageState extends State<ChannelListPage> {
  @override
  void initState() {
    super.initState();
    _fetchChannels();
  }

  void _fetchChannels() {
    context.read<ChatBloc>().add(ChatChannelListRequested());
  }

  void _joinChannel(String channelId) {
    context.read<ChatBloc>().add(ChatChannelJoined(channelId));
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
        if (state is ChatChannelJoinedSuccess) {
          _showSnackBar('Successfully joined channel');
          _fetchChannels(); // Refresh the channel list
        } else if (state is ChatError) {
          _showSnackBar('Error: ${state.message}');
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Channel List')),
          body: _buildBody(state),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateChannelPage(),
                ),
              );
              if (result == true) {
                _fetchChannels(); // Refresh the channel list after creating a new channel
              }
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildBody(ChatState state) {
    if (state is ChatLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ChatChannelListLoaded) {
      if (state.channels.isEmpty) {
        return const Center(child: Text('No channels available'));
      }

      return ListView.builder(
        itemCount: state.channels.length,
        itemBuilder: (context, index) {
          final channel = state.channels[index];
          return ListTile(
            title: Text(channel.name),
            subtitle: Text('ID: ${channel.id}'),
            trailing: TextButton(
              onPressed: () => _joinChannel(channel.id),
              child: const Text('Join'),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChannelChatPage(
                    channelId: channel.id,
                    channelName: channel.name,
                    currentUsername: widget.currentUsername,
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

    return const Center(child: Text('No channels available'));
  }
}
