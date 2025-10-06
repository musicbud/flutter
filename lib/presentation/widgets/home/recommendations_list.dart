import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
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
    final appTheme = AppTheme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and "See All" button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: appTheme.typography.headlineH6.copyWith(
                  color: appTheme.colors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (onSeeAll != null)
                TextButton(
                  onPressed: onSeeAll,
                  child: Text(
                    'See All',
                    style: appTheme.typography.bodySmall.copyWith(
                      color: appTheme.colors.primaryRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: appTheme.spacing.md),

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
                    right: index < items.length - 1 ? appTheme.spacing.md : 0,
                  ),
                  child: _buildRecommendationCard(item, appTheme),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(RecommendationItem item, AppTheme appTheme) {
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
              borderRadius: BorderRadius.circular(appTheme.radius.lg),
              color: appTheme.colors.surfaceDark,
            ),
            child: item.imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(appTheme.radius.lg),
                    child: Image.network(
                      item.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildIconFallback(appTheme, item.icon);
                      },
                    ),
                  )
                : _buildIconFallback(appTheme, item.icon),
          ),

          SizedBox(height: appTheme.spacing.md),

          // Title
          Text(
            item.title,
            style: appTheme.typography.titleMedium.copyWith(
              color: appTheme.colors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          // Subtitle
          if (item.subtitle != null) ...[
            SizedBox(height: appTheme.spacing.xs),
            Text(
              item.subtitle!,
              style: appTheme.typography.bodySmall.copyWith(
                color: appTheme.colors.textMuted,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          SizedBox(height: appTheme.spacing.md),

          // Action row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Play button
              Container(
                padding: EdgeInsets.all(appTheme.spacing.sm),
                decoration: BoxDecoration(
                  color: appTheme.colors.primaryRed,
                  borderRadius: BorderRadius.circular(appTheme.radius.circular),
                ),
                child: Icon(
                  item.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: appTheme.colors.white,
                  size: 16,
                ),
              ),

              // Like button
              Icon(
                item.isLiked ? Icons.favorite : Icons.favorite_border,
                color: item.isLiked ? appTheme.colors.primaryRed : appTheme.colors.textMuted,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconFallback(AppTheme appTheme, IconData? icon) {
    return Container(
      decoration: BoxDecoration(
        gradient: appTheme.gradients.cardGradient,
        borderRadius: BorderRadius.circular(appTheme.radius.lg),
      ),
      child: Icon(
        icon ?? Icons.music_note,
        color: appTheme.colors.primaryRed,
        size: 40,
      ),
    );
  }
}