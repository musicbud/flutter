import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/chat_service.dart';
import 'package:musicbud_flutter/pages/create_channel_page.dart'; // Import the CreateChannelPage
import 'package:musicbud_flutter/pages/channel_chat_page.dart'; // Import the ChannelChatPage

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

  @override
  void initState() {
    super.initState();
    _fetchChannels();
  }

  Future<void> _fetchChannels() async {
    try {
      final channelList = await widget.chatService.getChannelList();
      setState(() {
        channels = channelList;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching channels: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load channels. Please try again.')),
      );
    }
  }

  Future<void> _joinChannel(String channelId) async {
    try {
      final response = await widget.chatService.joinChannel(channelId);
      if (response['status'] == 'success') {
        _fetchChannels();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response['message']}')),
        );
      }
    } catch (e) {
      print('Error joining channel: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Channel List')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : channels.isEmpty
              ? Center(child: Text('No channels available'))
              : ListView.builder(
                  itemCount: channels.length,
                  itemBuilder: (context, index) {
                    final channel = channels[index];
                    return ListTile(
                      title: Text(channel['name'] ?? 'Unnamed Channel'),
                      subtitle: Text('ID: ${channel['id']}'),
                      trailing: channel['is_member'] == true
                          ? Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChannelChatPage(
                              chatService: widget.chatService,
                              channelId: channel['id'] as int, // Make sure this is an int
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
              builder: (context) => CreateChannelPage(chatService: widget.chatService),
            ),
          );
          if (result == true) {
            _fetchChannels(); // Refresh the channel list after creating a new channel
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
