import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../models/album.dart';
import '../components/release_card.dart';

class NewReleasesSection extends StatelessWidget {
  final List<Album> albums;
  final bool isLoading;

  const NewReleasesSection({
    super.key,
    required this.albums,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'New Releases',
            style: appTheme.typography.headlineH7.copyWith(
              color: appTheme.colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: appTheme.spacing.md),
          SizedBox(
            height: 280,
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : albums.isEmpty
                    ? const Center(child: Text('No new releases available'))
                    : ListView(
                        scrollDirection: Axis.horizontal,
                        children: albums.map((album) => Padding(
                          padding: EdgeInsets.only(right: appTheme.spacing.md),
                          child: ReleaseCard(
                            title: album.name,
                            artist: album.artistName,
                            type: 'Album',
                            imageUrl: album.imageUrls?.first,
                            icon: Icons.album,
                            accentColor: Colors.blue,
                            onTap: () {
                              // Navigate to album detail
                              Navigator.pushNamed(
                                context,
                                '/album/${album.id}',
                                arguments: album,
                              );
                            },
                          ),
                        )).toList(),
                      ),
          ),
        ],
      ),
    );
  }
}