import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/chat_service.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'package:musicbud_flutter/pages/profile_page.dart'; // Import the ProfilePage
import 'package:musicbud_flutter/pages/chat_home_page.dart'; // Import the ChatHomePage
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  final ChatService chatService;
  final ApiService apiService;

  const HomePage({Key? key, required this.chatService, required this.apiService}) : super(key: key);

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(apiService: apiService),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Go to Chat'),
          onPressed: () async {
            String? username = await getUsername();
            if (username != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatHomePage(
                    chatService: chatService,
                    currentUsername: username,
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please log in first')),
              );
            }
          },
        ),
      ),
    );
  }
}