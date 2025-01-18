import 'package:flutter/material.dart';
import 'package:musicbud_flutter/models/user_profile.dart';
import 'package:musicbud_flutter/presentation/pages/spotify_control_page.dart';
import 'package:musicbud_flutter/services/chat_service.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'package:musicbud_flutter/presentation/pages/profile_page.dart';
import 'package:musicbud_flutter/presentation/pages/chat_home_page.dart';
import 'package:musicbud_flutter/presentation/pages/connect_services_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:musicbud_flutter/presentation/pages/login_page.dart'; 

class HomePage extends StatefulWidget {
  final ChatService chatService;
  final ApiService apiService;

  const HomePage({Key? key, required this.chatService, required this.apiService}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserProfile? _userProfile;
  String? _currentUsername;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      await _loadUserProfile();
      if (_userProfile != null) {
        setState(() {
          _currentUsername = _userProfile!.username;
        });
      } else {
        throw Exception('User profile is null');
      }
    } catch (e) {
      print('Error initializing data: $e');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage(
            apiService: widget.apiService,
            chatService: widget.chatService,
          )),
        );
      });
    }
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await widget.apiService.getUserProfile();
      setState(() {
        _userProfile = profile;
      });
    } catch (e) {
      print('Error loading user profile: $e');
      rethrow;
    }
  }

  Future<void> _loadUsername() async {
    final username = await getUsername();
    setState(() {
      _currentUsername = username;
    });
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MusicBud'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
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
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Go to Chat'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatHomePage(
                      chatService: widget.chatService,
                      currentUsername: _currentUsername ?? '',
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Spotify Control'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SpotifyControlPage(apiService: widget.apiService),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Connect Services'),
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