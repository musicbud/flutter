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
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    if (widget.currentUsername.isEmpty) {
      setState(() {
        _error = 'Current user not found. Please log in again.';
        _isLoading = false;
      });
      return;
    }

    try {
      final users = await widget.chatService.getUsers();
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching users: $e');
      setState(() {
        _error = 'Failed to load users. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _users.isEmpty
                  ? const Center(child: Text('No users available'))
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
                                  currentUsername: widget.currentUsername,
                                  otherUsername: user['username'],
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
