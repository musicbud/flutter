import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:musicbud_flutter/services/chat_service.dart';
import 'package:musicbud_flutter/pages/chat_room_page.dart';
import 'package:musicbud_flutter/pages/channel_dashboard_page.dart';

class ChannelDetailsPage extends StatefulWidget {
  final int channelId;
  final Dio dio;

  const ChannelDetailsPage(
      {Key? key, required this.channelId, required this.dio})
      : super(key: key);

  @override
  _ChannelDetailsPageState createState() => _ChannelDetailsPageState();
}

class _ChannelDetailsPageState extends State<ChannelDetailsPage> {
  late ChatService chatService;
  Map<String, dynamic>? _details;
  bool _isLoading = true;
  bool _isMember = false;
  bool _isAdmin = false;
  bool _isModerator = false;

  @override
  void initState() {
    super.initState();
    chatService = ChatService(widget.dio);
    _fetchChannelDetails();
  }

  Future<void> _fetchChannelDetails() async {
    try {
      final response = await chatService.getChannelDetails(widget.channelId);
      print('Channel details response: ${response.data}'); // Debug print
      if (response.statusCode == 200) {
        setState(() {
          _details = response.data;
          _isLoading = false;
          _isMember = response.data['is_member'] ?? false;
          _isAdmin = response.data['is_admin'] ?? false;
          _isModerator = response.data['is_moderator'] ?? false;
        });
        print(
            'is_member: $_isMember, is_admin: $_isAdmin, is_moderator: $_isModerator'); // Debug print
      } else {
        setState(() {
          _isLoading = false;
        });
        print('Failed to load details: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching details: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _requestJoinChannel() async {
    try {
      final response = await chatService.requestJoinChannel(widget.channelId);
      if (!mounted) return;

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        _showSnackBar('Join request sent successfully');
        // Update UI if needed
      } else {
        _showSnackBar('Failed to send join request');
      }
    } catch (e) {
      print('Error requesting to join channel: $e');
      if (!mounted) return;
      _showSnackBar('Error sending join request');
    }
  }

  void _enterChatRoom() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ChatRoomPage(channelId: widget.channelId, dio: widget.dio),
      ),
    );
  }

  void _navigateToDashboard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChannelDashboardPage(
          channelId: widget.channelId,
          chatService: chatService,
        ),
      ),
    );
  }

  Future<void> _openDashboard() async {
    bool isAdmin = await chatService.isUserAdmin(widget.channelId);
    if (!mounted) return;

    if (isAdmin) {
      _navigateToDashboard();
    } else {
      _showSnackBar('You do not have permission to access the dashboard.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Channel Details')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _details == null
              ? const Center(child: Text('Failed to load details'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Details for Channel ${widget.channelId}',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Text('Name: ${_details!['name']}'),
                      Text('Description: ${_details!['description']}'),
                      const SizedBox(height: 16),
                      if (_isMember) ...[
                        const Text('You are a member of this channel.'),
                        if (_isAdmin)
                          const Text('You are an admin of this channel.')
                        else if (_isModerator)
                          const Text('You are a moderator of this channel.'),
                        ElevatedButton(
                          onPressed: _enterChatRoom,
                          child: const Text('Enter Chat'),
                        ),
                        if (_isAdmin)
                          ElevatedButton(
                            onPressed: _openDashboard,
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
  }
}
