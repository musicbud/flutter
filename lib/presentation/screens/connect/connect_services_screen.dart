import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/design_system.dart';
// MIGRATED: import '../../../presentation/widgets/common/modern_button.dart';
import '../../../blocs/settings/settings_bloc.dart';
import '../../../blocs/settings/settings_event.dart';
import '../../../blocs/settings/settings_state.dart';
import '../../widgets/enhanced/enhanced_widgets.dart';

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
        padding: EdgeInsets.all(DesignSystem.spacingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connect your favorite music and entertainment services to enhance your experience.',
              style: DesignSystem.bodyLarge,
            ),
            SizedBox(height: DesignSystem.spacingXL),

            _buildServiceCard(
              context,
              'Spotify',
              'Connect your Spotify account to control playback and access your music library.',
              Icons.music_note,
              Colors.green,
              () {
                context.read<SettingsBloc>().add(const GetServiceLoginUrl('spotify'));
              },
            ),
            SizedBox(height: DesignSystem.spacingLG),


            _buildServiceCard(
              context,
              'YouTube Music',
              'Link your YouTube Music account for seamless music streaming.',
              Icons.play_circle_filled,
              Colors.red,
              () {
                context.read<SettingsBloc>().add(const GetServiceLoginUrl('youtube'));
              },
            ),
            SizedBox(height: DesignSystem.spacingLG),


            _buildServiceCard(
              context,
              'Last.fm',
              'Connect Last.fm to track your listening habits and discover new music.',
              Icons.radio,
              Colors.orange,
              () {
                context.read<SettingsBloc>().add(const GetServiceLoginUrl('lastfm'));
              },
            ),
            SizedBox(height: DesignSystem.spacingLG),

            _buildServiceCard(
              context,
              'MyAnimeList',
              'Link your MyAnimeList account to share your anime preferences.',
              Icons.tv,
              Colors.blue,
              () {
                context.read<SettingsBloc>().add(const GetServiceLoginUrl('mal'));
              },
            ),

            const SizedBox(height: DesignSystem.spacingXL),

            Text(
              'Connected Services',
              style: DesignSystem.headlineSmall,
            ),
            SizedBox(height: DesignSystem.spacingMD),

            BlocListener<SettingsBloc, SettingsState>(
              listener: (context, state) {
                if (state is ServiceConnected) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${state.service} connected successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (state is ServiceConnectionError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to connect ${state.service}: ${state.error}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state is ServiceLoginUrlReceived) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Login URL received for ${state.service}'),
                      backgroundColor: Colors.blue,
                    ),
                  );
                }
              },
              child: Text(
                'Connect services above to see them listed here',
                style: DesignSystem.bodyMedium.copyWith(
                  color: Colors.grey,
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
                color: color.withAlpha((255 * 0.1).round()),
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
