import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';

class RecentActivityItem {
  final String id;
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final IconData? icon;
  final VoidCallback? onTap;

  const RecentActivityItem({
    required this.id,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.icon,
    this.onTap,
  });
}

class RecentActivityList extends StatelessWidget {
  final String title;
  final List<RecentActivityItem> items;
  final VoidCallback? onSeeAll;
  final double itemWidth;
  final double itemHeight;

  const RecentActivityList({
    super.key,
    required this.title,
    required this.items,
    this.onSeeAll,
    this.itemWidth = 100.0,
    this.itemHeight = 120.0,
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
                  child: _buildActivityItem(item, context),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(RecentActivityItem item, BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Column(
        children: [
          // Image/Icon container
          Container(
            width: itemWidth - 20, // Account for padding
            height: itemWidth - 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
              color: DesignSystem.surfaceContainer,
              image: item.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(item.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: item.imageUrl == null
                ? Icon(
                    item.icon ?? Icons.history,
                    color: DesignSystem.onSurfaceVariant,
                    size: 30,
                  )
                : null,
          ),

          const SizedBox(height: DesignSystem.spacingSM),

          // Title
          Text(
            item.title,
            style: DesignSystem.caption.copyWith(
              color: DesignSystem.onSurface,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),

          // Subtitle
          if (item.subtitle != null) ...[
            const SizedBox(height: DesignSystem.spacingXS),
            Text(
              item.subtitle!,
              style: DesignSystem.caption.copyWith(
                color: DesignSystem.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}