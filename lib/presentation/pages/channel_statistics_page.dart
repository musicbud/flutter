import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/channel_statistics/channel_statistics_bloc.dart';
import '../../blocs/channel_statistics/channel_statistics_event.dart';
import '../../blocs/channel_statistics/channel_statistics_state.dart';
import '../widgets/loading_indicator.dart';

class ChannelStatisticsPage extends StatefulWidget {
  final String channelId;

  const ChannelStatisticsPage({
    Key? key,
    required this.channelId,
  }) : super(key: key);

  @override
  _ChannelStatisticsPageState createState() => _ChannelStatisticsPageState();
}

class _ChannelStatisticsPageState extends State<ChannelStatisticsPage> {
  @override
  void initState() {
    super.initState();
    _fetchStatistics();
  }

  void _fetchStatistics() {
    context
        .read<ChannelStatisticsBloc>()
        .add(ChannelStatisticsRequested(widget.channelId));
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChannelStatisticsBloc, ChannelStatisticsState>(
      listener: (context, state) {
        if (state is ChannelStatisticsFailure) {
          _showSnackBar('Error: ${state.error}');
        }
      },
      builder: (context, state) {
        if (state is ChannelStatisticsLoading) {
          return const Scaffold(
            body: Center(child: LoadingIndicator()),
          );
        }

        if (state is ChannelStatisticsLoaded) {
          final statistics = state.statistics;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Channel Statistics'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    context.read<ChannelStatisticsBloc>().add(
                        ChannelStatisticsRefreshRequested(widget.channelId));
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatisticCard(
                    'Total Members',
                    statistics['total_members']?.toString() ?? '0',
                    Icons.people,
                  ),
                  const SizedBox(height: 16),
                  _buildStatisticCard(
                    'Total Messages',
                    statistics['total_messages']?.toString() ?? '0',
                    Icons.message,
                  ),
                  const SizedBox(height: 16),
                  _buildStatisticCard(
                    'Active Members',
                    statistics['active_members']?.toString() ?? '0',
                    Icons.person_outline,
                  ),
                  const SizedBox(height: 16),
                  _buildStatisticCard(
                    'Messages Today',
                    statistics['messages_today']?.toString() ?? '0',
                    Icons.today,
                  ),
                  const SizedBox(height: 16),
                  _buildStatisticCard(
                    'Average Messages per Day',
                    statistics['avg_messages_per_day']?.toString() ?? '0',
                    Icons.analytics,
                  ),
                ],
              ),
            ),
          );
        }

        return const Scaffold(
          body: Center(
            child: Text('Failed to load statistics'),
          ),
        );
      },
    );
  }

  Widget _buildStatisticCard(String title, String value, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
