import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/analytics_repository.dart';
import '../../blocs/analytics/analytics_bloc.dart';
import '../../blocs/analytics/analytics_event.dart';
import '../../blocs/analytics/analytics_state.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_view.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnalyticsBloc(
        analyticsRepository: context.read<AnalyticsRepository>(),
      )..add(const AnalyticsRequested()),
      child: const AnalyticsView(),
    );
  }
}

class AnalyticsView extends StatelessWidget {
  const AnalyticsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Analytics'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Content'),
              Tab(text: 'Social'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            OverviewTab(),
            ContentTab(),
            SocialTab(),
          ],
        ),
      ),
    );
  }
}

class OverviewTab extends StatelessWidget {
  const OverviewTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      builder: (context, state) {
        if (state is AnalyticsLoading) {
          return const LoadingIndicator();
        }

        if (state is AnalyticsError) {
          return ErrorView(
            message: state.message,
            onRetry: () => context.read<AnalyticsBloc>().add(
                  const AnalyticsRequested(),
                ),
          );
        }

        if (state is AnalyticsLoaded) {
          final data = state.analytics.toJson();
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Engagement',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16.0),
                _buildEngagementMetrics(data),
                const SizedBox(height: 24.0),
                Text(
                  'Trend Analysis',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16.0),
                _buildTrendChart(data),
              ],
            ),
          );
        }

        return const Center(
          child: Text('No analytics data available'),
        );
      },
    );
  }

  Widget _buildEngagementMetrics(Map<String, dynamic> data) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16.0,
      crossAxisSpacing: 16.0,
      children: [
        _buildMetricCard(
          'Active Users',
          data['user_engagement']['active_users']?.toString() ?? '0',
          Icons.people,
        ),
        _buildMetricCard(
          'Session Duration',
          data['user_engagement']['avg_session_duration']?.toString() ?? '0',
          Icons.timer,
        ),
        _buildMetricCard(
          'Interactions',
          data['user_engagement']['total_interactions']?.toString() ?? '0',
          Icons.touch_app,
        ),
        _buildMetricCard(
          'Retention Rate',
          '${data['user_engagement']['retention_rate']?.toString() ?? '0'}%',
          Icons.repeat,
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32.0),
            const SizedBox(height: 8.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendChart(Map<String, dynamic> data) {
    // TODO: Implement trend chart using fl_chart package
    return const SizedBox(
      height: 200.0,
      child: Center(
        child: Text('Trend chart coming soon'),
      ),
    );
  }
}

class ContentTab extends StatelessWidget {
  const ContentTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AnalyticsBloc>().add(const ContentAnalyticsRequested());

    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      builder: (context, state) {
        if (state is AnalyticsLoading) {
          return const LoadingIndicator();
        }

        if (state is AnalyticsError) {
          return ErrorView(
            message: state.message,
            onRetry: () => context.read<AnalyticsBloc>().add(
                  const ContentAnalyticsRequested(),
                ),
          );
        }

        if (state is ContentAnalyticsLoaded) {
          final data = state.contentAnalytics;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Content Interactions',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16.0),
                _buildContentMetrics(data),
              ],
            ),
          );
        }

        return const Center(
          child: Text('No content analytics data available'),
        );
      },
    );
  }

  Widget _buildContentMetrics(Map<String, dynamic> data) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildMetricTile(
          'Total Views',
          data['content_interactions']['total_views']?.toString() ?? '0',
          Icons.visibility,
        ),
        _buildMetricTile(
          'Likes',
          data['content_interactions']['total_likes']?.toString() ?? '0',
          Icons.favorite,
        ),
        _buildMetricTile(
          'Comments',
          data['content_interactions']['total_comments']?.toString() ?? '0',
          Icons.comment,
        ),
        _buildMetricTile(
          'Shares',
          data['content_interactions']['total_shares']?.toString() ?? '0',
          Icons.share,
        ),
      ],
    );
  }

  Widget _buildMetricTile(String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Text(
        value,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class SocialTab extends StatelessWidget {
  const SocialTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AnalyticsBloc>().add(const SocialAnalyticsRequested());

    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      builder: (context, state) {
        if (state is AnalyticsLoading) {
          return const LoadingIndicator();
        }

        if (state is AnalyticsError) {
          return ErrorView(
            message: state.message,
            onRetry: () => context.read<AnalyticsBloc>().add(
                  const SocialAnalyticsRequested(),
                ),
          );
        }

        if (state is SocialAnalyticsLoaded) {
          final data = state.socialAnalytics;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Social Activity',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16.0),
                _buildSocialMetrics(data),
              ],
            ),
          );
        }

        return const Center(
          child: Text('No social analytics data available'),
        );
      },
    );
  }

  Widget _buildSocialMetrics(Map<String, dynamic> data) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildMetricTile(
          'Followers',
          data['social_interactions']['followers']?.toString() ?? '0',
          Icons.people,
        ),
        _buildMetricTile(
          'Messages Sent',
          data['social_interactions']['messages_sent']?.toString() ?? '0',
          Icons.message,
        ),
        _buildMetricTile(
          'Event Participation',
          data['social_interactions']['event_participation']?.toString() ?? '0',
          Icons.event,
        ),
        _buildMetricTile(
          'Active Connections',
          data['social_interactions']['active_connections']?.toString() ?? '0',
          Icons.link,
        ),
      ],
    );
  }

  Widget _buildMetricTile(String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Text(
        value,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
