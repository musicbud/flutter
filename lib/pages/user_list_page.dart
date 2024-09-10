import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/chat_service.dart';
import 'package:musicbud_flutter/pages/user_chat_page.dart'; // Import the UserChatPage

class UserListPage extends StatefulWidget {
  final ChatService chatService;
  final String currentUsername;

  const UserListPage({
    Key? key,
    required this.chatService,
    required this.currentUsername,
  }) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final Map<String, dynamic> response = await widget.chatService.getUsers();
      setState(() {
        _users = List<Map<String, dynamic>>.from(response['users'] as List);
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching users: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load users. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? Center(child: Text('No users available'))
              : ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    return ListTile(
                      title: Text(user['username'] ?? 'Unknown User'),
                      subtitle: Text('ID: ${user['id']}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserChatPage(
                              chatService: widget.chatService,
                              currentUsername: widget.currentUsername, // Make sure this is set
                              otherUsername: user['username'], // The username of the selected user
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
