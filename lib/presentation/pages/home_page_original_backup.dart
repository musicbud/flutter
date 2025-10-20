import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_event.dart';
import '../../blocs/user/user_state.dart';
import '../../models/user_profile.dart';
import '../screens/buds/buds_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/connect/connect_services_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/spotify/spotify_control_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    context.read<UserBloc>().add(LoadMyProfile());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              action: SnackBarAction(
                label: 'Retry',
                onPressed: _initializeData,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is UserLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is ProfileLoaded) {
          _userProfile = state.profile;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('MusicBud'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _initializeData,
                tooltip: 'Refresh',
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              _initializeData();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome section
                  _buildWelcomeSection(context),
                  const SizedBox(height: 24),
                  
                  // Quick actions
                  _buildQuickActions(context),
                  const SizedBox(height: 24),
                  
                  // Featured services
                  _buildFeaturedServices(context),
                  const SizedBox(height: 24),
                  
                  // Recent activity placeholder
                  _buildRecentActivity(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: _userProfile?.avatarUrl != null
                  ? NetworkImage(_userProfile!.avatarUrl!)
                  : null,
              child: _userProfile?.avatarUrl == null
                  ? const Icon(Icons.person, size: 35)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back!',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _userProfile?.displayName ?? _userProfile?.username ?? 'Music Lover',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_userProfile?.bio != null && _userProfile!.bio!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      _userProfile!.bio!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            _buildQuickActionCard(
              context,
              'Find Buds',
              Icons.people_rounded,
              Colors.blue,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BudsScreen()),
              ),
            ),
            _buildQuickActionCard(
              context,
              'Chat',
              Icons.chat_bubble_rounded,
              Colors.green,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
              ),
            ),
            _buildQuickActionCard(
              context,
              'Connect Services',
              Icons.link_rounded,
              Colors.orange,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ConnectServicesScreen()),
              ),
            ),
            _buildQuickActionCard(
              context,
              'Profile',
              Icons.person_rounded,
              Colors.purple,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeaturedServices(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Featured Services',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildServiceCard(
                context,
                'Spotify Control',
                Icons.music_note,
                Colors.green[700]!,
                'Control your Spotify playback',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SpotifyControlScreen()),
                ),
              ),
              _buildServiceCard(
                context,
                'Discover Music',
                Icons.explore,
                Colors.red[700]!,
                'Find new music based on your taste',
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Music discovery coming soon!')),
                  );
                },
              ),
              _buildServiceCard(
                context,
                'Statistics',
                Icons.analytics,
                Colors.indigo[700]!,
                'View your music listening stats',
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Statistics coming soon!')),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(
                  Icons.timeline,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 12),
                Text(
                  'No recent activity yet',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Start connecting with buds and using services to see activity here',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String description,
    VoidCallback onTap,
  ) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 24,
                    color: color,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}