import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:musicbud_flutter/services/chat_service.dart';

class ChannelDashboardPage extends StatefulWidget {
  final int channelId;
  final Dio dio;

  const ChannelDashboardPage({Key? key, required this.channelId, required this.dio}) : super(key: key);

  @override
  _ChannelDashboardPageState createState() => _ChannelDashboardPageState();
}

class _ChannelDashboardPageState extends State<ChannelDashboardPage> {
  late ChatService chatService;
  Map<String, dynamic>? _channelDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    chatService = ChatService(widget.dio);
    _fetchChannelDetails();
  }

  Future<void> _fetchChannelDetails() async {
    try {
      final response = await chatService.getChannelDetails(widget.channelId);
      if (response.statusCode == 200) {
        setState(() {
          _channelDetails = response.data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        print('Failed to load channel details: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching channel details: $e');
    }
  }

  Future<void> _performAdminAction(String action, int userId) async {
    try {
      final response = await chatService.performAdminAction(widget.channelId, action, userId);
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.data['message'])),
        );
        _fetchChannelDetails(); // Refresh the details after performing an action
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.data['message']}')),
        );
      }
    } catch (e) {
      print('Error performing admin action: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Channel Dashboard')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _channelDetails == null
              ? Center(child: Text('Failed to load channel details'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Channel: ${_channelDetails!['name']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      Text('Description: ${_channelDetails!['description']}'),
                      SizedBox(height: 16),
                      Text('Admins:'),
                      ..._channelDetails!['admins'].map<Widget>((admin) => ListTile(
                            title: Text(admin['username']),
                            trailing: IconButton(
                              icon: Icon(Icons.remove_circle),
                              onPressed: () => _performAdminAction('remove_admin', admin['id']),
                            ),
                          )),
                      SizedBox(height: 16),
                      Text('Members:'),
                      ..._channelDetails!['members'].map<Widget>((member) => ListTile(
                            title: Text(member['username']),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.person_add),
                                  onPressed: () => _performAdminAction('make_admin', member['id']),
                                ),
                                IconButton(
                                  icon: Icon(Icons.remove_circle),
                                  onPressed: () => _performAdminAction('kick', member['id']),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(height: 16),
                      Text('Moderators:'),
                      ..._channelDetails!['moderators'].map<Widget>((moderator) => ListTile(
                            title: Text(moderator['username']),
                            trailing: IconButton(
                              icon: Icon(Icons.remove_circle),
                              onPressed: () => _performAdminAction('remove_moderator', moderator['id']),
                            ),
                          )),
                      SizedBox(height: 16),
                      Text('Blocked Users:'),
                      ..._channelDetails!['blocked_users'].map<Widget>((blockedUser) => ListTile(
                            title: Text(blockedUser['username']),
                            trailing: IconButton(
                              icon: Icon(Icons.remove_circle),
                              onPressed: () => _performAdminAction('unblock', blockedUser['id']),
                            ),
                          )),
                    ],
                  ),
                ),
    );
  }
}               