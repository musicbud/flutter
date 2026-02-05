import 'package:flutter/material.dart';
import '../../models/bud_match.dart';
import '../../core/theme/design_system.dart';

class BudMatchListItem extends StatelessWidget {
  final BudMatch budMatch;

  const BudMatchListItem({super.key, required this.budMatch});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: DesignSystem.spacingMD,
        vertical: DesignSystem.spacingXS,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: budMatch.avatarUrl != null
              ? NetworkImage(budMatch.avatarUrl!)
              : null,
          child: budMatch.avatarUrl == null
              ? Text(budMatch.username.substring(0, 1).toUpperCase())
              : null,
        ),
        title: Text(
          budMatch.username,
          style: DesignSystem.bodyLarge,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Match Score: ${(budMatch.matchScore * 100).toStringAsFixed(1)}%',
              style: DesignSystem.bodySmall.copyWith(
                color: DesignSystem.primary,
              ),
            ),
            // Note: Common counts are not provided by backend yet
            if (budMatch.commonArtists > 0 ||
                budMatch.commonTracks > 0 ||
                budMatch.commonGenres > 0)
              Text(
                'Common: ${budMatch.commonArtists} artists, ${budMatch.commonTracks} tracks, ${budMatch.commonGenres} genres',
                style: DesignSystem.bodySmall,
              )
            else
              Text(
                'Similar music tastes',
                style: DesignSystem.bodySmall,
              ),
          ],
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: DesignSystem.neutral500,
        ),
        onTap: () {
          // TODO: Navigate to bud profile or common items page
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Bud profile for ${budMatch.username} coming soon')),
          );
        },
      ),
    );
  }
}
