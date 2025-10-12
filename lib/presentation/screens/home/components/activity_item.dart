import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// Individual activity item data class
class ActivityItemData {
  final String id;
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final IconData? icon;
  final VoidCallback? onTap;
  final DateTime? timestamp;

  const ActivityItemData({
    required this.id,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.icon,
    this.onTap,
    this.timestamp,
  });
}

/// A reusable activity item widget for displaying recent activities
class ActivityItem extends StatelessWidget {
  final ActivityItemData activity;

  const ActivityItem({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: activity.onTap ?? () {},
        borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
        child: Container(
          padding: const EdgeInsets.all(DesignSystem.spacingMD),
          decoration: BoxDecoration(
            color: DesignSystem.surfaceContainer,
            borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
            border: Border.all(
              color: DesignSystem.border.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Activity Image/Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(DesignSystem.radiusXS),
                  color: DesignSystem.surfaceContainerHigh,
                  image: activity.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(activity.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: activity.imageUrl == null && activity.icon != null
                    ? const Icon(
                        Icons.music_note,
                        color: DesignSystem.onSurfaceVariant,
                        size: 24,
                      )
                    : activity.imageUrl == null
                        ? const Icon(
                            Icons.music_note,
                            color: DesignSystem.onSurfaceVariant,
                            size: 24,
                          )
                        : null,
              ),
              const SizedBox(width: DesignSystem.spacingMD),

              // Activity Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      style: DesignSystem.bodyLarge.copyWith(
                        color: DesignSystem.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (activity.subtitle != null) ...[
                      const SizedBox(height: DesignSystem.spacingXS),
                      Text(
                        activity.subtitle!,
                        style: DesignSystem.bodySmall.copyWith(
                          color: DesignSystem.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (activity.timestamp != null) ...[
                      const SizedBox(height: DesignSystem.spacingXS),
                      Text(
                        _formatTimestamp(activity.timestamp!),
                        style: DesignSystem.bodySmall.copyWith(
                          color: DesignSystem.onSurfaceVariant,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Activity Action
              const Icon(
                Icons.arrow_forward_ios,
                color: DesignSystem.onSurfaceVariant,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

/// A list of activity items with optional header
class ActivityList extends StatelessWidget {
  final List<ActivityItemData> activities;
  final String? title;
  final VoidCallback? onSeeAll;
  final bool showHeader;

  const ActivityList({
    super.key,
    required this.activities,
    this.title,
    this.onSeeAll,
    this.showHeader = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader && title != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title!,
                style: DesignSystem.headlineSmall.copyWith(
                  color: DesignSystem.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (onSeeAll != null)
                TextButton(
                  onPressed: onSeeAll,
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      color: DesignSystem.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: DesignSystem.spacingMD),
        ],
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activities.length,
          separatorBuilder: (context, index) => const SizedBox(height: DesignSystem.spacingXS),
          itemBuilder: (context, index) {
            return ActivityItem(activity: activities[index]);
          },
        ),
      ],
    );
  }
}