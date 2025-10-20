import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/library/library_bloc.dart';
import '../../../blocs/library/library_event.dart';
import '../../../services/dynamic_theme_service.dart';

class EnhancedLibraryFilterSheet extends StatefulWidget {
  final Map<String, dynamic>? currentFilters;
  final String libraryType;

  const EnhancedLibraryFilterSheet({
    super.key,
    this.currentFilters,
    required this.libraryType,
  });

  @override
  State<EnhancedLibraryFilterSheet> createState() => _EnhancedLibraryFilterSheetState();
}

class _EnhancedLibraryFilterSheetState extends State<EnhancedLibraryFilterSheet> {
  final DynamicThemeService _theme = DynamicThemeService.instance;
  final _genreController = TextEditingController();
  final _artistController = TextEditingController();
  final _yearController = TextEditingController();
  
  String? _selectedSortBy;
  bool? _isDownloaded;
  bool _showAdvancedFilters = false;
  
  final List<String> _sortOptions = [
    'alphabetical',
    'recent',
    'most_played',
    'recently_liked',
    'date_added',
    'duration',
  ];

  final List<String> _popularGenres = [
    'Pop',
    'Rock',
    'Hip Hop',
    'Electronic',
    'Jazz',
    'Classical',
    'Country',
    'R&B',
    'Alternative',
    'Indie',
  ];

  @override
  void initState() {
    super.initState();
    _initializeFilters();
  }

  void _initializeFilters() {
    if (widget.currentFilters != null) {
      _genreController.text = widget.currentFilters!['genre'] ?? '';
      _artistController.text = widget.currentFilters!['artist'] ?? '';
      _yearController.text = widget.currentFilters!['year'] ?? '';
      _selectedSortBy = widget.currentFilters!['sortBy'];
      _isDownloaded = widget.currentFilters!['isDownloaded'];
    }
  }

