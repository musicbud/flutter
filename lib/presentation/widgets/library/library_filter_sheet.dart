import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/library/library_bloc.dart';
import '../../../blocs/library/library_event.dart';
import '../../../services/dynamic_theme_service.dart';

class LibraryFilterSheet extends StatefulWidget {
  final String? currentType;
  final Map<String, dynamic>? currentFilters;
  final Function(Map<String, dynamic> filters)? onFiltersApplied;

  const LibraryFilterSheet({
    super.key,
    this.currentType,
    this.currentFilters,
    this.onFiltersApplied,
  });

  @override
  State<LibraryFilterSheet> createState() => _LibraryFilterSheetState();
}

class _LibraryFilterSheetState extends State<LibraryFilterSheet>
    with TickerProviderStateMixin {
  final DynamicThemeService _theme = DynamicThemeService.instance;
  late TabController _tabController;

  String? _selectedGenre;
  String? _selectedArtist;
  String? _selectedYear;
  bool? _isDownloadedOnly;
  String _sortBy = 'alphabetical';

  final List<String> _availableGenres = [
    'Pop', 'Rock', 'Hip Hop', 'Electronic', 'Jazz', 'Classical', 'Country', 'R&B'
  ];

  final List<String> _availableArtists = [
    'Artist A', 'Artist B', 'Artist C', 'Artist D', 'Artist E'
  ];

  final List<String> _availableYears = [
    '2024', '2023', '2022', '2021', '2020', '2019', '2018', '2017'
  ];

  final Map<String, String> _sortOptions = {
    'alphabetical': 'A-Z',
    'recent': 'Recently Added',
    'most_played': 'Most Played',
    'recently_liked': 'Recently Liked',
    'duration': 'Duration',
    'rating': 'Rating',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeFilters();
  }

  void _initializeFilters() {
    if (widget.currentFilters != null) {
      _selectedGenre = widget.currentFilters!['genre'];
      _selectedArtist = widget.currentFilters!['artist'];
      _selectedYear = widget.currentFilters!['year'];
      _isDownloadedOnly = widget.currentFilters!['isDownloaded'];
      _sortBy = widget.currentFilters!['sortBy'] ?? 'alphabetical';
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHandle(),
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFiltersTab(),
                _buildSortingTab(),
              ],
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: EdgeInsets.only(top: _theme.getDynamicSpacing(8)),
      height: 4,
      width: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(_theme.getDynamicSpacing(20)),
      child: Row(
        children: [
          Icon(
            Icons.tune,
            size: _theme.getDynamicFontSize(28),
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(width: _theme.getDynamicSpacing(12)),
          Expanded(
            child: Text(
              'Filter & Sort ${widget.currentType?.toUpperCase() ?? 'LIBRARY'}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: _theme.getDynamicFontSize(22),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: _clearAllFilters,
            child: Text(
              'Clear All',
              style: TextStyle(
                fontSize: _theme.getDynamicFontSize(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      labelStyle: TextStyle(
        fontSize: _theme.getDynamicFontSize(16),
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: _theme.getDynamicFontSize(16),
        fontWeight: FontWeight.normal,
      ),
      tabs: const [
        Tab(text: 'Filters', icon: Icon(Icons.filter_alt)),
        Tab(text: 'Sort', icon: Icon(Icons.sort)),
      ],
    );
  }

  Widget _buildFiltersTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(_theme.getDynamicSpacing(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterSection('Genre', _selectedGenre, _availableGenres, (value) {
            setState(() => _selectedGenre = value);
          }),
          SizedBox(height: _theme.getDynamicSpacing(24)),
          _buildFilterSection('Artist', _selectedArtist, _availableArtists, (value) {
            setState(() => _selectedArtist = value);
          }),
          SizedBox(height: _theme.getDynamicSpacing(24)),
          _buildFilterSection('Year', _selectedYear, _availableYears, (value) {
            setState(() => _selectedYear = value);
          }),
          SizedBox(height: _theme.getDynamicSpacing(24)),
          _buildDownloadFilter(),
          SizedBox(height: _theme.getDynamicSpacing(24)),
          _buildActiveFiltersChips(),
        ],
      ),
    );
  }

  Widget _buildSortingTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(_theme.getDynamicSpacing(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sort By',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: _theme.getDynamicFontSize(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: _theme.getDynamicSpacing(16)),
          ..._sortOptions.entries.map((entry) => _buildSortOption(
            entry.key,
            entry.value,
            _getSortIcon(entry.key),
          )),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    String? selectedValue,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: _theme.getDynamicFontSize(16),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: _theme.getDynamicSpacing(12)),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).dividerColor,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              hint: Text(
                'Select $title',
                style: TextStyle(
                  fontSize: _theme.getDynamicFontSize(14),
                ),
              ),
              isExpanded: true,
              padding: EdgeInsets.symmetric(
                horizontal: _theme.getDynamicSpacing(16),
                vertical: _theme.getDynamicSpacing(8),
              ),
              items: [
                DropdownMenuItem<String>(
                  value: null,
                  child: Text(
                    'All ${title}s',
                    style: TextStyle(
                      fontSize: _theme.getDynamicFontSize(14),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                ...options.map((option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: _theme.getDynamicFontSize(14),
                    ),
                  ),
                )),
              ],
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDownloadFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Availability',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: _theme.getDynamicFontSize(16),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: _theme.getDynamicSpacing(12)),
        Card(
          child: Column(
            children: [
              RadioListTile<bool?>(
                title: const Text('All Items'),
                value: null,
                groupValue: _isDownloadedOnly,
                onChanged: (value) => setState(() => _isDownloadedOnly = value),
              ),
              RadioListTile<bool?>(
                title: Row(
                  children: [
                    Icon(
                      Icons.offline_bolt,
                      size: _theme.getDynamicFontSize(18),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    SizedBox(width: _theme.getDynamicSpacing(8)),
                    const Text('Downloaded Only'),
                  ],
                ),
                value: true,
                groupValue: _isDownloadedOnly,
                onChanged: (value) => setState(() => _isDownloadedOnly = value),
              ),
              RadioListTile<bool?>(
                title: Row(
                  children: [
                    Icon(
                      Icons.cloud_outlined,
                      size: _theme.getDynamicFontSize(18),
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    SizedBox(width: _theme.getDynamicSpacing(8)),
                    const Text('Streaming Only'),
                  ],
                ),
                value: false,
                groupValue: _isDownloadedOnly,
                onChanged: (value) => setState(() => _isDownloadedOnly = value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActiveFiltersChips() {
    final activeFilters = <Widget>[];

    if (_selectedGenre != null) {
      activeFilters.add(_buildFilterChip('Genre: $_selectedGenre', () {
        setState(() => _selectedGenre = null);
      }));
    }

    if (_selectedArtist != null) {
      activeFilters.add(_buildFilterChip('Artist: $_selectedArtist', () {
        setState(() => _selectedArtist = null);
      }));
    }

    if (_selectedYear != null) {
      activeFilters.add(_buildFilterChip('Year: $_selectedYear', () {
        setState(() => _selectedYear = null);
      }));
    }

    if (_isDownloadedOnly != null) {
      activeFilters.add(_buildFilterChip(
        _isDownloadedOnly! ? 'Downloaded Only' : 'Streaming Only',
        () {
          setState(() => _isDownloadedOnly = null);
        },
      ));
    }

    if (activeFilters.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Active Filters',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: _theme.getDynamicFontSize(16),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: _theme.getDynamicSpacing(12)),
        Wrap(
          spacing: _theme.getDynamicSpacing(8),
          runSpacing: _theme.getDynamicSpacing(8),
          children: activeFilters,
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: _theme.getDynamicFontSize(12),
        ),
      ),
      onDeleted: onRemove,
      deleteIcon: Icon(
        Icons.close,
        size: _theme.getDynamicFontSize(16),
      ),
    );
  }

  Widget _buildSortOption(String value, String label, IconData icon) {
    return Card(
      child: RadioListTile<String>(
        title: Row(
          children: [
            Icon(
              icon,
              size: _theme.getDynamicFontSize(20),
              color: _sortBy == value 
                  ? Theme.of(context).primaryColor 
                  : Theme.of(context).colorScheme.outline,
            ),
            SizedBox(width: _theme.getDynamicSpacing(12)),
            Text(
              label,
              style: TextStyle(
                fontSize: _theme.getDynamicFontSize(16),
                fontWeight: _sortBy == value ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
        value: value,
        groupValue: _sortBy,
        onChanged: (newValue) => setState(() => _sortBy = newValue!),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(_theme.getDynamicSpacing(20)),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: _theme.getDynamicSpacing(16),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: _theme.getDynamicFontSize(16),
                ),
              ),
            ),
          ),
          SizedBox(width: _theme.getDynamicSpacing(12)),
          Expanded(
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: _theme.getDynamicSpacing(16),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Apply Filters',
                style: TextStyle(
                  fontSize: _theme.getDynamicFontSize(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getSortIcon(String sortType) {
    switch (sortType) {
      case 'alphabetical':
        return Icons.sort_by_alpha;
      case 'recent':
        return Icons.access_time;
      case 'most_played':
        return Icons.play_circle;
      case 'recently_liked':
        return Icons.favorite;
      case 'duration':
        return Icons.timer;
      case 'rating':
        return Icons.star;
      default:
        return Icons.sort;
    }
  }

  void _clearAllFilters() {
    setState(() {
      _selectedGenre = null;
      _selectedArtist = null;
      _selectedYear = null;
      _isDownloadedOnly = null;
      _sortBy = 'alphabetical';
    });
  }

  void _applyFilters() {
    final filters = {
      'genre': _selectedGenre,
      'artist': _selectedArtist,
      'year': _selectedYear,
      'isDownloaded': _isDownloadedOnly,
      'sortBy': _sortBy,
    };
    
    // Use callback if provided, otherwise use BLoC
    if (widget.onFiltersApplied != null) {
      widget.onFiltersApplied!(filters);
    } else {
      context.read<LibraryBloc>().add(LibraryFilterApplied(
        genre: _selectedGenre,
        artist: _selectedArtist,
        year: _selectedYear,
        isDownloaded: _isDownloadedOnly,
        sortBy: _sortBy,
      ));
    }

    Navigator.pop(context);
  }
}