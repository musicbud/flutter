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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and "See All" button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: DesignSystem.headlineSmall.copyWith(
                  color: DesignSystem.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (onSeeAll != null)
                TextButton(
                  onPressed: onSeeAll,
                  child: Text(
                    'See All',
                    style: DesignSystem.bodySmall.copyWith(
                      color: DesignSystem.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: DesignSystem.spacingMD),

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
                    right: index < items.length - 1 ? DesignSystem.spacingMD : 0,
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
              borderRadius: BorderRadius.circular(DesignSystem.radiusLg),
              color: DesignSystem.surfaceContainer,
            ),
            child: item.imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(DesignSystem.radiusLg),
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

          const SizedBox(height: DesignSystem.spacingMD),

          // Title
          Text(
            item.title,
            style: DesignSystem.titleMedium.copyWith(
              color: DesignSystem.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          // Subtitle
          if (item.subtitle != null) ...[
            const SizedBox(height: DesignSystem.spacingXS),
            Text(
              item.subtitle!,
              style: DesignSystem.bodySmall.copyWith(
                color: DesignSystem.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          const SizedBox(height: DesignSystem.spacingMD),

          // Action row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Play button
              Container(
                padding: const EdgeInsets.all(DesignSystem.spacingSM),
                decoration: BoxDecoration(
                  color: DesignSystem.primary,
                  borderRadius: BorderRadius.circular(DesignSystem.radiusCircular),
                ),
                child: Icon(
                  item.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: DesignSystem.onPrimary,
                  size: 16,
                ),
              ),

              // Like button
              Icon(
                item.isLiked ? Icons.favorite : Icons.favorite_border,
                color: item.isLiked ? DesignSystem.primary : DesignSystem.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconFallback(BuildContext context, IconData? icon) {
    return Container(
      decoration: BoxDecoration(
        gradient: DesignSystem.gradientCard,
        borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
      ),
      child: Icon(
        icon ?? Icons.music_note,
        color: DesignSystem.primary,
        size: 40,
      ),
    );
  }
}