  @override
  void dispose() {
    _genreController.dispose();
    _artistController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSortSection(),
                  SizedBox(height: _theme.getDynamicSpacing(24)),
                  _buildGenreFilter(),
                  SizedBox(height: _theme.getDynamicSpacing(16)),
                  _buildArtistFilter(),
                  SizedBox(height: _theme.getDynamicSpacing(16)),
                  _buildDownloadFilter(),
                  SizedBox(height: _theme.getDynamicSpacing(16)),
                  _buildAdvancedFiltersToggle(),
                  if (_showAdvancedFilters) ...[
                    SizedBox(height: _theme.getDynamicSpacing(16)),
                    _buildAdvancedFilters(),
                  ],
                  SizedBox(height: _theme.getDynamicSpacing(24)),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: _theme.getDynamicSpacing(16)),
          Row(
            children: [
              Icon(
                Icons.filter_list,
                color: Theme.of(context).primaryColor,
                size: _theme.getDynamicFontSize(24),
              ),
              SizedBox(width: _theme.getDynamicSpacing(12)),
              Text(
                'Filter & Sort',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: _theme.getDynamicFontSize(20),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
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
        ],
      ),
    );
  }

  Widget _buildSortSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sort by',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: _theme.getDynamicFontSize(16),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: _theme.getDynamicSpacing(12)),
        Wrap(
          spacing: _theme.getDynamicSpacing(8),
          runSpacing: _theme.getDynamicSpacing(8),
          children: _sortOptions.map((option) => _buildSortChip(option)).toList(),
        ),
      ],
    );
  }

  Widget _buildSortChip(String option) {
    final isSelected = _selectedSortBy == option;
    final displayName = _getSortDisplayName(option);
    
    return FilterChip(
      label: Text(displayName),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedSortBy = selected ? option : null;
        });
      },
      selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
      checkmarkColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildGenreFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Genre',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: _theme.getDynamicFontSize(16),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: _theme.getDynamicSpacing(12)),
        TextFormField(
          controller: _genreController,
          decoration: InputDecoration(
            hintText: 'Search by genre',
            prefixIcon: const Icon(Icons.music_note),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            suffixIcon: _genreController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() => _genreController.clear()),
                  )
                : null,
          ),
          onChanged: (value) => setState(() {}),
        ),
        if (_genreController.text.isEmpty) ...[
          SizedBox(height: _theme.getDynamicSpacing(12)),
          Wrap(
            spacing: _theme.getDynamicSpacing(8),
            runSpacing: _theme.getDynamicSpacing(8),
            children: _popularGenres
                .map((genre) => ActionChip(
                      label: Text(genre),
                      onPressed: () => setState(() => _genreController.text = genre),
                    ))
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildArtistFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Artist',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: _theme.getDynamicFontSize(16),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: _theme.getDynamicSpacing(12)),
        TextFormField(
          controller: _artistController,
          decoration: InputDecoration(
            hintText: 'Search by artist',
            prefixIcon: const Icon(Icons.person),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            suffixIcon: _artistController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() => _artistController.clear()),
                  )
                : null,
          ),
          onChanged: (value) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildDownloadFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Download Status',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: _theme.getDynamicFontSize(16),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: _theme.getDynamicSpacing(12)),
        Row(
          children: [
            Expanded(
              child: FilterChip(
                label: const Text('Downloaded'),
                selected: _isDownloaded == true,
                onSelected: (selected) {
                  setState(() {
                    _isDownloaded = selected ? true : null;
                  });
                },
                avatar: const Icon(Icons.download_done, size: 16),
              ),
            ),
            SizedBox(width: _theme.getDynamicSpacing(8)),
            Expanded(
              child: FilterChip(
                label: const Text('Not Downloaded'),
                selected: _isDownloaded == false,
                onSelected: (selected) {
                  setState(() {
                    _isDownloaded = selected ? false : null;
                  });
                },
                avatar: const Icon(Icons.cloud_queue, size: 16),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdvancedFiltersToggle() {
    return InkWell(
      onTap: () => setState(() => _showAdvancedFilters = !_showAdvancedFilters),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: _theme.getDynamicSpacing(12)),
        child: Row(
          children: [
            Icon(
              _showAdvancedFilters ? Icons.expand_less : Icons.expand_more,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(width: _theme.getDynamicSpacing(8)),
            Text(
              'Advanced Filters',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: _theme.getDynamicFontSize(16),
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedFilters() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Year',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: _theme.getDynamicFontSize(16),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: _theme.getDynamicSpacing(8)),
            TextFormField(
              controller: _yearController,
              decoration: InputDecoration(
                hintText: 'e.g., 2023',
                prefixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: _yearController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _yearController.clear()),
                      )
                    : null,
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => setState(() {}),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
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
    );
  }

  void _clearAllFilters() {
    setState(() {
      _genreController.clear();
      _artistController.clear();
      _yearController.clear();
      _selectedSortBy = null;
      _isDownloaded = null;
    });
  }

  void _applyFilters() {
    final filters = LibraryFilterApplied(
      genre: _genreController.text.trim().isEmpty ? null : _genreController.text.trim(),
      artist: _artistController.text.trim().isEmpty ? null : _artistController.text.trim(),
      year: _yearController.text.trim().isEmpty ? null : _yearController.text.trim(),
      isDownloaded: _isDownloaded,
      sortBy: _selectedSortBy,
    );

    context.read<LibraryBloc>().add(filters);
    Navigator.of(context).pop();
  }

  String _getSortDisplayName(String option) {
    switch (option) {
      case 'alphabetical':
        return 'A-Z';
      case 'recent':
        return 'Recently Added';
      case 'most_played':
        return 'Most Played';
      case 'recently_liked':
        return 'Recently Liked';
      case 'date_added':
        return 'Date Added';
      case 'duration':
        return 'Duration';
      default:
        return option;
    }
  }
}