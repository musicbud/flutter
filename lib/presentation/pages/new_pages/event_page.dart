import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../widgets/common/app_app_bar.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';
import '../../mixins/page_mixin.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> with PageMixin, TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _currentQuery = '';
  String _selectedFilter = 'all';

  final List<String> _categories = [
    'all',
    'upcoming',
    'ongoing',
    'past',
    'my_events',
    'invitations',
  ];

  final List<String> _filters = [
    'all',
    'music',
    'social',
    'gaming',
    'anime',
    'other',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    _scrollController.addListener(_onScroll);

    // Load initial data
    _loadEvents();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _loadMoreEvents();
    }
  }

  void _loadEvents() {
    // TODO: Implement event loading
    print('Loading events...');
  }

  void _loadMoreEvents() {
    // TODO: Implement event load more
    print('Loading more events...');
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppAppBar(
        title: 'Events',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateEventDialog(),
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
          _buildFilterChips(),
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
        labelText: 'Search Events',
        hintText: 'Search for events, artists, venues...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _currentQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _clearSearch,
              )
            : null,
        onChanged: (value) {
          setState(() {
            _currentQuery = value;
          });
          if (value.isNotEmpty) {
            _searchEvents(value);
          }
        },
        onSubmitted: _searchEvents,
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _filters.map((filter) => Container(
          margin: const EdgeInsets.only(right: 8),
          child: FilterChip(
            label: Text(_getFilterDisplayName(filter)),
            selected: _selectedFilter == filter,
            onSelected: (selected) {
              setState(() {
                _selectedFilter = filter;
              });
              _filterEvents();
            },
            backgroundColor: AppConstants.surfaceColor,
            selectedColor: AppConstants.primaryColor,
            labelStyle: TextStyle(
              color: _selectedFilter == filter ? Colors.white : AppConstants.textColor,
            ),
            side: BorderSide(
              color: _selectedFilter == filter ? AppConstants.primaryColor : AppConstants.borderColor,
            ),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppConstants.borderColor.withValues(alpha: 0.3)),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppConstants.primaryColor,
          borderRadius: BorderRadius.circular(25),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppConstants.textSecondaryColor,
        isScrollable: true,
        tabs: _categories.map((category) => Tab(
          text: _getCategoryDisplayName(category),
        )).toList(),
      ),
    );
  }

  Widget _buildTabView() {
    if (_currentQuery.isEmpty && _selectedFilter == 'all') {
      return _buildEventSuggestions();
    }

    return TabBarView(
      controller: _tabController,
      children: _categories.map((category) => _buildEventsList(category)).toList(),
    );
  }

  Widget _buildEventSuggestions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Featured Events'),
          _buildFeaturedEvents(),
          const SizedBox(height: 24),
          _buildSectionTitle('Upcoming Events'),
          _buildUpcomingEvents(),
          const SizedBox(height: 24),
          _buildSectionTitle('Event Categories'),
          _buildEventCategories(),
        ],
      ),
    );
  }

  Widget _buildEventsList(String category) {
        // TODO: Implement event list
    return const Center(child: Text('Event functionality coming soon'));
  }

  Widget _buildFeaturedEvents() {
    final featuredEvents = [
      {
        'title': 'Summer Music Festival 2024',
        'date': 'July 15-17, 2024',
        'location': 'Central Park, NYC',
        'image': 'assets/event1.jpg',
        'category': 'music',
      },
      {
        'title': 'Anime Convention',
        'date': 'August 5-7, 2024',
        'location': 'Convention Center, LA',
        'image': 'assets/event2.jpg',
        'category': 'anime',
      },
    ];

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: featuredEvents.length,
        itemBuilder: (context, index) {
          final event = featuredEvents[index];
          return _buildFeaturedEventCard(event);
        },
      ),
    );
  }

  Widget _buildFeaturedEventCard(Map<String, String> event) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.borderColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withValues(alpha: 0.3),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: const Center(
              child: Icon(
                Icons.event,
                size: 48,
                color: Colors.white70,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.white70, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      event['date']!,
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.white70, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      event['location']!,
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEvents() {
    final upcomingEvents = [
      'Jazz Night at Blue Note',
      'Rock Concert at Madison Square Garden',
      'Electronic Music Festival',
      'Classical Orchestra Performance',
      'Hip Hop Battle',
    ];

    return Column(
      children: upcomingEvents.map((event) => ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.event,
            color: Colors.white70,
            size: 20,
          ),
        ),
        title: Text(
          event,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: const Text(
          'This weekend',
          style: TextStyle(color: Colors.white70),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
        onTap: () => _searchEvents(event),
      )).toList(),
    );
  }

  Widget _buildEventCategories() {
    final categories = [
      {'name': 'Music Events', 'icon': Icons.music_note, 'count': '45'},
      {'name': 'Social Gatherings', 'icon': Icons.people, 'count': '23'},
      {'name': 'Gaming Tournaments', 'icon': Icons.games, 'count': '18'},
      {'name': 'Anime & Manga', 'icon': Icons.animation, 'count': '32'},
      {'name': 'Art Exhibitions', 'icon': Icons.art_track, 'count': '15'},
      {'name': 'Food & Drink', 'icon': Icons.restaurant, 'count': '28'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryCard(category);
      },
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return Card(
      color: AppConstants.surfaceColor,
      child: InkWell(
        onTap: () => _filterByCategory(category['name']),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppConstants.primaryColor.withValues(alpha: 0.3),
                AppConstants.primaryColor.withValues(alpha: 0.1),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  category['icon'],
                  size: 32,
                  color: AppConstants.primaryColor,
                ),
                const SizedBox(height: 8),
                Text(
                  category['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  '${category['count']} events',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventsListView(List<dynamic> events) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return _buildEventCard(event);
      },
    );
  }

  Widget _buildEventCard(dynamic event) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppConstants.surfaceColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Header
          _buildEventHeader(event),

          // Event Content
          _buildEventContent(event),

          // Event Actions
          _buildEventActions(event),
        ],
      ),
    );
  }

  Widget _buildEventHeader(dynamic event) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.primaryColor.withValues(alpha: 0.3),
            AppConstants.primaryColor.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppConstants.primaryColor.withValues(alpha: 0.3),
            backgroundImage: event.organizerAvatarUrl != null
                ? NetworkImage(event.organizerAvatarUrl!)
                : null,
            child: event.organizerAvatarUrl == null
                ? Text(
                    event.organizerName.isNotEmpty ? event.organizerName[0].toUpperCase() : 'O',
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
                  event.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'by ${event.organizerName}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getEventStatusColor(event.status),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getEventStatusText(event.status),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventContent(dynamic event) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (event.description.isNotEmpty) ...[
            Text(
              event.description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
          ],
          _buildEventInfoRow(Icons.calendar_today, _formatEventDate(event.startDate, event.endDate)),
          _buildEventInfoRow(Icons.location_on, event.location),
          _buildEventInfoRow(Icons.people, '${event.participantCount} participants'),
          if (event.maxParticipants != null)
            _buildEventInfoRow(Icons.group, 'Max ${event.maxParticipants} participants'),
          if (event.tags.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: event.tags.map((tag) => Chip(
                label: Text(
                  tag,
                  style: const TextStyle(fontSize: 10),
                ),
                backgroundColor: AppConstants.primaryColor.withValues(alpha: 0.2),
                labelStyle: const TextStyle(color: Colors.white),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEventInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppConstants.primaryColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventActions(dynamic event) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: AppButton(
              text: event.isParticipating ? 'Leave Event' : 'Join Event',
              onPressed: () => _toggleEventParticipation(event.id),
              backgroundColor: event.isParticipating ? Colors.red : AppConstants.primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppButton(
              text: 'View Details',
              onPressed: () => _viewEventDetails(event.id),
              isOutlined: true,
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () => _shareEvent(event.id),
            icon: const Icon(
              Icons.share,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoEventsFound(String category) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getCategoryIcon(category),
            size: 64,
            color: Colors.white54,
          ),
          const SizedBox(height: 16),
          Text(
            'No ${_getCategoryDisplayName(category)} found',
            style: const TextStyle(
              color: AppConstants.textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your search terms or filters',
            style: TextStyle(
              color: AppConstants.textSecondaryColor,
              fontSize: 14,
            ),
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
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          const Text(
            'Error loading events',
            style: TextStyle(
              color: AppConstants.textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: const TextStyle(
              color: AppConstants.textSecondaryColor,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          AppButton(
            text: 'Retry',
            onPressed: _loadEvents,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          color: AppConstants.textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Helper methods
  String _getCategoryDisplayName(String category) {
    switch (category) {
      case 'all':
        return 'All Events';
      case 'upcoming':
        return 'Upcoming';
      case 'ongoing':
        return 'Ongoing';
      case 'past':
        return 'Past';
      case 'my_events':
        return 'My Events';
      case 'invitations':
        return 'Invitations';
      default:
        return category;
    }
  }

  String _getFilterDisplayName(String filter) {
    switch (filter) {
      case 'all':
        return 'All';
      case 'music':
        return 'Music';
      case 'social':
        return 'Social';
      case 'gaming':
        return 'Gaming';
      case 'anime':
        return 'Anime';
      case 'other':
        return 'Other';
      default:
        return filter;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'upcoming':
        return Icons.schedule;
      case 'ongoing':
        return Icons.play_circle;
      case 'past':
        return Icons.history;
      case 'my_events':
        return Icons.person;
      case 'invitations':
        return Icons.mail;
      default:
        return Icons.event;
    }
  }

  Color _getEventStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return Colors.blue;
      case 'ongoing':
        return Colors.green;
      case 'past':
        return Colors.grey;
      case 'cancelled':
        return Colors.red;
      default:
        return AppConstants.primaryColor;
    }
  }

  String _getEventStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return 'UPCOMING';
      case 'ongoing':
        return 'ONGOING';
      case 'past':
        return 'PAST';
      case 'cancelled':
        return 'CANCELLED';
      default:
        return status.toUpperCase();
    }
  }

  String _formatEventDate(DateTime startDate, DateTime? endDate) {
    if (endDate != null && endDate.isAfter(startDate)) {
      return '${_formatDate(startDate)} - ${_formatDate(endDate)}';
    }
    return _formatDate(startDate);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  List<dynamic> _filterEventsByCategory(List<dynamic> events, String category) {
    final now = DateTime.now();

    switch (category) {
      case 'upcoming':
        return events.where((event) => false).toList(); // TODO: Implement date filtering
              case 'ongoing':
          return events.where((event) => false).toList(); // TODO: Implement date filtering
        case 'past':
          return events.where((event) => false).toList(); // TODO: Implement date filtering
        case 'my_events':
          return events.where((event) => false).toList(); // TODO: Implement user filtering
        case 'invitations':
          return events.where((event) => false).toList(); // TODO: Implement invitation filtering
      default:
        return events;
    }
  }

  // Action methods
  void _searchEvents(String query) {
    if (query.trim().isNotEmpty) {
      // TODO: Implement event search
      print('Search events for: ${query.trim()}');
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _currentQuery = '';
    });
    _loadEvents();
  }

  void _filterEvents() {
    if (_selectedFilter != 'all') {
      // TODO: Implement event filtering
      print('Filter events by: $_selectedFilter');
    } else {
      _loadEvents();
    }
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedFilter = category.toLowerCase();
    });
    _filterEvents();
  }

  void _showCreateEventDialog() {
    // Implement create event dialog
  }

  void _showFilterDialog() {
    // Implement filter dialog
  }

  void _toggleEventParticipation(String eventId) {
    // TODO: Implement event participation toggle
    print('Toggle participation for event: $eventId');
  }

  void _viewEventDetails(String eventId) {
    // Navigate to event details page
  }

  void _shareEvent(String eventId) {
    // TODO: Implement event sharing
    print('Share event: $eventId');
  }
}
