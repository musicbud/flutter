import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/chat_service.dart';
import 'package:musicbud_flutter/presentation/pages/create_channel_page.dart'; // Import the CreateChannelPage
import 'package:musicbud_flutter/presentation/pages/channel_chat_page.dart'; // Import the ChannelChatPage

class ChannelListPage extends StatefulWidget {
  final ChatService chatService;
  final String currentUsername;

  const ChannelListPage({
    Key? key,
    required this.chatService,
    required this.currentUsername,
  }) : super(key: key);

  @override
  _ChannelListPageState createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  List<Map<String, dynamic>> channels = []; // Make channels a mutable list
  bool isLoading = true;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchChannels();
  }

  Future<void> _fetchChannels() async {
    try {
      final channelList = await widget.chatService.getChannelList();
      if (!mounted) return;
      setState(() {
        channels = channelList;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching channels: $e');
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      _showSnackBar('Failed to load channels. Please try again.');
    }
  }

  Future<void> _joinChannel(String channelId) async {
    try {
      final response = await widget.chatService.joinChannel(channelId);
      if (!mounted) return;

      if (response['status'] == 'success') {
        await _fetchChannels();
        if (!mounted) return;
        _showSnackBar(response['message']);
      } else {
        _showSnackBar('Error: ${response['message']}');
      }
    } catch (e) {
      print('Error joining channel: $e');
      if (!mounted) return;
      _showSnackBar('An error occurred. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Channel List')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : channels.isEmpty
              ? const Center(child: Text('No channels available'))
              : ListView.builder(
                  itemCount: channels.length,
                  itemBuilder: (context, index) {
                    final channel = channels[index];
                    return ListTile(
                      title: Text(channel['name'] ?? 'Unnamed Channel'),
                      subtitle: Text('ID: ${channel['id']}'),
                      trailing: channel['is_member'] == true
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChannelChatPage(
                              chatService: widget.chatService,
                              channelId: channel['id']
                                  as int, // Make sure this is an int
                              channelName: channel['name'] as String,
                              currentUsername: widget.currentUsername,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CreateChannelPage(chatService: widget.chatService),
            ),
          );
          if (result == true) {
            _fetchChannels(); // Refresh the channel list after creating a new channel
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
