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
    final colors = Theme.of(context).designSystemColors!;
    final typography = Theme.of(context).designSystemTypography!;
    final spacing = Theme.of(context).designSystemSpacing!;
    final radius = Theme.of(context).designSystemRadius!;

    return GestureDetector(
      onTap: item.onTap,
      child: Column(
        children: [
          // Image/Icon container
          Container(
            width: itemWidth - 20, // Account for padding
            height: itemWidth - 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius.md),
              color: colors.surfaceContainer,
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
                    color: colors.onSurfaceVariant,
                    size: 30,
                  )
                : null,
          ),

          SizedBox(height: spacing.sm),

          // Title
          Text(
            item.title,
            style: typography.caption.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),

          // Subtitle
          if (item.subtitle != null) ...[
            SizedBox(height: spacing.xs),
            Text(
              item.subtitle!,
              style: typography.caption.copyWith(
                color: colors.onSurfaceVariant,
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