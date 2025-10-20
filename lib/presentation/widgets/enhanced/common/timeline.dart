import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// Timeline widget for displaying chronological events
///
/// Supports:
/// - Vertical and horizontal timelines
/// - Custom icons and colors for events
/// - Card-based event display
/// - Connector lines between events
///
/// Example:
/// ```dart
/// Timeline(
///   events: [
///     TimelineEvent(
///       title: 'Song Added',
///       description: 'Added to Favorites',
///       time: '2 hours ago',
///       icon: Icons.favorite,
///     ),
///   ],
/// )
/// ```
class Timeline extends StatelessWidget {
  const Timeline({
    super.key,
    required this.events,
    this.axis = Axis.vertical,
    this.lineColor,
    this.lineWidth = 2.0,
  });

  final List<TimelineEvent> events;
  final Axis axis;
  final Color? lineColor;
  final double lineWidth;

  @override
  Widget build(BuildContext context) {
    if (axis == Axis.vertical) {
      return _VerticalTimeline(
        events: events,
        lineColor: lineColor,
        lineWidth: lineWidth,
      );
    } else {
      return _HorizontalTimeline(
        events: events,
        lineColor: lineColor,
        lineWidth: lineWidth,
      );
    }
  }
}

class _VerticalTimeline extends StatelessWidget {
  const _VerticalTimeline({
    required this.events,
    required this.lineColor,
    required this.lineWidth,
  });

  final List<TimelineEvent> events;
  final Color? lineColor;
  final double lineWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();
    final connectorColor = lineColor ?? design?.designSystemColors.border ?? theme.colorScheme.outline;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final isLast = index == events.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Indicator column
              SizedBox(
                width: 40,
                child: Column(
                  children: [
                    _TimelineIndicator(
                      icon: event.icon,
                      color: event.color,
                      backgroundColor: event.backgroundColor,
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: lineWidth,
                          color: connectorColor,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(width: design?.designSystemSpacing.md ?? 12),
              // Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: isLast ? 0 : (design?.designSystemSpacing.lg ?? 16),
                  ),
                  child: _TimelineEventCard(event: event),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HorizontalTimeline extends StatelessWidget {
  const _HorizontalTimeline({
    required this.events,
    required this.lineColor,
    required this.lineWidth,
  });

  final List<TimelineEvent> events;
  final Color? lineColor;
  final double lineWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();
    final connectorColor = lineColor ?? design?.designSystemColors.border ?? theme.colorScheme.outline;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < events.length; i++) ...[
            Column(
              children: [
                _TimelineIndicator(
                  icon: events[i].icon,
                  color: events[i].color,
                  backgroundColor: events[i].backgroundColor,
                ),
                SizedBox(height: design?.designSystemSpacing.sm ?? 8),
                SizedBox(
                  width: 200,
                  child: _TimelineEventCard(event: events[i]),
                ),
              ],
            ),
            if (i < events.length - 1)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: design?.designSystemSpacing.sm ?? 8),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      width: 40,
                      height: lineWidth,
                      color: connectorColor,
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _TimelineIndicator extends StatelessWidget {
  const _TimelineIndicator({
    this.icon,
    this.color,
    this.backgroundColor,
  });

  final IconData? icon;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();
    final indicatorColor = color ?? design?.designSystemColors.primary ?? theme.colorScheme.primary;
    final bgColor = backgroundColor ?? indicatorColor.withValues(alpha: 0.1);

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: indicatorColor, width: 2),
      ),
      child: icon != null
          ? Icon(icon, size: 20, color: indicatorColor)
          : null,
    );
  }
}

class _TimelineEventCard extends StatelessWidget {
  const _TimelineEventCard({required this.event});

