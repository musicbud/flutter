import 'package:flutter/material.dart';
import 'package:musicbud_flutter/models/user_profile.dart';
import 'package:musicbud_flutter/pages/spotify_control_page.dart';
import 'package:musicbud_flutter/services/chat_service.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'package:musicbud_flutter/pages/profile_page.dart';
import 'package:musicbud_flutter/pages/chat_home_page.dart';
import 'package:musicbud_flutter/pages/connect_services_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

class HomePage extends StatefulWidget {
  final ChatService chatService;
  final ApiService apiService;

  const HomePage({Key? key, required this.chatService, required this.apiService}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await widget.apiService.getUserProfile();
      setState(() {
        _userProfile = profile;
      });
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MusicBud'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(apiService: widget.apiService),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to MusicBud!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Go to Chat'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatHomePage(
                      chatService: widget.chatService,
                      currentUsername: _userProfile?.username ?? '',
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Spotify Control'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SpotifyControlPage(apiService: widget.apiService),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Connect Services'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConnectServicesPage(apiService: widget.apiService),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}