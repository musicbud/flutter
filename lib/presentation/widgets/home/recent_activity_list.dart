import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

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
                  child: _buildActivityItem(item, appTheme),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(RecentActivityItem item, AppTheme appTheme) {
    return GestureDetector(
      onTap: item.onTap,
      child: Column(
        children: [
          // Image/Icon container
          Container(
            width: itemWidth - 20, // Account for padding
            height: itemWidth - 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(appTheme.radius.md),
              color: appTheme.colors.surfaceDark,
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
                    color: appTheme.colors.textSecondary,
                    size: 30,
                  )
                : null,
          ),

          SizedBox(height: appTheme.spacing.sm),

          // Title
          Text(
            item.title,
            style: appTheme.typography.caption.copyWith(
              color: appTheme.colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),

          // Subtitle
          if (item.subtitle != null) ...[
            SizedBox(height: appTheme.spacing.xs),
            Text(
              item.subtitle!,
              style: appTheme.typography.caption.copyWith(
                color: appTheme.colors.textMuted,
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