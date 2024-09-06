import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'package:musicbud_flutter/models/common_track.dart';
import 'package:musicbud_flutter/models/common_artist.dart';
import 'package:musicbud_flutter/models/common_genre.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  bool _isLoggedIn = false;
  List<CommonTrack> _topTracks = [];
  List<CommonArtist> _topArtists = [];
  List<String> _topGenres = []; // Change this to List<String>
  List<CommonTrack> _playedTracks = [];

  @override
  void initState() {
    super.initState();
    print('HomePage initState called');
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    print('Checking login status');
    final isLoggedIn = await ApiService().isLoggedIn();
    print('Is logged in: $isLoggedIn');
    
    if (mounted) {
      setState(() {
        _isLoggedIn = isLoggedIn;
        _isLoading = false;
      });
      
      if (isLoggedIn) {
        try {
          await ApiService().getUserProfile();
        } catch (e) {
          print('Error loading user profile: $e');
          // You might want to show an error message to the user here
        }
      } else {
        print('Not logged in, navigating to login page');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacementNamed('/login');
        });
      }
    }
  }

  Future<void> _loadData() async {
    try {
      final topTracks = await ApiService().getTopTracks();
      final topArtists = await ApiService().getTopArtists();
      final topGenres = await ApiService().getTopGenres();
      final playedTracks = await ApiService().getPlayedTracks();

      setState(() {
        _topTracks = topTracks;
        _topArtists = topArtists;
        _topGenres = topGenres;
        _playedTracks = playedTracks;
      });
    } catch (e) {
      print('Error loading data: $e');
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('HomePage build called. isLoading: $_isLoading, isLoggedIn: $_isLoggedIn');
    
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_isLoggedIn) {
      return const Scaffold(
        body: Center(child: Text('Redirecting to login...')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.of(context).pushNamed('/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to MusicBud!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/profile'),
              child: const Text('Go to Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    await ApiService().logout();
    Navigator.of(context).pushReplacementNamed('/login');
  }
}