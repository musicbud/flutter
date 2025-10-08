import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';
import '../../../presentation/widgets/common/modern_button.dart';

class ConnectServicesScreen extends StatelessWidget {
  const ConnectServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Connect Services',
          style: DesignSystem.headlineSmall,
        ),
        backgroundColor: DesignSystem.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignSystem.spacingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connect your favorite music and entertainment services to enhance your experience.',
              style: DesignSystem.bodyLarge,
            ),
            const SizedBox(height: DesignSystem.spacingXL),

            _buildServiceCard(
              context,
              'Spotify',
              'Connect your Spotify account to control playback and access your music library.',
              Icons.music_note,
              Colors.green,
              () {
                // TODO: Navigate to Spotify connect page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Spotify connection coming soon')),
                );
              },
            ),

            const SizedBox(height: DesignSystem.spacingLG),

            _buildServiceCard(
              context,
              'YouTube Music',
              'Link your YouTube Music account for seamless music streaming.',
              Icons.play_circle_filled,
              Colors.red,
              () {
                // TODO: Navigate to YouTube Music connect page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('YouTube Music connection coming soon')),
                );
              },
            ),

            const SizedBox(height: DesignSystem.spacingLG),

            _buildServiceCard(
              context,
              'Last.fm',
              'Connect Last.fm to track your listening habits and discover new music.',
              Icons.radio,
              Colors.orange,
              () {
                // TODO: Navigate to Last.fm connect page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Last.fm connection coming soon')),
                );
              },
            ),

            const SizedBox(height: DesignSystem.spacingLG),

            _buildServiceCard(
              context,
              'MyAnimeList',
              'Link your MyAnimeList account to share your anime preferences.',
              Icons.tv,
              Colors.blue,
              () {
                // TODO: Navigate to MyAnimeList connect page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('MyAnimeList connection coming soon')),
                );
              },
            ),

            const SizedBox(height: DesignSystem.spacingXL),

            Text(
              'Connected Services',
              style: DesignSystem.headlineSmall,
            ),
            const SizedBox(height: DesignSystem.spacingMD),

            // TODO: Show list of connected services
            Card(
              child: Padding(
                padding: const EdgeInsets.all(DesignSystem.spacingLG),
                child: Row(
                  children: [
                    Icon(
                      Icons.music_note,
                      color: Colors.green,
                      size: 32,
                    ),
                    const SizedBox(width: DesignSystem.spacingMD),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Spotify',
                            style: DesignSystem.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Connected',
                            style: DesignSystem.bodySmall.copyWith(
                              color: DesignSystem.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ModernButton(
                      text: 'Manage',
                      onPressed: () {
                        Navigator.pushNamed(context, '/spotify-control');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onConnect,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DesignSystem.spacingLG),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: DesignSystem.spacingMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: DesignSystem.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: DesignSystem.spacingXS),
                  Text(
                    description,
                    style: DesignSystem.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(width: DesignSystem.spacingMD),
            ModernButton(
              text: 'Connect',
              onPressed: onConnect,
            ),
          ],
        ),
      ),
    );
  }
}