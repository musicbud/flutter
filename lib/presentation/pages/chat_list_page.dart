import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbud_flutter/blocs/chat/chat_bloc.dart';
import 'package:musicbud_flutter/blocs/chat/chat_event.dart';
import 'package:musicbud_flutter/blocs/chat/chat_state.dart';
import 'package:musicbud_flutter/presentation/pages/channel_details_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({
    Key? key,
  }) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  void initState() {
    super.initState();
    _fetchChannels();
  }

  void _fetchChannels() {
    context.read<ChatBloc>().add(ChatChannelListRequested());
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
        if (state is ChatFailure) {
          _showSnackBar('Error: ${state.error}');
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Chat List')),
          body: _buildBody(state),
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
          return Card(
            child: ListTile(
              title: Text(channel.name),
              subtitle: Text(channel.description ?? 'No description'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChannelDetailsPage(
                      channelId: channel.id,
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    }

    return const Center(child: Text('Failed to load channels'));
  }
}