  final TimelineEvent event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (event.time != null) ...[
          Text(
            event.time!,
            style: (design?.designSystemTypography.caption ?? theme.textTheme.bodySmall)?.copyWith(
              color: design?.designSystemColors.textMuted ?? theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: design?.designSystemSpacing.xs ?? 4),
        ],
        Text(
          event.title,
          style: (design?.designSystemTypography.bodyMedium ?? theme.textTheme.bodyMedium)?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        if (event.description != null) ...[
          SizedBox(height: design?.designSystemSpacing.xs ?? 4),
          Text(
            event.description!,
            style: (design?.designSystemTypography.bodySmall ?? theme.textTheme.bodySmall)?.copyWith(
              color: design?.designSystemColors.onSurfaceVariant ?? theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        if (event.child != null) ...[
          SizedBox(height: design?.designSystemSpacing.sm ?? 8),
          event.child!,
        ],
      ],
    );
  }
}

/// Timeline event data model
class TimelineEvent {
  const TimelineEvent({
    required this.title,
    this.description,
    this.time,
    this.icon,
    this.color,
    this.backgroundColor,
    this.child,
  });

  final String title;
  final String? description;
  final String? time;
  final IconData? icon;
  final Color? color;
  final Color? backgroundColor;
  final Widget? child;
}

/// Compact timeline for lists
class CompactTimeline extends StatelessWidget {
  const CompactTimeline({
    super.key,
    required this.events,
    this.lineColor,
  });

  final List<CompactTimelineEvent> events;
  final Color? lineColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();
    final connectorColor = lineColor ?? design?.designSystemColors.border ?? theme.colorScheme.outline;

    return Column(
      children: [
        for (int i = 0; i < events.length; i++) ...[
          _CompactTimelineItem(
            event: events[i],
            showConnector: i < events.length - 1,
            connectorColor: connectorColor,
          ),
        ],
      ],
    );
  }
}

class _CompactTimelineItem extends StatelessWidget {
  const _CompactTimelineItem({
    required this.event,
    required this.showConnector,
    required this.connectorColor,
  });

  final CompactTimelineEvent event;
  final bool showConnector;
  final Color connectorColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Indicator and connector
          Column(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: event.color ?? design?.designSystemColors.primary ?? theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              if (showConnector)
                Expanded(
                  child: Container(
                    width: 2,
                    color: connectorColor,
                    margin: EdgeInsets.symmetric(vertical: design?.designSystemSpacing.xs ?? 4),
                  ),
                ),
            ],
          ),
          SizedBox(width: design?.designSystemSpacing.md ?? 12),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: design?.designSystemSpacing.md ?? 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          event.title,
                          style: design?.designSystemTypography.bodyMedium ?? theme.textTheme.bodyMedium,
                        ),
                      ),
                      if (event.time != null)
                        Text(
                          event.time!,
                          style: (design?.designSystemTypography.caption ?? theme.textTheme.bodySmall)?.copyWith(
                            color: design?.designSystemColors.textMuted ?? theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                  if (event.subtitle != null) ...[
                    SizedBox(height: design?.designSystemSpacing.xs ?? 4),
                    Text(
                      event.subtitle!,
                      style: (design?.designSystemTypography.bodySmall ?? theme.textTheme.bodySmall)?.copyWith(
                        color: design?.designSystemColors.onSurfaceVariant ?? theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact timeline event
class CompactTimelineEvent {
  const CompactTimelineEvent({
    required this.title,
    this.subtitle,
    this.time,
    this.color,
  });

  final String title;
  final String? subtitle;
  final String? time;
  final Color? color;
}

/// Activity timeline with avatars
class ActivityTimeline extends StatelessWidget {
  const ActivityTimeline({
    super.key,
    required this.activities,
  });

  final List<Activity> activities;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        final isLast = index == activities.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar and connector
              Column(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: activity.avatarUrl != null
                        ? NetworkImage(activity.avatarUrl!)
                        : null,
                    child: activity.avatarUrl == null
                        ? Text(
                            activity.userInitials,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          )
                        : null,
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: EdgeInsets.symmetric(vertical: design?.designSystemSpacing.xs ?? 4),
                        color: design?.designSystemColors.border ?? theme.colorScheme.outline,
                      ),
                    ),
                ],
              ),
              SizedBox(width: design?.designSystemSpacing.md ?? 12),
              // Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: isLast ? 0 : (design?.designSystemSpacing.lg ?? 16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: activity.userName,
                                    style: (design?.designSystemTypography.bodyMedium ?? theme.textTheme.bodyMedium)?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ${activity.action}',
                                    style: design?.designSystemTypography.bodyMedium ?? theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (activity.time != null) ...[
                        SizedBox(height: design?.designSystemSpacing.xs ?? 4),
                        Text(
                          activity.time!,
                          style: (design?.designSystemTypography.caption ?? theme.textTheme.bodySmall)?.copyWith(
                            color: design?.designSystemColors.textMuted ?? theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                      if (activity.content != null) ...[
                        SizedBox(height: design?.designSystemSpacing.sm ?? 8),
                        activity.content!,
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Activity data model
class Activity {
  const Activity({
    required this.userName,
    required this.userInitials,
    required this.action,
    this.avatarUrl,
    this.time,
    this.content,
  });

  final String userName;
  final String userInitials;
  final String action;
  final String? avatarUrl;
  final String? time;
  final Widget? content;
}
