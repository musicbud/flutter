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
    final connectorColor = lineColor ?? DesignSystem.border;

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
              const SizedBox(width: DesignSystem.spacingMD),
              // Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: isLast ? 0 : (DesignSystem.spacingLG),
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
    final connectorColor = lineColor ?? DesignSystem.border;

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
                const SizedBox(height: DesignSystem.spacingSM),
                SizedBox(
                  width: 200,
                  child: _TimelineEventCard(event: events[i]),
                ),
              ],
            ),
            if (i < events.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingSM),
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
    final indicatorColor = color ?? DesignSystem.primary;
    final bgColor = backgroundColor ?? indicatorColor.withAlpha(25);

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (event.time != null) ...[
          Text(
            event.time!,
            style: (DesignSystem.caption).copyWith(
              color: DesignSystem.textMuted,
            ),
          ),
          const SizedBox(height: DesignSystem.spacingXS),
        ],
        Text(
          event.title,
          style: (DesignSystem.bodyMedium).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        if (event.description != null) ...[
          const SizedBox(height: DesignSystem.spacingXS),
          Text(
            event.description!,
            style: (DesignSystem.bodySmall).copyWith(
              color: DesignSystem.onSurfaceVariant,
            ),
          ),
        ],
        if (event.child != null) ...[
          const SizedBox(height: DesignSystem.spacingSM),
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
    final connectorColor = lineColor ?? DesignSystem.border;

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
                  color: event.color ?? DesignSystem.primary,
                  shape: BoxShape.circle,
                ),
              ),
              if (showConnector)
                Expanded(
                  child: Container(
                    width: 2,
                    color: connectorColor,
                    margin: const EdgeInsets.symmetric(vertical: DesignSystem.spacingXS),
                  ),
                ),
            ],
          ),
          const SizedBox(width: DesignSystem.spacingMD),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: DesignSystem.spacingMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          event.title,
                          style: DesignSystem.bodyMedium,
                        ),
                      ),
                      if (event.time != null)
                        Text(
                          event.time!,
                          style: (DesignSystem.caption).copyWith(
                            color: DesignSystem.textMuted,
                          ),
                        ),
                    ],
                  ),
                  if (event.subtitle != null) ...[
                    const SizedBox(height: DesignSystem.spacingXS),
                    Text(
                      event.subtitle!,
                      style: (DesignSystem.bodySmall).copyWith(
                        color: DesignSystem.onSurfaceVariant,
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
                        margin: const EdgeInsets.symmetric(vertical: DesignSystem.spacingXS),
                        color: DesignSystem.border,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: DesignSystem.spacingMD),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: DesignSystem.spacingLG,
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
                                    style: (DesignSystem.bodyMedium).copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ${activity.action}',
                                    style: DesignSystem.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (activity.time != null) ...[
                        const SizedBox(height: DesignSystem.spacingXS),
                        Text(
                          activity.time!,
                          style: (DesignSystem.caption).copyWith(
                            color: DesignSystem.textMuted,
                          ),
                        ),
                      ],
                      if (activity.content != null) ...[
                        const SizedBox(height: DesignSystem.spacingSM),
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