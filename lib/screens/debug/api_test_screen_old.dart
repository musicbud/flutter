import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_event.dart';
import '../../blocs/content/content_bloc.dart';
import '../../blocs/content/content_event.dart';
import '../../blocs/discover/discover_bloc.dart';
import '../../blocs/settings/settings_bloc.dart';
import '../../blocs/settings/settings_event.dart';

/// Debug screen for testing various API endpoints
class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({super.key});

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  final TextEditingController _usernameController = TextEditingController(text: 'testuser');
  final TextEditingController _passwordController = TextEditingController(text: 'testpass123');
  final TextEditingController _emailController = TextEditingController(text: 'test@example.com');
  final TextEditingController _searchController = TextEditingController(text: 'Beatles');

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Endpoint Testing'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'API Test Screen\n\nThis debug screen has been temporarily disabled.\nUse the main app screens to test API functionality.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
                
                // Authentication Section
                _buildSection('🔐 Authentication Endpoints', [
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testLogin(context),
                          child: const Text('Test Login'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testRegister(context),
                          child: const Text('Test Register'),
                        ),
                      ),
                    ],
                  ),
                ]),
                
                // User Profile Section
                _buildSection('👤 User Profile Endpoints', [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testUserProfile(context),
                          child: const Text('Get My Profile'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testTopItems(context),
                          child: const Text('Get Top Items'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testLikedItems(context),
                          child: const Text('Get Liked Items'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testUpdateProfile(context),
                          child: const Text('Update Profile'),
                        ),
                      ),
                    ],
                  ),
                ]),
                
                // Content & Discovery Section
                _buildSection('🎵 Content & Discovery Endpoints', [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testDiscoverContent(context),
                          child: const Text('Discover Content'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testFeaturedArtists(context),
                          child: const Text('Featured Artists'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testTrendingTracks(context),
                          child: const Text('Trending Tracks'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testNewReleases(context),
                          child: const Text('New Releases'),
                        ),
                      ),
                    ],
                  ),
                ]),
                
                // Search Section
                _buildSection('🔍 Search Endpoints', [
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search Query',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testSearch(context),
                          child: const Text('Search'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testSearchSuggestions(context),
                          child: const Text('Search Suggestions'),
                        ),
                      ),
                    ],
                  ),
                ]),
                
                // Chat Section
                _buildSection('💬 Chat Endpoints', [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testChatChannels(context),
                          child: const Text('Get Chat Channels'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testChatUsers(context),
                          child: const Text('Get Chat Users'),
                        ),
                      ),
                    ],
                  ),
                ]),
                
                // Bud Matching Section
                _buildSection('👥 Bud Matching Endpoints', [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testBudProfile(context),
                          child: const Text('Get Bud Profile'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testBudCommonItems(context),
                          child: const Text('Common Items'),
                        ),
                      ),
                    ],
                  ),
                ]),
                
                // Service Integration Section
                _buildSection('🎧 Service Integration Endpoints', [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testSpotifyConnect(context),
                          child: const Text('Spotify Connect'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testLastFMConnect(context),
                          child: const Text('Last.FM Connect'),
                        ),
                      ),
                    ],
                  ),
                ]),
                
                // Workflow Testing Section
                _buildSection('🔄 Workflow Testing', [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testAuthWorkflow(context),
                          child: const Text('Auth Workflow'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testProfileWorkflow(context),
                          child: const Text('Profile Workflow'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testDiscoverWorkflow(context),
                          child: const Text('Discover Workflow'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testChatWorkflow(context),
                          child: const Text('Chat Workflow'),
                        ),
                      ),
                    ],
                  ),
                ]),
                
                // Test All Button
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _testAllEndpoints(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          '🚀 Test All Endpoints',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _testAllWorkflows(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          '🔄 Test All Workflows',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    )
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  // Authentication endpoints
  void _testLogin(BuildContext context) {
    debugPrint('🔍 [DEBUG] Testing Login API...');
    context.read<AuthBloc>().add(LoginRequested(
      email: _emailController.text,
      password: _passwordController.text,
    ));
  }

  void _testRegister(BuildContext context) {
    debugPrint('🔍 [DEBUG] Testing Register API...');
    context.read<AuthBloc>().add(RegisterRequested(
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    ));
  }

  // User profile endpoints
  void _testUserProfile(BuildContext context) {
    debugPrint('🔍 [DEBUG] Testing User Profile API...');
    context.read<UserBloc>().add(LoadUserProfile());
  }

  void _testTopItems(BuildContext context) {
    debugPrint('🔍 [DEBUG] Testing Top Items API...');
    context.read<ContentBloc>().add(LoadTopContent());
  }

  void _testLikedItems(BuildContext context) {
    debugPrint('🔍 [DEBUG] Testing Liked Items API...');
    context.read<ContentBloc>().add(LoadLikedContent());
  }

  void _testUpdateProfile(BuildContext context) {
    debugPrint('🔍 [DEBUG] Testing Update Profile API...');
    // Create a test profile for updating
    // Since we need a UserProfile object, we'll trigger a different event or skip this test
    context.read<UserBloc>().add(LoadUserProfile()); // Load profile instead
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('📝 Loading profile (Update Profile needs existing profile data)')),
    );
  }

  // Content & Discovery endpoints
  void _testDiscoverContent(BuildContext context) {
    debugPrint('🔍 [DEBUG] Testing Discover Content API...');
    context.read<DiscoverBloc>().add(LoadDiscoverContent());
  }

  void _testFeaturedArtists(BuildContext context) {
    debugPrint('🔍 [DEBUG] Testing Featured Artists API...');
    context.read<DiscoverBloc>().add(LoadFeaturedArtists());
  }

  void _testTrendingTracks(BuildContext context) {
    debugPrint('🔍 [DEBUG] Testing Trending Tracks API...');
    context.read<DiscoverBloc>().add(LoadTrendingTracks());
  }

  void _testNewReleases(BuildContext context) {
    debugPrint('🔍 [DEBUG] Testing New Releases API...');
    context.read<DiscoverBloc>().add(LoadNewReleases());
  }

  // Search endpoints
  void _testSearch(BuildContext context) {
    debugPrint('🔍 [DEBUG] Testing Search API...');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🔍 Search functionality not available in debug mode')),
    );
  }

  void _testSearchSuggestions(BuildContext context) {
    debugPrint('🔍 [DEBUG] Testing Search Suggestions API...');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🔍 Search suggestions not available in debug mode')),
    );
  }

  // Chat endpoints
  void _testChatChannels(BuildContext context) {
    debugPrint('🔍 [DEBUG] Testing Chat Channels API...');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('💬 Chat channels not available in debug mode')),
    );
  }

  void _testChatUsers(BuildContext context) {
    debugPrint('🔍 [DEBUG] Testing Chat Users API...');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('💬 Chat users not available in debug mode')),
    );
  }

  // Bud matching endpoints
  void _testBudProfile(BuildContext context) {
    debugPrint('🔍 [DEBUG] Testing Bud Profile API...');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('👥 Bud profile not available in debug mode')),
    );
  }

  void _testBudCommonItems(BuildContext context) {
    debugPrint('🔍 [DEBUG] Testing Bud Common Items API...');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('👥 Bud common items not available in debug mode')),
    );
  }

  // Service integration endpoints
  void _testSpotifyConnect(BuildContext context) {
    debugPrint('🔍 [DEBUG] Testing Spotify Connect API...');
    context.read<SettingsBloc>().add(GetServiceLoginUrl('spotify'));
  }

  void _testLastFMConnect(BuildContext context) {
    debugPrint('🔍 [DEBUG] Testing Last.FM Connect API...');
    context.read<SettingsBloc>().add(GetServiceLoginUrl('lastfm'));
  }

  // Workflow testing methods
  void _testAuthWorkflow(BuildContext context) {
    debugPrint('🔄 [DEBUG] Testing Authentication Workflow...');
    _testLogin(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🔐 Testing authentication workflow...')),
    );
  }

  void _testProfileWorkflow(BuildContext context) {
    debugPrint('🔄 [DEBUG] Testing Profile Workflow...');
    _testUserProfile(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('👤 Testing profile workflow...')),
    );
  }

  void _testDiscoverWorkflow(BuildContext context) {
    debugPrint('🔄 [DEBUG] Testing Discover Workflow...');
    _testDiscoverContent(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🔍 Testing discover workflow...')),
    );
  }

  void _testChatWorkflow(BuildContext context) {
    debugPrint('🔄 [DEBUG] Testing Chat Workflow...');
    _testChatChannels(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('💬 Testing chat workflow...')),
    );
  }

  void _testAllWorkflows(BuildContext context) {
    debugPrint('🔄 [DEBUG] Testing ALL Workflows in sequence...');
    _testAuthWorkflow(context);
    Future.delayed(const Duration(milliseconds: 500), () => _testProfileWorkflow(context));
    Future.delayed(const Duration(milliseconds: 1000), () => _testDiscoverWorkflow(context));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🔄 Testing all workflows... Check debug logs for detailed flow analysis'),
        duration: Duration(seconds: 4),
      ),
    );
  }

  // Test all endpoints in sequence
  void _testAllEndpoints(BuildContext context) {
    debugPrint('🚀 [DEBUG] Testing ALL API endpoints in sequence...');
    
    // Test in batches with delays to avoid overwhelming the server
    Future.delayed(Duration.zero, () => _testUserProfile(context));
    Future.delayed(const Duration(milliseconds: 500), () => _testTopItems(context));
    Future.delayed(const Duration(milliseconds: 1000), () => _testLikedItems(context));
    Future.delayed(const Duration(milliseconds: 1500), () => _testDiscoverContent(context));
    Future.delayed(const Duration(milliseconds: 2000), () => _testSearch(context));
    Future.delayed(const Duration(milliseconds: 2500), () => _testChatChannels(context));
    Future.delayed(const Duration(milliseconds: 3000), () => _testBudProfile(context));
    Future.delayed(const Duration(milliseconds: 3500), () => _testSpotifyConnect(context));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🚀 Testing all endpoints... Check debug logs for API calls'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}