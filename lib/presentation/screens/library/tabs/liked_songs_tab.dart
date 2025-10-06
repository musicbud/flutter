import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/library/library_bloc.dart';
import '../../../../blocs/library/library_state.dart';
import '../../../../core/theme/design_system.dart';
import '../components/song_card.dart';

class LikedSongsTab extends StatelessWidget {
  const LikedSongsTab({super.key});

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
              Text(
                'Liked Songs',
                style: DesignSystem.headlineSmall.copyWith(
                  color: DesignSystem.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: DesignSystem.spacingMD),

              // Liked Songs List
              Column(
                children: state.items.map((item) {
                  return Column(
                    children: [
                      SongCard(
                        title: item.title,
                        artist: item.description ?? 'Unknown Artist',
                        genre: 'Liked', // Could be enhanced to show genre
                        imageUrl: item.imageUrl ?? 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=100&h=100&fit=crop',
                        accentColor: DesignSystem.accentBlue,
                      ),
                      SizedBox(height: DesignSystem.spacingMD),
                    ],
                  );
                }).toList(),
              ),
            ],
          );
        }

        // Empty state
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Liked Songs',
              style: DesignSystem.headlineSmall.copyWith(
                color: DesignSystem.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: DesignSystem.spacingMD),
            Center(
              child: Padding(
                padding: EdgeInsets.all(DesignSystem.spacingXL),
                child: Column(
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: DesignSystem.onSurfaceVariant,
                    ),
                    SizedBox(height: DesignSystem.spacingMD),
                    Text(
                      'No liked songs yet',
                      style: DesignSystem.headlineSmall.copyWith(
                        color: DesignSystem.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: DesignSystem.spacingSM),
                    Text(
                      'Songs you like will appear here',
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
}