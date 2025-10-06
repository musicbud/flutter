import 'package:flutter/material.dart';
import '../../models/channel_stats.dart';

class ChannelStatsCard extends StatelessWidget {
  final ChannelStats stats;
  final bool showTitle;

  const ChannelStatsCard({
    Key? key,
    required this.stats,
    this.showTitle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showTitle) ...[
              Text(
                'Channel Statistics',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
            ],
            _buildStatRow(
              context,
              'Total Members',
              stats.totalParticipants.toString(),
              Icons.people,
            ),
            const SizedBox(height: 8),
            _buildStatRow(
              context,
              'Active Users',
              stats.activeUsers.toString(),
              Icons.person,
            ),
            const SizedBox(height: 8),
            _buildStatRow(
              context,
              'Messages',
              stats.messageCount.toString(),
              Icons.message,
            ),
            if (stats.metrics.isNotEmpty) ...[
              const Divider(height: 32),
              Text(
                'Additional Metrics',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ...stats.metrics.entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: _buildStatRow(
                    context,
                    entry.key,
                    entry.value.toString(),
                    Icons.analytics,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
