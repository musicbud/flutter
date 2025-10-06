import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/library/library_bloc.dart';
import '../../../../blocs/library/library_state.dart';
import '../../../widgets/common/index.dart';
import '../../../../core/theme/design_system.dart';
import '../components/playlist_card.dart';
import '../dialogs/create_playlist_dialog.dart';

class PlaylistsTab extends StatelessWidget {
  const PlaylistsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, state) {
        if (state is LibraryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is LibraryLoaded && state.items.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Playlists',
                    style: DesignSystem.headlineSmall.copyWith(
                      color: DesignSystem.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  PrimaryButton(
                    text: 'Create New',
                    onPressed: () => _showCreatePlaylistDialog(context),
                    icon: Icons.add,
                    size: ModernButtonSize.small,
                  ),
                ],
              ),
              SizedBox(height: DesignSystem.spacingMD),

              // Playlists Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: DesignSystem.spacingMD,
                  mainAxisSpacing: DesignSystem.spacingMD,
                  childAspectRatio: 0.8,
                ),
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return PlaylistCard(
                    title: item.title,
                    trackCount: item.description ?? '0 tracks',
                    imageUrl: item.imageUrl ?? 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=300&fit=crop',
                    accentColor: DesignSystem.accentBlue,
                  );
                },
              ),
            ],
          );
        }

        // Show empty state or fallback
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Playlists',
                  style: DesignSystem.headlineSmall.copyWith(
                    color: DesignSystem.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                PrimaryButton(
                  text: 'Create New',
                  onPressed: () => _showCreatePlaylistDialog(context),
                  icon: Icons.add,
                  size: ModernButtonSize.small,
                ),
              ],
            ),
            SizedBox(height: DesignSystem.spacingMD),
            Center(
              child: Padding(
                padding: EdgeInsets.all(DesignSystem.spacingXL),
                child: Column(
                  children: [
                    Icon(
                      Icons.queue_music,
                      size: 64,
                      color: DesignSystem.onSurfaceVariant,
                    ),
                    SizedBox(height: DesignSystem.spacingMD),
                    Text(
                      'No playlists yet',
                      style: DesignSystem.headlineSmall.copyWith(
                        color: DesignSystem.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: DesignSystem.spacingSM),
                    Text(
                      'Create your first playlist to get started',
                      style: DesignSystem.bodyMedium.copyWith(
                        color: DesignSystem.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCreatePlaylistDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreatePlaylistDialog(),
    );
  }
}