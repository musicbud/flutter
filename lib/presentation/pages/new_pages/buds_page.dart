import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/bud/bud_bloc.dart';
import '../../../blocs/bud/bud_event.dart';
import '../../../blocs/bud/bud_state.dart';
import '../../../domain/models/bud.dart';
import '../../../domain/models/bud_match.dart';
import '../../../domain/models/user_profile.dart';
import '../../constants/app_constants.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../widgets/common/app_app_bar.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

class BudsPage extends StatefulWidget {
  const BudsPage({Key? key}) : super(key: key);

  @override
  State<BudsPage> createState() => _BudsPageState();
}

class _BudsPageState extends State<BudsPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    // Load initial data
    _loadBudsData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadBudsData() {
    // Load buds, matches, and recommendations
    context.read<BudBloc>().add(BudsRequested());
    context.read<BudBloc>().add(BudMatchesRequested());
    context.read<BudBloc>().add(BudRecommendationsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppAppBar(
        title: 'Buds',
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => _showAddBudDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildTabBar(),
          Expanded(
            child: _buildTabView(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: AppTextField(
        controller: _searchController,
        labelText: 'Search buds...',
        hintText: 'Enter name, genre, or location',
        prefixIcon: const Icon(Icons.search),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
          if (value.isNotEmpty) {
            context.read<BudBloc>().add(BudSearchRequested(query: value));
          }
        },
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                  });
                  _loadBudsData();
                },
              )
            : null,
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppConstants.borderColor.withOpacity(0.3)),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppConstants.primaryColor,
          borderRadius: BorderRadius.circular(25),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppConstants.textSecondaryColor,
        tabs: const [
          Tab(text: 'My Buds'),
          Tab(text: 'Matches'),
          Tab(text: 'Discover'),
        ],
      ),
    );
  }

  Widget _buildTabView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildMyBudsTab(),
        _buildMatchesTab(),
        _buildDiscoverTab(),
      ],
    );
  }

  Widget _buildMyBudsTab() {
    return BlocBuilder<BudBloc, BudState>(
      builder: (context, state) {
        if (state is BudLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is BudsLoaded) {
          final filteredBuds = _filterBuds(state.buds);
          return _buildBudsList(filteredBuds, showActions: true);
        }

        if (state is BudFailure) {
          return _buildErrorWidget(state.error);
        }

        return const Center(child: Text('No buds found'));
      },
    );
  }

  Widget _buildMatchesTab() {
    return BlocBuilder<BudBloc, BudState>(
      builder: (context, state) {
        if (state is BudMatchesLoaded) {
          return _buildMatchesList(state.matches);
        }

        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite, size: 64, color: Colors.white54),
              SizedBox(height: 16),
              Text(
                'No matches yet',
                style: TextStyle(color: Colors.white54),
              ),
              Text(
                'Start connecting with music lovers to find matches',
                style: TextStyle(color: Colors.white38, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDiscoverTab() {
    return BlocBuilder<BudBloc, BudState>(
      builder: (context, state) {
        if (state is BudRecommendationsLoaded) {
          return _buildRecommendationsList(state.recommendations);
        }

        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.explore, size: 64, color: Colors.white54),
              SizedBox(height: 16),
              Text(
                'Discover new buds',
                style: TextStyle(color: Colors.white54),
              ),
              Text(
                'Find music lovers with similar tastes',
                style: TextStyle(color: Colors.white38, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBudsList(List<Bud> buds, {bool showActions = false}) {
    if (buds.isEmpty) {
      return const Center(
        child: Text(
          'No buds found',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: buds.length,
      itemBuilder: (context, index) {
        final bud = buds[index];
        return _buildBudCard(bud, showActions: showActions);
      },
    );
  }

  Widget _buildBudCard(Bud bud, {bool showActions = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppConstants.surfaceColor,
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: AppConstants.primaryColor.withOpacity(0.3),
          backgroundImage: bud.avatarUrl != null
              ? NetworkImage(bud.avatarUrl!)
              : null,
          child: bud.avatarUrl == null
              ? Text(
                  bud.username.isNotEmpty ? bud.username[0].toUpperCase() : 'B',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                )
              : null,
        ),
        title: Text(
          bud.username,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (bud.displayName != null)
              Text(
                bud.displayName!,
                style: const TextStyle(color: Colors.white70),
              ),
            if (bud.matchScore > 0)
              Text(
                'Match: ${(bud.matchScore * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  color: _getMatchColor(bud.matchScore),
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        trailing: showActions
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _messageBud(bud.id),
                    icon: const Icon(
                      Icons.message,
                      color: Colors.white70,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showBudProfile(bud.id),
                    icon: const Icon(
                      Icons.person,
                      color: Colors.white70,
                    ),
                  ),
                ],
              )
            : null,
        onTap: () => _showBudProfile(bud.id),
      ),
    );
  }

  Widget _buildMatchesList(List<BudMatch> matches) {
    if (matches.isEmpty) {
      return const Center(
        child: Text(
          'No matches found',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final match = matches[index];
        return _buildMatchCard(match);
      },
    );
  }

  Widget _buildMatchCard(BudMatch match) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppConstants.surfaceColor,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: AppConstants.primaryColor.withOpacity(0.3),
                  backgroundImage: match.bud.avatarUrl != null
                      ? NetworkImage(match.bud.avatarUrl!)
                      : null,
                  child: match.bud.avatarUrl == null
                      ? Text(
                          match.bud.username.isNotEmpty
                              ? match.bud.username[0].toUpperCase()
                              : 'B',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        match.bud.username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Matched ${_formatDate(match.matchedAt)}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${(match.matchScore * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (match.commonInterests.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Common interests:',
                style: TextStyle(
                  color: AppConstants.textSecondaryColor,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: match.commonInterests
                    .take(5)
                    .map((interest) => Chip(
                          label: Text(
                            interest,
                            style: const TextStyle(fontSize: 10),
                          ),
                          backgroundColor: AppConstants.primaryColor.withOpacity(0.2),
                          labelStyle: const TextStyle(color: Colors.white),
                        ))
                    .toList(),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Message',
                    onPressed: () => _messageBud(match.bud.id),
                    isOutlined: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    text: 'View Profile',
                    onPressed: () => _showBudProfile(match.bud.id),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsList(List<Bud> recommendations) {
    if (recommendations.isEmpty) {
      return const Center(
        child: Text(
          'No recommendations found',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: recommendations.length,
      itemBuilder: (context, index) {
        final bud = recommendations[index];
        return _buildRecommendationCard(bud);
      },
    );
  }

  Widget _buildRecommendationCard(Bud bud) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppConstants.surfaceColor,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppConstants.primaryColor.withOpacity(0.3),
                  backgroundImage: bud.avatarUrl != null
                      ? NetworkImage(bud.avatarUrl!)
                      : null,
                  child: bud.avatarUrl == null
                      ? Text(
                          bud.username.isNotEmpty
                              ? bud.username[0].toUpperCase()
                              : 'B',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bud.username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      if (bud.displayName != null)
                        Text(
                          bud.displayName!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: AppConstants.primaryColor,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${(bud.matchScore * 100).toStringAsFixed(0)}% match',
                            style: TextStyle(
                              color: AppConstants.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Connect',
                    onPressed: () => _connectWithBud(bud.id),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    text: 'View Profile',
                    onPressed: () => _showBudProfile(bud.id),
                    isOutlined: true,
                  ),
                ),
              ],
            ),
          ],
        ),
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
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading buds',
            style: TextStyle(
              color: AppConstants.textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(
              color: AppConstants.textSecondaryColor,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          AppButton(
            text: 'Retry',
            onPressed: _loadBudsData,
          ),
        ],
      ),
    );
  }

  // Helper methods
  List<Bud> _filterBuds(List<Bud> buds) {
    if (_searchQuery.isEmpty) return buds;

    return buds.where((bud) {
      final query = _searchQuery.toLowerCase();
      return bud.username.toLowerCase().contains(query) ||
             (bud.displayName?.toLowerCase().contains(query) ?? false) ||
             (bud.bio?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  Color _getMatchColor(double matchScore) {
    if (matchScore >= 0.8) return Colors.green;
    if (matchScore >= 0.6) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) return 'today';
    if (difference.inDays == 1) return 'yesterday';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    if (difference.inDays < 30) return '${(difference.inDays / 7).floor()} weeks ago';
    return '${(difference.inDays / 30).floor()} months ago';
  }

  // Action methods
  void _showAddBudDialog() {
    // Implement add bud dialog
  }

  void _showFilterDialog() {
    // Implement filter dialog
  }

  void _messageBud(String budId) {
    // Implement message bud logic
  }

  void _showBudProfile(String budId) {
    // Navigate to bud profile page
  }

  void _connectWithBud(String budId) {
    // Implement connect with bud logic
  }
}