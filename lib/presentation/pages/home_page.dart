import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/imported/index.dart';
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

class _HomePageState extends State<HomePage>
    with LoadingStateMixin, ErrorStateMixin, TickerProviderStateMixin {
  
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    setLoadingState(LoadingState.loading);
    context.read<UserBloc>().add(LoadMyProfile());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserError) {
          setError(
            state.message,
            type: ErrorType.network,
            retryable: true,
          );
          setLoadingState(LoadingState.error);
        } else if (state is ProfileLoaded) {
          _userProfile = state.profile;
          setLoadingState(LoadingState.loaded);
        }
      },
      builder: (context, state) {
        return AppScaffold(
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
          body: ResponsiveLayout(
            builder: (context, breakpoint) {
              switch (breakpoint) {
                case ResponsiveBreakpoint.xs:
                case ResponsiveBreakpoint.sm:
                  return _buildMobileLayout();
                case ResponsiveBreakpoint.md:
                  return _buildTabletLayout();
                case ResponsiveBreakpoint.lg:
                case ResponsiveBreakpoint.xl:
                  return _buildDesktopLayout();
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout() {
    return buildLoadingState(
      context: context,
      loadedWidget: _buildContent(),
      loadingWidget: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading your dashboard...',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      errorWidget: buildDefaultErrorWidget(
        context: context,
        onRetry: _initializeData,
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        Expanded(flex: 2, child: _buildContent()),
        Expanded(flex: 1, child: _buildSidebar()),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        SizedBox(width: 300, child: _buildSidebar()),
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _buildContent() {
    return RefreshIndicator(
      onRefresh: () async {
        _initializeData();
        await Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            _buildWelcomeSection(),
            const SizedBox(height: 24),
            
            // Quick actions
            const SectionHeader(
              title: 'Quick Actions',
              actionText: 'Customize',
            ),
            const SizedBox(height: 16),
            _buildQuickActionsGrid(),
            const SizedBox(height: 24),
            
            // Featured services
            const SectionHeader(
              title: 'Featured Services',
            ),
            const SizedBox(height: 16),
            _buildFeaturedServices(),
            const SizedBox(height: 24),
            
            // Recent activity
            const SectionHeader(title: 'Recent Activity'),
            const SizedBox(height: 16),
            _buildRecentActivity(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return ModernCard(
      variant: ModernCardVariant.elevated,
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
                  _userProfile?.displayName ?? 
                  _userProfile?.username ?? 
                  'Music Lover',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_userProfile?.bio?.isNotEmpty == true) ...[
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
    );
  }

  Widget _buildQuickActionsGrid() {
    final actions = [
      _QuickAction(
        'Find Buds',
        Icons.people_rounded,
        Colors.blue,
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BudsScreen()),
        ),
      ),
      _QuickAction(
        'Chat',
        Icons.chat_bubble_rounded,
        Colors.green,
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatScreen()),
        ),
      ),
      _QuickAction(
        'Connect Services',
        Icons.link_rounded,
        Colors.orange,
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ConnectServicesScreen()),
        ),
      ),
      _QuickAction(
        'Profile',
        Icons.person_rounded,
        Colors.purple,
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        ),
      ),
    ];

    // Use standard GridView since ContentGrid has complex API
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: actions.map((action) => _buildActionCard(action)).toList(),
    );
  }

  Widget _buildActionCard(_QuickAction action) {
    return ModernCard(
      variant: ModernCardVariant.elevated,
      onTap: action.onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: action.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                action.icon,
                size: 28,
                color: action.color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              action.title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedServices() {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildServiceCard(
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
            'Discover Music',
            Icons.explore,
            Colors.red[700]!,
            'Find new music based on your taste',
            () => _showComingSoon('Music discovery'),
          ),
          _buildServiceCard(
            'Statistics',
            Icons.analytics,
            Colors.indigo[700]!,
            'View your music listening stats',
            () => _showComingSoon('Statistics'),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    String title,
    IconData icon,
    Color color,
    String description,
    VoidCallback onTap,
  ) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      child: ModernCard(
        variant: ModernCardVariant.elevated,
        onTap: onTap,
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
                child: Icon(icon, size: 24, color: color),
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
                    const SizedBox(height: 4),
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
    );
  }

  Widget _buildRecentActivity() {
    // Using EmptyState component
    return EmptyState(
      icon: Icons.timeline,
      title: 'No recent activity yet',
      message: 'Start connecting with buds and using services to see activity here',
      actionText: 'Explore Services',
      actionCallback: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ConnectServicesScreen()),
      ),
    );
  }

  Widget _buildSidebar() {
    return ModernCard(
      variant: ModernCardVariant.outlined,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Stats',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatItem('Connected Services', '3'),
            _buildStatItem('Total Buds', '12'),
            _buildStatItem('Messages', '5'),
            const SizedBox(height: 24),
            ModernButton(
              text: 'View All Stats',
              variant: ModernButtonVariant.outline,
              onPressed: () => _showComingSoon('Statistics'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  VoidCallback? get retryLoading => _initializeData;

  @override
  VoidCallback? get onLoadingStarted => () {
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  };

  @override
  VoidCallback? get onLoadingCompleted => () {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dashboard updated!'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  };
}

class _QuickAction {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _QuickAction(this.title, this.icon, this.color, this.onTap);
}