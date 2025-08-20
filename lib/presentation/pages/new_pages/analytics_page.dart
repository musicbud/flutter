import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/channel_statistics/channel_statistics_bloc.dart';
import '../../../blocs/channel_statistics/channel_statistics_event.dart';
import '../../../blocs/channel_statistics/channel_statistics_state.dart';
import '../../../blocs/content/content_bloc.dart';
import '../../../blocs/content/content_event.dart';
import '../../../blocs/content/content_state.dart';
import '../../../domain/models/channel_statistics.dart';
import '../../../domain/models/content_service.dart';
import '../../constants/app_constants.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../widgets/common/app_app_bar.dart';
import '../../widgets/common/app_button.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({Key? key}) : super(key: key);

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTimeRange = '7d';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    // Load initial data
    _loadAnalyticsData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadAnalyticsData() {
    // Load analytics data
    context.read<ChannelStatisticsBloc>().add(ChannelStatisticsRequested());
    context.read<ContentBloc>().add(ContentAnalyticsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppAppBar(
        title: 'Analytics',
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportAnalytics(),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showAnalyticsSettings(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTimeRangeSelector(),
          _buildOverviewCards(),
          _buildTabBar(),
          Expanded(
            child: _buildTabView(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text(
            'Time Range:',
            style: TextStyle(
              color: AppConstants.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTimeRangeChip('24h', '24h'),
                  _buildTimeRangeChip('7d', '7d'),
                  _buildTimeRangeChip('30d', '30d'),
                  _buildTimeRangeChip('90d', '90d'),
                  _buildTimeRangeChip('1y', '1y'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeChip(String label, String value) {
    final isSelected = _selectedTimeRange == value;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedTimeRange = value;
          });
          _loadAnalyticsData();
        },
        backgroundColor: AppConstants.surfaceColor,
        selectedColor: AppConstants.primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppConstants.textColor,
        ),
        side: BorderSide(
          color: isSelected ? AppConstants.primaryColor : AppConstants.borderColor,
        ),
      ),
    );
  }

  Widget _buildOverviewCards() {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildOverviewCard(
            'Total Users',
            '1,234',
            Icons.people,
            Colors.blue,
            '+12%',
          ),
          _buildOverviewCard(
            'Active Channels',
            '89',
            Icons.chat,
            Colors.green,
            '+5%',
          ),
          _buildOverviewCard(
            'Content Shared',
            '5,678',
            Icons.share,
            Colors.orange,
            '+23%',
          ),
          _buildOverviewCard(
            'Engagement',
            '89%',
            Icons.trending_up,
            Colors.purple,
            '+8%',
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(String title, String value, IconData icon, Color color, String change) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.borderColor.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const Spacer(),
                Text(
                  change,
                  style: TextStyle(
                    color: change.startsWith('+') ? Colors.green : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: AppConstants.textSecondaryColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
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
          Tab(text: 'Channels'),
          Tab(text: 'Users'),
          Tab(text: 'Content'),
        ],
      ),
    );
  }

  Widget _buildTabView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildChannelsTab(),
        _buildUsersTab(),
        _buildContentTab(),
      ],
    );
  }

  Widget _buildChannelsTab() {
    return BlocBuilder<ChannelStatisticsBloc, ChannelStatisticsState>(
      builder: (context, state) {
        if (state is ChannelStatisticsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ChannelStatisticsLoaded) {
          return _buildChannelsList(state.statistics);
        }

        if (state is ChannelStatisticsFailure) {
          return _buildErrorWidget(state.error);
        }

        return const Center(child: Text('No channel statistics found'));
      },
    );
  }

  Widget _buildUsersTab() {
    return BlocBuilder<ContentBloc, ContentState>(
      builder: (context, state) {
        if (state is ContentAnalyticsLoaded) {
          return _buildUsersAnalytics(state.userAnalytics);
        }

        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.analytics, size: 64, color: Colors.white54),
              SizedBox(height: 16),
              Text(
                'User Analytics',
                style: TextStyle(color: Colors.white54),
              ),
              Text(
                'View detailed user engagement metrics',
                style: TextStyle(color: Colors.white38, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContentTab() {
    return BlocBuilder<ContentBloc, ContentState>(
      builder: (context, state) {
        if (state is ContentAnalyticsLoaded) {
          return _buildContentAnalytics(state.contentAnalytics);
        }

        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.content_copy, size: 64, color: Colors.white54),
              SizedBox(height: 16),
              Text(
                'Content Analytics',
                style: TextStyle(color: Colors.white54),
              ),
              Text(
                'Track content performance and engagement',
                style: TextStyle(color: Colors.white38, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChannelsList(List<ChannelStatistics> statistics) {
    if (statistics.isEmpty) {
      return const Center(
        child: Text(
          'No channel statistics found',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: statistics.length,
      itemBuilder: (context, index) {
        final stat = statistics[index];
        return _buildChannelStatCard(stat);
      },
    );
  }

  Widget _buildChannelStatCard(ChannelStatistics stat) {
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
                  backgroundColor: AppConstants.primaryColor.withOpacity(0.3),
                  child: Text(
                    stat.channelName.isNotEmpty ? stat.channelName[0].toUpperCase() : 'C',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stat.channelName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${stat.memberCount} members',
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
                    color: _getActivityColor(stat.activityLevel),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getActivityLabel(stat.activityLevel),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatItem('Messages', '${stat.messageCount}'),
                _buildStatItem('Active Users', '${stat.activeUserCount}'),
                _buildStatItem('Growth', '${stat.growthRate.toStringAsFixed(1)}%'),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: stat.engagementRate,
              backgroundColor: Colors.grey[800],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getEngagementColor(stat.engagementRate),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Engagement: ${(stat.engagementRate * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                color: AppConstants.textSecondaryColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: AppConstants.textSecondaryColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersAnalytics(Map<String, dynamic> userAnalytics) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('User Engagement'),
          _buildEngagementChart(),
          const SizedBox(height: 24),
          _buildSectionTitle('Top Users'),
          _buildTopUsersList(),
          const SizedBox(height: 24),
          _buildSectionTitle('User Growth'),
          _buildGrowthChart(),
        ],
      ),
    );
  }

  Widget _buildContentAnalytics(Map<String, dynamic> contentAnalytics) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Content Performance'),
          _buildPerformanceChart(),
          const SizedBox(height: 24),
          _buildSectionTitle('Popular Content'),
          _buildPopularContentList(),
          const SizedBox(height: 24),
          _buildSectionTitle('Content Types'),
          _buildContentTypeChart(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          color: AppConstants.textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEngagementChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.borderColor.withOpacity(0.3)),
      ),
      child: const Center(
        child: Text(
          'Engagement Chart',
          style: TextStyle(color: Colors.white54),
        ),
      ),
    );
  }

  Widget _buildTopUsersList() {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.borderColor.withOpacity(0.3)),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppConstants.primaryColor.withOpacity(0.3),
              child: Text(
                'U${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              'User ${index + 1}',
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              '${(85 - index * 10)}% engagement',
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: Text(
              '${(index + 1) * 100}',
              style: TextStyle(
                color: AppConstants.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGrowthChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.borderColor.withOpacity(0.3)),
      ),
      child: const Center(
        child: Text(
          'Growth Chart',
          style: TextStyle(color: Colors.white54),
        ),
      ),
    );
  }

  Widget _buildPerformanceChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.borderColor.withOpacity(0.3)),
      ),
      child: const Center(
        child: Text(
          'Performance Chart',
          style: TextStyle(color: Colors.white54),
        ),
      ),
    );
  }

  Widget _buildPopularContentList() {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.borderColor.withOpacity(0.3)),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.music_note,
                color: Colors.white70,
              ),
            ),
            title: Text(
              'Content ${index + 1}',
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              '${(95 - index * 5)}% performance',
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: Text(
              '${(index + 1) * 50}',
              style: TextStyle(
                color: AppConstants.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContentTypeChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.borderColor.withOpacity(0.3)),
      ),
      child: const Center(
        child: Text(
          'Content Type Chart',
          style: TextStyle(color: Colors.white54),
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
            'Error loading analytics',
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
            onPressed: _loadAnalyticsData,
          ),
        ],
      ),
    );
  }

  // Helper methods
  Color _getActivityColor(String activityLevel) {
    switch (activityLevel.toLowerCase()) {
      case 'high':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getActivityLabel(String activityLevel) {
    switch (activityLevel.toLowerCase()) {
      case 'high':
        return 'HIGH';
      case 'medium':
        return 'MED';
      case 'low':
        return 'LOW';
      default:
        return 'N/A';
    }
  }

  Color _getEngagementColor(double rate) {
    if (rate >= 0.7) return Colors.green;
    if (rate >= 0.4) return Colors.orange;
    return Colors.red;
  }

  // Action methods
  void _exportAnalytics() {
    // Implement export analytics logic
  }

  void _showAnalyticsSettings() {
    // Implement analytics settings dialog
  }
}