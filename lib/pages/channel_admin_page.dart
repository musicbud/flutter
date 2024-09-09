import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/chat_service.dart';

class ChannelAdminPage extends StatefulWidget {
  final ChatService chatService;
  final int channelId;

  const ChannelAdminPage({Key? key, required this.chatService, required this.channelId}) : super(key: key);

  @override
  _ChannelAdminPageState createState() => _ChannelAdminPageState();
}

class _ChannelAdminPageState extends State<ChannelAdminPage> {
  Map<String, dynamic> channelData = {};
  bool isLoading = true;
  final TextEditingController _addMemberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchChannelUsers();
  }

  Future<void> _fetchChannelUsers() async {
    try {
      final data = await widget.chatService.getChannelUsers(widget.channelId);
      setState(() {
        channelData = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching channel users: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _removeAdmin(int userId) async {
    try {
      final response = await widget.chatService.removeAdmin(widget.channelId, userId);
      if (response['status'] == 'success') {
        _fetchChannelUsers(); // Refresh the list after removing admin
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Admin removed successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${response['message']}')));
      }
    } catch (e) {
      print('Error removing admin: $e');
    }
  }

  Future<void> _addChannelMember() async {
    if (_addMemberController.text.isNotEmpty) {
      try {
        final response = await widget.chatService.addChannelMember(widget.channelId, _addMemberController.text);
        if (response['status'] == 'success') {
          _addMemberController.clear();
          _fetchChannelUsers(); // Refresh the list after adding member
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Member added successfully')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${response['message']}')));
        }
      } catch (e) {
        print('Error adding channel member: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Channel Admin Dashboard')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Channel Name: ${channelData['channel_name']}', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 16),
                  Text('Channel Admins:', style: TextStyle(fontSize: 18)),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: channelData['admins'].length,
                    itemBuilder: (context, index) {
                      final admin = channelData['admins'][index];
                      return ListTile(
                        title: Text(admin['username']),
                        trailing: IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () => _removeAdmin(admin['id']),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  Text('Add Channel Member:', style: TextStyle(fontSize: 18)),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _addMemberController,
                          decoration: InputDecoration(hintText: 'Username'),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: _addChannelMember,
                      ),
                    ],
                  ),
                  // Additional sections for moderators, blocked users, etc. can be added here
                ],
              ),
            ),
    );
  }
}
