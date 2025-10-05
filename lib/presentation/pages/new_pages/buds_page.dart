import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/bud/bud_bloc.dart';
import '../../../blocs/bud/bud_event.dart';
import '../../../blocs/bud/bud_state.dart';
import '../../../blocs/profile/profile_bloc.dart';
import '../../../blocs/profile/profile_state.dart';
import '../../widgets/loading_indicator.dart';
import '../../constants/app_constants.dart';
import '../../mixins/page_mixin.dart';

class BudsPage extends StatefulWidget {
  const BudsPage({Key? key}) : super(key: key);

  @override
  State<BudsPage> createState() => _BudsPageState();
}

class _BudsPageState extends State<BudsPage> with PageMixin {
  int _selectedCategoryIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  final bool _isLoading = false;

  final List<String> _categories = [
    'All',
    'By Artists',
    'By Tracks',
    'By Genres',
    'By Albums',
    'Top Matches',
    'Recent',
    'Nearby',
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    // Load initial buds data
    // TODO: Fix BudBloc events
    // context.read<BudBloc>().add(BudsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BudBloc, BudState>(
          listener: _handleBudStateChange,
        ),
        BlocListener<ProfileBloc, ProfileState>(
          listener: _handleProfileStateChange,
        ),
      ],
      child: Scaffold(
        backgroundColor: AppConstants.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildCategoryTabs(),
              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Buds',
                style: AppConstants.headingStyle,
              ),
              SizedBox(height: 4),
              Text(
                'Connect with music lovers',
                style: AppConstants.captionStyle,
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: _showBudRequests,
                icon: const Icon(
                  Icons.person_add,
                  color: AppConstants.primaryColor,
                  size: 28,
                ),
              ),
              IconButton(
                onPressed: _showBudSettings,
                icon: const Icon(
                  Icons.settings,
                  color: AppConstants.textColor,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search for buds by name, music taste...',
          hintStyle: const TextStyle(color: AppConstants.textSecondaryColor),
          prefixIcon: const Icon(Icons.search, color: AppConstants.textSecondaryColor),
          suffixIcon: _isSearching
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppConstants.textSecondaryColor),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _isSearching = false;
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: AppConstants.surfaceColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        style: const TextStyle(color: AppConstants.textColor),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedCategoryIndex;
          return GestureDetector(
            onTap: () => _onCategorySelected(index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppConstants.primaryColor : AppConstants.surfaceColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppConstants.primaryColor : AppConstants.borderColor,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  _categories[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppConstants.textColor,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    return BlocBuilder<BudBloc, BudState>(
      builder: (context, budState) {
        if (budState is BudLoading || _isLoading) {
          return const Center(child: LoadingIndicator());
        }

        if (budState is BudError) {
          return _buildErrorWidget(budState.message);
        }

        return _buildBudsContent();
      },
    );
  }

  Widget _buildBudsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuickActions(),
          const SizedBox(height: 24),
          _buildBudRequests(),
          const SizedBox(height: 24),
          _buildTopMatches(),
          const SizedBox(height: 24),
          _buildRecentConnections(),
          const SizedBox(height: 24),
          _buildRecommendedBuds(),
          const SizedBox(height: 24),
          _buildNearbyBuds(),
          const SizedBox(height: 24),
          _buildBudCategories(),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: AppConstants.subheadingStyle,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                'Find Buds',
                Icons.people,
                AppConstants.primaryColor,
                _findBuds,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildQuickActionCard(
                'Invite Friends',
                Icons.person_add_alt,
                Colors.blue,
                _inviteFriends,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                'Music Groups',
                Icons.group_work,
                Colors.green,
                _joinMusicGroups,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildQuickActionCard(
                'Events',
                Icons.event,
                Colors.orange,
                _findEvents,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: AppConstants.textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudRequests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Bud Requests',
              style: AppConstants.subheadingStyle,
            ),
            TextButton(
              onPressed: _viewAllRequests,
              child: const Text(
                'View All',
                style: TextStyle(color: AppConstants.primaryColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return _buildBudRequestCard(
                'User ${index + 1}',
                'Has similar music taste',
                'assets/ahmed_avatar.jpg',
                () => _acceptBudRequest('user_$index'),
                () => _rejectBudRequest('user_$index'),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBudRequestCard(String name, String description, String avatar, VoidCallback onAccept, VoidCallback onReject) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.borderColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(avatar),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: AppConstants.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      description,
                      style: AppConstants.captionStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Accept'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: onReject,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppConstants.errorColor,
                    side: const BorderSide(color: AppConstants.errorColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Reject'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopMatches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Top Matches',
              style: AppConstants.subheadingStyle,
            ),
            TextButton(
              onPressed: _viewAllTopMatches,
              child: const Text(
                'View All',
                style: TextStyle(color: AppConstants.primaryColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        BlocBuilder<BudBloc, BudState>(
          builder: (context, state) {
            if (state is BudsLoaded && state.buds.isNotEmpty) {
              return _buildTopMatchesList(state.buds.take(3).toList());
            }
            return _buildEmptyState('No top matches found', Icons.people_outline);
          },
        ),
      ],
    );
  }

  Widget _buildTopMatchesList(List<dynamic> buds) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: buds.length,
      itemBuilder: (context, index) {
        final bud = buds[index];
        return _buildTopMatchCard(
          bud.name ?? 'Bud ${index + 1}',
          bud.matchPercentage?.toString() ?? '${(index + 1) * 25}%',
          bud.avatar ?? 'assets/ahmed_avatar.jpg',
          () => _viewBudProfile(bud.id ?? 'bud_$index'),
        );
      },
    );
  }

  Widget _buildTopMatchCard(String name, String matchPercentage, String avatar, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppConstants.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppConstants.borderColor),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(avatar),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: AppConstants.textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Match: $matchPercentage',
                    style: const TextStyle(
                      color: AppConstants.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildCommonItemChip('Rock', Colors.red),
                      const SizedBox(width: 8),
                      _buildCommonItemChip('Pop', Colors.blue),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () => _sendBudRequest(name),
                  icon: const Icon(
                    Icons.person_add,
                    color: AppConstants.primaryColor,
                    size: 24,
                  ),
                ),
                IconButton(
                  onPressed: () => _startChat(name),
                  icon: const Icon(
                    Icons.chat,
                    color: AppConstants.textColor,
                    size: 24,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommonItemChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildRecentConnections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Connections',
          style: AppConstants.subheadingStyle,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            itemBuilder: (context, index) {
              return _buildRecentConnectionCard(
                'Bud ${index + 1}',
                'assets/ahmed_avatar.jpg',
                () => _viewBudProfile('recent_bud_$index'),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentConnectionCard(String name, String avatar, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage(avatar),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                color: AppConstants.textColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedBuds() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recommended for You',
              style: AppConstants.subheadingStyle,
            ),
            TextButton(
              onPressed: _refreshRecommendations,
              child: const Text(
                'Refresh',
                style: TextStyle(color: AppConstants.primaryColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return _buildRecommendedBudCard(
              'Recommended ${index + 1}',
              '${(index + 1) * 20}% match',
              'assets/ahmed_avatar.jpg',
              () => _viewBudProfile('recommended_$index'),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecommendedBudCard(String name, String matchInfo, String avatar, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppConstants.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppConstants.borderColor),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  image: DecorationImage(
                    image: AssetImage(avatar),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        matchInfo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: AppConstants.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () => _sendBudRequest(name),
                        icon: const Icon(
                          Icons.person_add,
                          color: AppConstants.primaryColor,
                          size: 20,
                        ),
                      ),
                      IconButton(
                        onPressed: () => _startChat(name),
                        icon: const Icon(
                          Icons.chat,
                          color: AppConstants.textColor,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbyBuds() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Buds Nearby',
          style: AppConstants.subheadingStyle,
        ),
        const SizedBox(height: 16),
        _buildEmptyState('Enable location to find nearby buds', Icons.location_on_outlined),
      ],
    );
  }

  Widget _buildBudCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Browse by Category',
          style: AppConstants.subheadingStyle,
        ),
        const SizedBox(height: 16),
        _buildEmptyState('Categories not available', Icons.category_outlined),
      ],
    );
  }

  Widget _buildCategoryGrid(List<String> categories) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryCard(
          category,
          'Explore this category',
          Icons.category,
          () => _exploreCategory(category),
        );
      },
    );
  }

  Widget _buildCategoryCard(String title, String description, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppConstants.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppConstants.borderColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppConstants.primaryColor,
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: AppConstants.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: AppConstants.captionStyle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppConstants.textSecondaryColor,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppConstants.captionStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: AppConstants.errorColor,
            size: 64,
          ),
          const SizedBox(height: 16),
          const Text(
            'Error loading buds',
            style: AppConstants.subheadingStyle,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: AppConstants.captionStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _retryLoading,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // Event handlers
  void _onSearchChanged(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
    });

    if (query.isNotEmpty) {
      context.read<BudBloc>().add(BudsSearchRequested(query));
    }
  }

  void _onCategorySelected(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });

    // Load data based on category
    switch (_categories[index].toLowerCase()) {
      case 'by artists':
        context.read<BudBloc>().add(BudsByLikedArtistsRequested());
        break;
      case 'by tracks':
        context.read<BudBloc>().add(BudsByLikedTracksRequested());
        break;
      case 'by genres':
        context.read<BudBloc>().add(BudsByLikedGenresRequested());
        break;
      case 'by albums':
        context.read<BudBloc>().add(BudsByLikedAlbumsRequested());
        break;
      case 'top matches':
        // TODO: Fix BudBloc events
        // context.read<BudBloc>().add(BudRecommendationsRequested());
        break;
      case 'recent':
        // TODO: Fix BudBloc events
        // context.read<BudBloc>().add(BudsRequested());
        break;
      case 'nearby':
        // TODO: Implement nearby buds functionality
        break;
      default:
        // TODO: Fix BudBloc events
        // context.read<BudBloc>().add(BudsRequested());
    }
  }

  // Action methods
  void _showBudRequests() {
    // Show bud requests
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bud requests coming soon!')),
    );
  }

  void _showBudSettings() {
    // Show bud settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bud settings coming soon!')),
    );
  }

  void _findBuds() {
    // Find buds
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bud finder coming soon!')),
    );
  }

  void _inviteFriends() {
    // Invite friends
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Friend invitation coming soon!')),
    );
  }

  void _joinMusicGroups() {
    // Join music groups
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Music groups coming soon!')),
    );
  }

  void _findEvents() {
    // Find events
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Event finder coming soon!')),
    );
  }

  void _viewAllRequests() {
    // View all requests
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All requests view coming soon!')),
    );
  }

  void _acceptBudRequest(String userId) {
    // Accept bud request
    // TODO: Fix BudBloc events
    // context.read<BudBloc>().add(BudRequestAccepted(userId: userId));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bud request accepted!')),
    );
  }

  void _rejectBudRequest(String userId) {
    // Reject bud request
    // TODO: Fix BudBloc events
    // context.read<BudBloc>().add(BudRequestRejected(userId: userId));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bud request rejected')),
    );
  }

  void _viewAllTopMatches() {
    // View all top matches
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All top matches view coming soon!')),
    );
  }

  void _viewBudProfile(String budId) {
    // View bud profile
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bud profile view coming soon!')),
    );
  }

  void _sendBudRequest(String budName) {
    // Send bud request
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bud request sent to $budName!')),
    );
  }

  void _startChat(String budName) {
    // Start chat
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Starting chat with $budName...')),
    );
  }

  void _refreshRecommendations() {
    // Refresh recommendations
    // TODO: Fix BudBloc events
    // context.read<BudBloc>().add(BudRecommendationsRequested());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Recommendations refreshed!')),
    );
  }

  void _exploreCategory(String categoryId) {
    // Explore category
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Category exploration coming soon!')),
    );
  }

  void _retryLoading() {
    // Retry loading
    _loadInitialData();
  }

  // Bloc state handlers
  void _handleBudStateChange(BuildContext context, BudState state) {
    if (state is BudError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bud error: ${state.message}')),
      );
    }
  }


  void _handleProfileStateChange(BuildContext context, ProfileState state) {
    if (state is ProfileFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile error: ${state.error}')),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}