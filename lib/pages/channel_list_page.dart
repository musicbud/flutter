import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/chat_service.dart';
import 'package:musicbud_flutter/pages/channel_chat_page.dart';
import 'package:musicbud_flutter/pages/create_channel_page.dart'; // Add this line

class ChannelListPage extends StatefulWidget {
  final ChatService chatService;

  const ChannelListPage({Key? key, required this.chatService}) : super(key: key);

  @override
  _ChannelListPageState createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  List<dynamic> channels = []; // Make channels a mutable list
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChannelList();
  }

  Future<void> _fetchChannelList() async {
    try {
      final channelListResponse = await widget.chatService.getChannelList();
      final List<dynamic> fetchedChannels = channelListResponse.data as List<dynamic>; // Ensure this is a List

      setState(() {
        channels.clear();
        channels.addAll(fetchedChannels); // Update the contents of the list
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching channel list: $e'); // Log the error
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _joinChannel(int channelId) async {
    try {
      final response = await widget.chatService.joinChannel(channelId.toString());
      if (response.data['status'] == 'success') {
        // Optionally refresh the channel list or show a success message
        _fetchChannelList();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.data['message'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.data['message']}')),
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
          : ListView.builder(
              itemCount: channels.length,
              itemBuilder: (context, index) {
                // Log the channel being displayed
                print('Displaying channel: ${channels[index]}'); // Log the channel data
                return ListTile(
                  title: Text(channels[index]['name']),
                  subtitle: Text('ID: ${channels[index]['id']}'),
                );
              },
            ),
    );
  }
}
