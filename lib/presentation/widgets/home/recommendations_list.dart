import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';
import '../common/modern_card.dart';

class RecommendationItem {
  final String id;
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isPlaying;
  final bool isLiked;

  const RecommendationItem({
    required this.id,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.icon,
    this.onTap,
    this.isPlaying = false,
    this.isLiked = false,
  });
}

class RecommendationsList extends StatelessWidget {
  final String title;
  final List<RecommendationItem> items;
  final VoidCallback? onSeeAll;
  final double itemWidth;
  final double itemHeight;

  const RecommendationsList({
    super.key,
    required this.title,
    required this.items,
    this.onSeeAll,
    this.itemWidth = 140.0,
    this.itemHeight = 180.0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).designSystemColors!;
    final typography = Theme.of(context).designSystemTypography!;
    final spacing = Theme.of(context).designSystemSpacing!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and "See All" button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: typography.headlineSmall.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (onSeeAll != null)
                TextButton(
                  onPressed: onSeeAll,
                  child: Text(
                    'See All',
                    style: typography.bodySmall.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: spacing.md),

          // Horizontal list
          SizedBox(
            height: itemHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Container(
                  width: itemWidth,
                  margin: EdgeInsets.only(
                    right: index < items.length - 1 ? spacing.md : 0,
                  ),
                  child: _buildRecommendationCard(item, context),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(RecommendationItem item, BuildContext context) {
    final colors = Theme.of(context).designSystemColors!;
    final typography = Theme.of(context).designSystemTypography!;
    final spacing = Theme.of(context).designSystemSpacing!;
    final radius = Theme.of(context).designSystemRadius!;

    return ModernCard(
      variant: ModernCardVariant.primary,
      onTap: item.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image/Icon section
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius.lg),
              color: colors.surfaceContainer,
            ),
            child: item.imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(radius.lg),
                    child: Image.network(
                      item.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildIconFallback(context, item.icon);
                      },
                    ),
                  )
                : _buildIconFallback(context, item.icon),
          ),

          SizedBox(height: spacing.md),

          // Title
          Text(
            item.title,
            style: typography.titleMedium.copyWith(
              color: colors.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          // Subtitle
          if (item.subtitle != null) ...[
            SizedBox(height: spacing.xs),
            Text(
              item.subtitle!,
              style: typography.bodySmall.copyWith(
                color: colors.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          SizedBox(height: spacing.md),

          // Action row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Play button
              Container(
                padding: EdgeInsets.all(spacing.sm),
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(radius.circular),
                ),
                child: Icon(
                  item.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: colors.onPrimary,
                  size: 16,
                ),
              ),

              // Like button
              Icon(
                item.isLiked ? Icons.favorite : Icons.favorite_border,
                color: item.isLiked ? colors.primary : colors.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconFallback(BuildContext context, IconData? icon) {
    final colors = Theme.of(context).designSystemColors!;
    final gradients = Theme.of(context).designSystemGradients!;
    final radius = Theme.of(context).designSystemRadius!;

    return Container(
      decoration: BoxDecoration(
        gradient: gradients.card,
        borderRadius: BorderRadius.circular(radius.lg),
      ),
      child: Icon(
        icon ?? Icons.music_note,
        color: colors.primary,
        size: 40,
      ),
    );
  }
}