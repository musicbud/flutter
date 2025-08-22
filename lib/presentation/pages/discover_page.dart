import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/bud_matching/bud_matching_bloc.dart';
import '../constants/app_theme.dart';
import '../widgets/common/index.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Pop',
    'Rock',
    'Hip Hop',
    'Electronic',
    'Jazz',
    'Classical',
    'Country',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Load initial bud data when page initializes
    context.read<BudMatchingBloc>().add(SearchBuds(query: '', filters: null));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _searchBuds(String query) {
    Map<String, dynamic>? filters;
    if (_selectedCategory != 'All') {
      filters = {'genre': _selectedCategory.toLowerCase()};
    }
    context.read<BudMatchingBloc>().add(SearchBuds(query: query, filters: filters));
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return BlocListener<BudMatchingBloc, BudMatchingState>(
      listener: (context, state) {
        if (state is BudMatchingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: appTheme.colors.errorRed,
            ),
          );
        }
      },
      child: BlocBuilder<BudMatchingBloc, BudMatchingState>(
        builder: (context, state) {
            return Scaffold(
              backgroundColor: appTheme.colors.background,
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                backgroundColor: appTheme.colors.primaryRed,
                child: Icon(
                  Icons.menu,
                  color: appTheme.colors.pureWhite,
                  size: 28,
                ),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
              body: SafeArea(
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: EdgeInsets.all(appTheme.spacing.lg),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.menu,
                              color: appTheme.colors.primaryRed,
                              size: 32,
                            ),
                            onPressed: () {
                              // Open the main navigation drawer
                              Scaffold.of(context).openDrawer();
                            },
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Discover',
                                  style: appTheme.typography.displayH1.copyWith(
                                    color: appTheme.colors.textPrimary,
                                    fontSize: 32,
                                  ),
                                ),
                                SizedBox(height: appTheme.spacing.sm),
                                Text(
                                  'Find your music soulmates',
                                  style: appTheme.typography.bodyMedium.copyWith(
                                    color: appTheme.colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Search Bar
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                      child: AppInputField(
                        controller: _searchController,
                        labelText: 'Search buds',
                        hintText: 'Search by username, interests, or music taste...',
                        variant: AppInputVariant.search,
                        onChanged: _searchBuds,
                        suffixIcon: Icon(
                          Icons.search,
                          color: appTheme.colors.textSecondary,
                        ),
                      ),
                    ),

                    SizedBox(height: appTheme.spacing.md),

                    // Category Filter
                    Container(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final isSelected = _selectedCategory == category;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = category;
                              });
                              _searchBuds(_searchController.text);
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: appTheme.spacing.sm),
                              padding: EdgeInsets.symmetric(
                                horizontal: appTheme.spacing.md,
                                vertical: appTheme.spacing.sm,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? appTheme.colors.primaryRed
                                    : appTheme.colors.neutralGray.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(appTheme.radius.lg),
                                border: Border.all(
                                  color: isSelected
                                      ? appTheme.colors.primaryRed
                                      : appTheme.colors.neutralGray.withOpacity(0.3),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  category,
                                  style: appTheme.typography.bodyMedium.copyWith(
                                    color: isSelected
                                        ? appTheme.colors.pureWhite
                                        : appTheme.colors.textSecondary,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: appTheme.spacing.lg),

                    // Content Tabs
                    Expanded(
                      child: Column(
                        children: [
                          // Tab Bar
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                            decoration: BoxDecoration(
                              color: appTheme.colors.neutralGray.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(appTheme.radius.lg),
                            ),
                            child: TabBar(
                              controller: _tabController,
                              indicator: BoxDecoration(
                                color: appTheme.colors.primaryRed,
                                borderRadius: BorderRadius.circular(appTheme.radius.lg),
                              ),
                              labelColor: appTheme.colors.pureWhite,
                              unselectedLabelColor: appTheme.colors.textSecondary,
                              tabs: [
                                Tab(text: 'Buds'),
                                Tab(text: 'Artists'),
                                Tab(text: 'Tracks'),
                              ],
                            ),
                          ),

                          SizedBox(height: appTheme.spacing.md),

                          // Tab Content
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _buildBudsTab(context, state),
                                _buildArtistsTab(context, state),
                                _buildTracksTab(context, state),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
    );
  }

  Widget _buildBudsTab(BuildContext context, BudMatchingState state) {
    final appTheme = AppTheme.of(context);

    if (state is BudMatchingLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: appTheme.colors.primaryRed,
        ),
      );
    }

    if (state is BudsSearchResults) {
      if (state.buds.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: appTheme.colors.textSecondary,
              ),
              SizedBox(height: appTheme.spacing.md),
              Text(
                'No buds found',
                style: appTheme.typography.titleMedium.copyWith(
                  color: appTheme.colors.textPrimary,
                ),
              ),
              SizedBox(height: appTheme.spacing.sm),
              Text(
                'Try adjusting your search or filters',
                style: appTheme.typography.bodyMedium.copyWith(
                  color: appTheme.colors.textSecondary,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
        itemCount: state.buds.length,
        itemBuilder: (context, index) {
          final bud = state.buds[index];
          return _buildBudCard(context, bud, appTheme);
        },
      );
    }

    return Center(
      child: Text(
        'Search for buds to get started',
        style: appTheme.typography.bodyMedium.copyWith(
          color: appTheme.colors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildArtistsTab(BuildContext context, BudMatchingState state) {
    final appTheme = AppTheme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.music_note,
            size: 64,
            color: appTheme.colors.textSecondary,
          ),
          SizedBox(height: appTheme.spacing.md),
          Text(
            'Artists Tab',
            style: appTheme.typography.titleMedium.copyWith(
              color: appTheme.colors.textPrimary,
            ),
          ),
          SizedBox(height: appTheme.spacing.sm),
          Text(
            'Coming soon - Browse artists',
            style: appTheme.typography.bodyMedium.copyWith(
              color: appTheme.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTracksTab(BuildContext context, BudMatchingState state) {
    final appTheme = AppTheme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.playlist_play,
            size: 64,
            color: appTheme.colors.textSecondary,
          ),
          SizedBox(height: appTheme.spacing.md),
          Text(
            'Tracks Tab',
            style: appTheme.typography.titleMedium.copyWith(
              color: appTheme.colors.textPrimary,
            ),
          ),
          SizedBox(height: appTheme.spacing.sm),
          Text(
            'Coming soon - Browse tracks',
            style: appTheme.typography.bodyMedium.copyWith(
              color: appTheme.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudCard(BuildContext context, dynamic bud, AppTheme appTheme) {
    return AppCard(
      variant: AppCardVariant.profile,
      margin: EdgeInsets.only(bottom: appTheme.spacing.md),
      child: Padding(
        padding: EdgeInsets.all(appTheme.spacing.md),
        child: Row(
          children: [
            // Profile Image
            CircleAvatar(
              radius: 30,
              backgroundColor: appTheme.colors.primaryRed,
              backgroundImage: bud['profile_picture'] != null
                  ? NetworkImage(bud['profile_picture'])
                  : null,
              child: bud['profile_picture'] == null
                  ? Icon(
                      Icons.person,
                      color: appTheme.colors.pureWhite,
                      size: 30,
                    )
                  : null,
            ),

            SizedBox(width: appTheme.spacing.md),

            // Bud Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bud['username'] ?? 'Unknown User',
                    style: appTheme.typography.titleMedium.copyWith(
                      color: appTheme.colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (bud['first_name'] != null || bud['last_name'] != null)
                    Text(
                      '${bud['first_name'] ?? ''} ${bud['last_name'] ?? ''}'.trim(),
                      style: appTheme.typography.bodyMedium.copyWith(
                        color: appTheme.colors.textSecondary,
                      ),
                    ),
                  if (bud['bio'] != null)
                    Text(
                      bud['bio'],
                      style: appTheme.typography.bodySmall.copyWith(
                        color: appTheme.colors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),

            // Action Button
            AppButton(
              onPressed: () {
                // Navigate to bud profile or start chat
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Viewing ${bud['username']}\'s profile'),
                    backgroundColor: appTheme.colors.infoBlue,
                  ),
                );
              },
              text: 'View',
              variant: AppButtonVariant.primary,
              size: AppButtonSize.small,
            ),
          ],
        ),
      ),
    );
  }
}