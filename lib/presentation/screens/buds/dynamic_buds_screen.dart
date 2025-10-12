import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/components/musicbud_components.dart';
import '../../../core/theme/design_system.dart';
import '../../../services/dynamic_config_service.dart';
import '../../../services/dynamic_theme_service.dart';
import '../../../services/dynamic_navigation_service.dart';
import '../../../blocs/bud/bud_bloc.dart';
import '../../../blocs/bud/bud_event.dart';
import '../../../blocs/bud/bud_state.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../../blocs/user/user_state.dart';

/// Enhanced Buds/Matching screen using MusicBud Components Library
/// Features improved design, error handling, and navigation integration
class DynamicBudsScreen extends StatefulWidget {
  const DynamicBudsScreen({super.key});

  @override
  State<DynamicBudsScreen> createState() => _DynamicBudsScreenState();
}

class _DynamicBudsScreenState extends State<DynamicBudsScreen>
    with TickerProviderStateMixin {
  final DynamicConfigService _config = DynamicConfigService.instance;
  final DynamicThemeService _theme = DynamicThemeService.instance;
  final DynamicNavigationService _navigation = DynamicNavigationService.instance;

  late TabController _tabController;
  String _selectedMatchingType = 'topArtists';
  bool _isLoading = false;
  bool _hasTriggeredInitialLoad = false;
  List<Map<String, dynamic>> _buds = [];
  List<Map<String, dynamic>> _mockBuds = [];
  bool _useOfflineMode = false;

  @override
  void initState() {
    super.initState();
    _initializeMockData();
    final tabs = _getAvailableTabs();
    _tabController = TabController(
      length: tabs.length,
      vsync: this,
    );
    _triggerInitialDataLoad();
  }
  
  void _initializeMockData() {
    _mockBuds = _generateMockBuds();
  }
  
  List<Map<String, dynamic>> _generateMockBuds() {
    final Random random = Random();
    final names = ['Alex', 'Jordan', 'Taylor', 'Casey', 'Morgan', 'Riley', 'Drew', 'Blake', 'Sage', 'Quinn'];
    final buds = <Map<String, dynamic>>[];
    
    for (int i = 0; i < 20; i++) {
      buds.add({
        'id': 'bud_${random.nextInt(100000)}',
        'name': '${names[random.nextInt(names.length)]} ${String.fromCharCode(65 + random.nextInt(26))}.',
        'matchPercentage': 60 + random.nextInt(40), // 60-99%
        'commonArtists': random.nextInt(10) + 5,
        'commonTracks': random.nextInt(25) + 10,
        'commonGenres': random.nextInt(5) + 2,
        'location': random.nextBool() ? 'New York' : 'Los Angeles',
        'isOnline': random.nextBool(),
        'lastSeen': DateTime.now().subtract(Duration(hours: random.nextInt(24))),
        'bio': 'Music lover and ${['rock', 'pop', 'jazz', 'electronic', 'indie'][random.nextInt(5)]} enthusiast',
        'profileImage': 'https://picsum.photos/80/80?random=${random.nextInt(1000)}',
        'verified': random.nextBool() && random.nextDouble() > 0.7,
      });
    }
    
    return buds;
  }
  
  void _triggerInitialDataLoad() {
    if (!_hasTriggeredInitialLoad) {
      _hasTriggeredInitialLoad = true;
      _loadBudsFromBloc();
    }
  }

  void _loadBudsFromBloc() {
    try {
      // Use the comprehensive version defined later in the class
      _loadBudsBasedOnSelection();
    } catch (e) {
      debugPrint('Error loading buds: $e');
      _enableOfflineMode();
    }
  }

  List<Map<String, dynamic>> _getAvailableTabs() {
    if (!_config.isFeatureEnabled('bud_matching')) {
      return [];
    }
    return [
      {'title': 'Top Artists', 'type': 'topArtists'},
      {'title': 'Top Tracks', 'type': 'topTracks'},
      {'title': 'Genres', 'type': 'topGenres'},
    ];
  }

  List<Map<String, dynamic>> _extractBudsFromState(BudState state) {
    // Extract buds from various state types and convert to Map format
    List<dynamic> buds = [];
    
    if (state is BudsByTopTracksLoaded) {
      buds = state.buds;
    } else if (state is BudsByTopGenresLoaded) {
      buds = state.buds;
    } else if (state is BudsByLikedArtistsLoaded) {
      buds = state.buds;
    } else if (state is BudsByLikedTracksLoaded) {
      buds = state.buds;
    }
    
    if (buds.isEmpty) {
      return _mockBuds; // Fallback to mock data for now
    }
    
    return buds.map((bud) => {
      'id': bud.id ?? 'unknown',
      'name': bud.displayName ?? bud.username ?? 'Unknown User',
      'matchPercentage': 75 + (bud.id.hashCode % 25).abs(),
      'commonArtists': (bud.id.hashCode % 10).abs() + 5,
      'commonTracks': (bud.id.hashCode % 25).abs() + 10,
      'commonGenres': (bud.id.hashCode % 5).abs() + 2,
      'location': 'Unknown',
      'isOnline': (bud.id.hashCode % 2) == 0,
      'lastSeen': DateTime.now().subtract(Duration(hours: (bud.id.hashCode % 24).abs())),
      'bio': bud.bio ?? 'Music enthusiast',
      'profileImage': bud.profileImageUrl,
      'verified': false,
    }).toList();
  }

  void _loadBuds() {
    setState(() => _isLoading = true);
    _loadBudsFromBloc();
  }
  
  void _enableOfflineMode() {
    setState(() {
      _useOfflineMode = true;
      _buds = _mockBuds;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Trigger initial data load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerInitialDataLoad();
    });

    final tabs = _getAvailableTabs();

    return MultiBlocListener(
      listeners: [
        // BudBloc listener for bud matching results
        BlocListener<BudBloc, BudState>(
          listener: (context, state) {
            if (state is BudLoading) {
              setState(() => _isLoading = true);
            } else if (state is BudsByTopArtistsLoaded) {
              setState(() {
                _isLoading = false;
                _buds = state.buds.map((bud) => {
                  'id': bud.id,
                  'name': bud.displayName ?? bud.username,
                  'matchPercentage': 85, // Mock percentage
                  'commonArtists': 8,
                  'commonTracks': 15,
                  'commonGenres': 3,
                  'location': 'Unknown',
                  'isOnline': true,
                  'lastSeen': DateTime.now(),
                  'bio': bud.bio ?? 'Music enthusiast',
                  'profileImage': bud.profileImageUrl,
                  'verified': false,
                }).toList();
              });
            } else if (state is BudsByTopTracksLoaded ||
                       state is BudsByTopGenresLoaded ||
                       state is BudsByLikedArtistsLoaded ||
                       state is BudsByLikedTracksLoaded) {
              setState(() {
                _isLoading = false;
                // Handle other state types similarly
                _buds = _extractBudsFromState(state);
              });
            } else if (state is BudError && !_useOfflineMode) {
              setState(() => _isLoading = false);
              Future.delayed(const Duration(seconds: 1), () {
                if (mounted && !_useOfflineMode) {
                  _enableOfflineMode();
                }
              });
            }
          },
        ),
        // User BLoC listener for user-related errors
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('User Error: ${state.message}'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: DesignSystem.background,
        appBar: _buildAppBar(tabs),
        body: BlocBuilder<BudBloc, BudState>(
          builder: (context, state) {
            return _buildBody();
          },
        ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  Widget _buildBody() {
    if (!_config.isFeatureEnabled('bud_matching')) {
      return _buildFeatureDisabledState();
    }

    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: _theme.getDynamicSpacing(16)),
            Text(
              'Finding your perfect music buds...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: _theme.getDynamicFontSize(14),
              ),
            ),
          ],
        ),
      );
    }

    if (_buds.isEmpty && !_useOfflineMode) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _refreshBuds,
      child: Column(
        children: [
          if (_useOfflineMode) _buildOfflineBanner(),
          _buildMatchingTypeSelector(),
          Expanded(child: _buildBudsList()),
        ],
      ),
    );
  }

  Widget _buildFeatureDisabledState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: _theme.getDynamicFontSize(64),
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(height: _theme.getDynamicSpacing(16)),
          Text(
            'Bud Matching Disabled',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: _theme.getDynamicFontSize(20),
            ),
          ),
          SizedBox(height: _theme.getDynamicSpacing(8)),
          Text(
            'Enable bud matching in settings to find music buddies',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: _theme.getDynamicFontSize(14),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: _theme.getDynamicSpacing(24)),
          ElevatedButton(
            onPressed: () => _navigation.navigateTo('/settings'),
            child: const Text('Enable Feature'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: _theme.getDynamicFontSize(64),
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(height: _theme.getDynamicSpacing(16)),
          Text(
            'No Buds Found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: _theme.getDynamicFontSize(20),
            ),
          ),
          SizedBox(height: _theme.getDynamicSpacing(8)),
          Text(
            'Try adjusting your preferences or check back later',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: _theme.getDynamicFontSize(14),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: _theme.getDynamicSpacing(24)),
          ElevatedButton(
            onPressed: _loadBudsFromBloc,
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildBudsList() {
    return ListView.builder(
      padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
      itemCount: _buds.length,
      itemBuilder: (context, index) {
        return _buildBudCard(_buds[index], index);
      },
    );
  }

  Widget _buildBudCard(Map<String, dynamic> bud, int index) {
    final matchPercentage = bud['matchPercentage'] ?? 85;
    return Container(
      margin: const EdgeInsets.only(bottom: DesignSystem.spacingMD),
      padding: const EdgeInsets.all(DesignSystem.spacingMD),
      decoration: BoxDecoration(
        color: DesignSystem.surfaceContainer,
        borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
        boxShadow: DesignSystem.shadowCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with avatar, name, and match badge
          Row(
            children: [
              MusicBudAvatar(
                imageUrl: bud['profileImage'],
                size: 60,
                hasBorder: true,
                borderColor: _getMatchColor(matchPercentage),
                onTap: () => _viewBudProfile(bud, index),
              ),
              const SizedBox(width: DesignSystem.spacingMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            bud['name'] ?? 'Music Bud ${index + 1}',
                            style: DesignSystem.titleMedium.copyWith(
                              color: DesignSystem.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (bud['verified'] == true)
                          const Icon(
                            Icons.verified,
                            size: 16,
                            color: DesignSystem.successGreen,
                          ),
                      ],
                    ),
                    const SizedBox(height: DesignSystem.spacingXXS),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: bud['isOnline'] == true
                                ? DesignSystem.successGreen
                                : DesignSystem.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: DesignSystem.spacingXS),
                        Text(
                          bud['isOnline'] == true ? 'Online' : 'Last seen ${_formatLastSeen(bud['lastSeen'])}',
                          style: DesignSystem.bodySmall.copyWith(
                            color: DesignSystem.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _buildMatchBadge(matchPercentage),
            ],
          ),
          
          // Bio (if available)
          if (bud['bio'] != null && bud['bio'].toString().isNotEmpty) ...[
            const SizedBox(height: DesignSystem.spacingSM),
            Text(
              bud['bio'],
              style: DesignSystem.bodySmall.copyWith(
                color: DesignSystem.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          
          const SizedBox(height: DesignSystem.spacingMD),
          _buildMatchingInfo(bud),
          const SizedBox(height: DesignSystem.spacingMD),
          _buildActionButtons(bud, index),
        ],
      ),
    );
  }

  Widget _buildMatchBadge(int percentage) {
    final color = _getMatchColor(percentage);
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.spacingSM,
        vertical: DesignSystem.spacingXXS,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(DesignSystem.radiusFull),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Text(
        '$percentage%',
        style: DesignSystem.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getMatchColor(int percentage) {
    if (percentage >= 80) {
      return DesignSystem.successGreen;
    } else if (percentage >= 60) {
      return DesignSystem.warningOrange;
    } else {
      return DesignSystem.errorRed;
    }
  }

  Widget _buildMatchingInfo(Map<String, dynamic> bud) {
    final matchingTypes = _getMatchingTypesForCurrentSelection();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Matching Preferences:',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: _theme.getDynamicFontSize(14),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: _theme.getDynamicSpacing(8)),
        Wrap(
          spacing: _theme.getDynamicSpacing(8),
          runSpacing: _theme.getDynamicSpacing(4),
          children: matchingTypes.map((type) {
            return _buildMatchingChip(type, bud);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMatchingChip(String type, Map<String, dynamic> bud) {
    final count = bud['${type}Count'] ?? (type.hashCode % 10) + 1;
    return Chip(
      label: Text(
        '${type.replaceAll(RegExp(r'([A-Z])'), ' \$1').trim()}: $count',
        style: TextStyle(fontSize: _theme.getDynamicFontSize(12)),
      ),
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
      labelStyle: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: _theme.getDynamicFontSize(11),
      ),
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> bud, int index) {
    return Row(
      children: [
        Expanded(
          child: MusicBudButton(
            text: 'Connect',
            onPressed: () => _sendBudRequest(bud, index),
            isOutlined: true,
            icon: Icons.person_add,
            backgroundColor: DesignSystem.pinkAccent,
          ),
        ),
        const SizedBox(width: DesignSystem.spacingSM),
        Expanded(
          child: MusicBudButton(
            text: 'View Profile',
            onPressed: () => _viewBudProfile(bud, index),
            icon: Icons.person,
            backgroundColor: DesignSystem.pinkAccent,
          ),
        ),
      ],
    );
  }

  Widget? _buildFloatingActionButton() {
    if (!_config.isFeatureEnabled('bud_matching')) {
      return null;
    }

    return FloatingActionButton.extended(
      heroTag: "buds_find_more_fab",
      onPressed: _showMatchingOptions,
      icon: const Icon(Icons.search),
      label: const Text('Find More'),
    );
  }


  List<String> _getMatchingTypesForCurrentSelection() {
    switch (_selectedMatchingType) {
      case 'topArtists':
        return ['artists', 'genres'];
      case 'topTracks':
        return ['tracks', 'artists'];
      case 'topGenres':
        return ['genres', 'artists'];
      case 'likedArtists':
        return ['artists', 'albums'];
      case 'likedTracks':
        return ['tracks', 'playlists'];
      default:
        return ['artists', 'tracks', 'genres'];
    }
  }

  Future<void> _refreshBuds() async {
    if (_useOfflineMode) {
      setState(() {
        _buds = _mockBuds;
      });
      return;
    }
    _loadBudsBasedOnSelection();
  }

  void _loadBudsBasedOnSelection() {
    switch (_selectedMatchingType) {
      case 'topArtists':
        context.read<BudBloc>().add(BudsByTopArtistsRequested());
        break;
      case 'topTracks':
        context.read<BudBloc>().add(BudsByTopTracksRequested());
        break;
      case 'topGenres':
        context.read<BudBloc>().add(BudsByTopGenresRequested());
        break;
      case 'likedArtists':
        context.read<BudBloc>().add(BudsByLikedArtistsRequested());
        break;
      case 'likedTracks':
        context.read<BudBloc>().add(BudsByLikedTracksRequested());
        break;
      case 'likedGenres':
        context.read<BudBloc>().add(BudsByLikedGenresRequested());
        break;
      default:
        context.read<BudBloc>().add(BudsByTopArtistsRequested());
    }
  }


  Widget _buildOfflineBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(_theme.getDynamicSpacing(12)),
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
      child: Row(
        children: [
          Icon(
            Icons.wifi_off,
            color: Theme.of(context).colorScheme.secondary,
            size: _theme.getDynamicFontSize(20),
          ),
          SizedBox(width: _theme.getDynamicSpacing(8)),
          Text(
            'Offline mode - showing preview data',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: _theme.getDynamicFontSize(12),
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchingTypeSelector() {
    final matchingTypes = [
      {'key': 'topArtists', 'label': 'Top Artists'},
      {'key': 'topTracks', 'label': 'Top Tracks'},
      {'key': 'topGenres', 'label': 'Top Genres'},
      {'key': 'likedArtists', 'label': 'Liked Artists'},
      {'key': 'likedTracks', 'label': 'Liked Tracks'},
      {'key': 'likedGenres', 'label': 'Liked Genres'},
    ];

    return Container(
      padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: matchingTypes.map((type) {
            final isSelected = _selectedMatchingType == type['key'];
            return Padding(
              padding: EdgeInsets.only(right: _theme.getDynamicSpacing(8)),
              child: FilterChip(
                label: Text(type['label']!),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedMatchingType = type['key']!;
                    });
                    _loadBudsBasedOnSelection();
                  }
                },
                selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                checkmarkColor: Theme.of(context).primaryColor,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _sendBudRequest(Map<String, dynamic> bud, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Bud Request'),
        content: Text('Send a request to ${bud['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Request sent to ${bud['name']}')),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _viewBudProfile(Map<String, dynamic> bud, int index) {
    _navigation.navigateTo('/bud-profile', arguments: {
      'budId': bud['id'],
      'budName': bud['name'],
    });
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filter Options',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: _theme.getDynamicFontSize(20),
              ),
            ),
            SizedBox(height: _theme.getDynamicSpacing(16)),
            SwitchListTile(
              title: const Text('High Match Only'),
              subtitle: const Text('Show only 80%+ matches'),
              value: false,
              onChanged: (value) {
                // TODO: Implement filter logic
              },
            ),
            SwitchListTile(
              title: const Text('Online Now'),
              subtitle: const Text('Show only online users'),
              value: false,
              onChanged: (value) {
                // TODO: Implement filter logic
              },
            ),
            SwitchListTile(
              title: const Text('Similar Age'),
              subtitle: const Text('Show users of similar age'),
              value: false,
              onChanged: (value) {
                // TODO: Implement filter logic
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showMatchingOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Find More Buds',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: _theme.getDynamicFontSize(20),
              ),
            ),
            SizedBox(height: _theme.getDynamicSpacing(16)),
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Refresh Results'),
              subtitle: const Text('Load new potential matches'),
              onTap: () {
                Navigator.pop(context);
                _loadBudsFromBloc();
              },
            ),
            ListTile(
              leading: const Icon(Icons.tune),
              title: const Text('Adjust Preferences'),
              subtitle: const Text('Modify your matching criteria'),
              onTap: () {
                Navigator.pop(context);
                _navigation.navigateTo('/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share Profile'),
              subtitle: const Text('Let others find you'),
              onTap: () {
                Navigator.pop(context);
                _shareProfile();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _shareProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile sharing not implemented yet'),
        backgroundColor: DesignSystem.surfaceContainer,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(List<Map<String, dynamic>> tabs) {
    return AppBar(
      backgroundColor: DesignSystem.background,
      elevation: 0,
      title: Text(
        'Find Your Buds',
        style: DesignSystem.headlineMedium.copyWith(
          color: DesignSystem.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottom: tabs.length > 1 ? TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: DesignSystem.pinkAccent,
        labelColor: DesignSystem.pinkAccent,
        unselectedLabelColor: DesignSystem.onSurfaceVariant,
        tabs: tabs.map((tab) => Tab(
          text: tab['title'],
          child: Text(
            tab['title']!,
            style: DesignSystem.labelMedium,
          ),
        )).toList(),
        onTap: (index) {
          setState(() {
            _selectedMatchingType = tabs[index]['type'];
          });
          _loadBuds();
        },
      ) : null,
      actions: [
        if (_useOfflineMode)
          IconButton(
            icon: const Icon(Icons.refresh, color: DesignSystem.onSurface),
            onPressed: () {
              setState(() {
                _useOfflineMode = false;
                _hasTriggeredInitialLoad = false;
              });
              _triggerInitialDataLoad();
            },
            tooltip: 'Retry Connection',
          ),
        IconButton(
          icon: const Icon(Icons.filter_list, color: DesignSystem.onSurface),
          onPressed: _showFilterOptions,
          tooltip: 'Filter Options',
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: DesignSystem.onSurface),
          onSelected: (value) {
            switch (value) {
              case 'settings':
                _navigation.navigateTo('/settings');
                break;
              case 'help':
                _showHelpDialog();
                break;
              case 'refresh':
                _loadBuds();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'refresh',
              child: Row(
                children: [
                  Icon(Icons.refresh, size: 20, color: DesignSystem.onSurface),
                  SizedBox(width: 12),
                  Text('Refresh', style: DesignSystem.bodyMedium),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.settings, size: 20, color: DesignSystem.onSurface),
                  SizedBox(width: 12),
                  Text('Settings', style: DesignSystem.bodyMedium),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'help',
              child: Row(
                children: [
                  Icon(Icons.help_outline, size: 20, color: DesignSystem.onSurface),
                  SizedBox(width: 12),
                  Text('Help', style: DesignSystem.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How Bud Matching Works', style: DesignSystem.titleMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'We find your music buds based on:',
              style: DesignSystem.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: DesignSystem.spacingSM),
            _buildHelpItem('🎵', 'Similar music taste'),
            _buildHelpItem('🎨', 'Favorite artists and genres'),
            _buildHelpItem('📊', 'Listening habits'),
            _buildHelpItem('🌍', 'Location preferences'),
            const SizedBox(height: DesignSystem.spacingSM),
            Text(
              'Higher match percentages mean more compatibility!',
              style: DesignSystem.bodySmall.copyWith(
                color: DesignSystem.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          MusicBudButton(
            text: 'Got it',
            onPressed: () => Navigator.of(context).pop(),
            isOutlined: true,
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignSystem.spacingXS),
      child: Row(
        children: [
          Text(emoji, style: DesignSystem.bodyMedium),
          const SizedBox(width: DesignSystem.spacingSM),
          Expanded(
            child: Text(
              text,
              style: DesignSystem.bodySmall.copyWith(
                color: DesignSystem.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatLastSeen(dynamic lastSeen) {
    if (lastSeen == null) return 'recently';
    
    try {
      DateTime dateTime;
      if (lastSeen is String) {
        dateTime = DateTime.parse(lastSeen);
      } else if (lastSeen is DateTime) {
        dateTime = lastSeen;
      } else {
        return 'recently';
      }
      
      final now = DateTime.now();
      final difference = now.difference(dateTime);
      
      if (difference.inMinutes < 1) {
        return 'just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else {
        return '${difference.inDays}d ago';
      }
    } catch (e) {
      return 'recently';
    }
  }
}
