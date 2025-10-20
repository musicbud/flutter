import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// Profile card for social/dating style interfaces
///
/// Perfect for:
/// - User discovery
/// - Match recommendations
/// - Friend suggestions
/// - Social features
///
/// Example:
/// ```dart
/// ProfileCard(
///   profile: UserProfile(
///     name: 'Sarah Johnson',
///     age: 24,
///     location: 'New York, NY',
///     bio: 'Music producer and DJ',
///     interests: ['Electronic', 'DJ', 'Music Production'],
///     matchPercentage: 95,
///   ),
///   onLike: () => likeUser(),
///   onPass: () => passUser(),
///   onMessage: () => messageUser(),
/// )
/// ```
class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.profile,
    this.onLike,
    this.onPass,
    this.onMessage,
    this.showActions = true,
  });

  final UserProfile profile;
  final VoidCallback? onLike;
  final VoidCallback? onPass;
  final VoidCallback? onMessage;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(design?.designSystemSpacing.lg ?? 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Row(
              children: [
                // Avatar with online status
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: profile.imageUrl != null
                          ? NetworkImage(profile.imageUrl!)
                          : null,
                      child: profile.imageUrl == null
                          ? Icon(Icons.person, size: 40)
                          : null,
                    ),
                    if (profile.isOnline)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: design?.designSystemColors.success ?? Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.surface,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: design?.designSystemSpacing.lg ?? 16),
                // Profile Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            profile.name,
                            style: (design?.designSystemTypography.titleMedium ?? theme.textTheme.titleMedium)?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (profile.age != null) ...[
                            SizedBox(width: design?.designSystemSpacing.sm ?? 8),
                            Text(
                              '${profile.age}',
                              style: design?.designSystemTypography.bodyMedium ?? theme.textTheme.bodyMedium,
                            ),
                          ],
                        ],
                      ),
                      if (profile.location != null) ...[
                        SizedBox(height: design?.designSystemSpacing.xs ?? 4),
                        Text(
                          profile.location!,
                          style: (design?.designSystemTypography.bodySmall ?? theme.textTheme.bodySmall)?.copyWith(
                            color: design?.designSystemColors.textMuted ?? theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                      if (profile.distance != null) ...[
                        SizedBox(height: design?.designSystemSpacing.xs ?? 4),
                        Text(
                          '${profile.distance} away',
                          style: (design?.designSystemTypography.caption ?? theme.textTheme.bodySmall)?.copyWith(
                            color: design?.designSystemColors.primary ?? theme.colorScheme.primary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Match Percentage Badge
                if (profile.matchPercentage != null)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: design?.designSystemSpacing.sm ?? 8,
                      vertical: design?.designSystemSpacing.xs ?? 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          design?.designSystemColors.primary ?? theme.colorScheme.primary,
                          design?.designSystemColors.secondary ?? theme.colorScheme.secondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(design?.designSystemRadius.md ?? 8),
                    ),
                    child: Text(
                      '${profile.matchPercentage}%',
                      style: (design?.designSystemTypography.bodySmall ?? theme.textTheme.bodySmall)?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            
            if (profile.bio != null) ...[
              SizedBox(height: design?.designSystemSpacing.lg ?? 16),
              Text(
                profile.bio!,
                style: (design?.designSystemTypography.bodyMedium ?? theme.textTheme.bodyMedium)?.copyWith(
                  height: 1.4,
                ),
              ),
            ],

            if (profile.interests.isNotEmpty) ...[
              SizedBox(height: design?.designSystemSpacing.md ?? 12),
              Wrap(
                spacing: design?.designSystemSpacing.sm ?? 8,
                runSpacing: design?.designSystemSpacing.xs ?? 4,
                children: profile.interests.map((interest) {
                  return Chip(
                    label: Text(
                      interest,
                      style: TextStyle(fontSize: 12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: design?.designSystemSpacing.xs ?? 4),
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
            ],

            if (showActions) ...[
              SizedBox(height: design?.designSystemSpacing.lg ?? 16),
              Row(
                children: [
                  if (onPass != null)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onPass,
                        child: Text('Pass'),
                      ),
                    ),
                  if (onPass != null && onLike != null)
                    SizedBox(width: design?.designSystemSpacing.sm ?? 8),
                  if (onLike != null)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onLike,
                        child: Text('Like'),
                      ),
                    ),
                  if (onMessage != null) ...[
                    SizedBox(width: design?.designSystemSpacing.sm ?? 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onMessage,
                        icon: Icon(Icons.message, size: 18),
                        label: Text('Message'),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Compact profile card for lists
class CompactProfileCard extends StatelessWidget {
  const CompactProfileCard({
    super.key,
    required this.profile,
    this.onTap,
  });

  final UserProfile profile;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();

    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: profile.imageUrl != null ? NetworkImage(profile.imageUrl!) : null,
            child: profile.imageUrl == null ? Icon(Icons.person) : null,
          ),
          if (profile.isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: design?.designSystemColors.success ?? Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.colorScheme.surface, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Text(profile.name),
          if (profile.age != null) ...[
            Text(', '),
            Text(
              '${profile.age}',
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
          Spacer(),
          if (profile.matchPercentage != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: design?.designSystemColors.primary ?? theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${profile.matchPercentage}%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      subtitle: profile.location != null ? Text(profile.location!) : null,
      onTap: onTap,
    );
  }
}

/// User profile data model
class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    this.age,
    this.location,
    this.distance,
    this.bio,
    this.interests = const [],
    this.matchPercentage,
    this.imageUrl,
    this.isOnline = false,
  });

  final String id;
  final String name;
  final int? age;
  final String? location;
  final String? distance;
  final String? bio;
  final List<String> interests;
  final int? matchPercentage;
  final String? imageUrl;
  final bool isOnline;
}

/// Swipeable profile card (Tinder-style)
class SwipeableProfileCard extends StatefulWidget {
  const SwipeableProfileCard({
    super.key,
    required this.profile,
    required this.onSwipeLeft,
    required this.onSwipeRight,
  });

  final UserProfile profile;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;

  @override
  State<SwipeableProfileCard> createState() => _SwipeableProfileCardState();
}

class _SwipeableProfileCardState extends State<SwipeableProfileCard> {
  Offset _position = Offset.zero;
  double _rotation = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _position += details.delta;
          _rotation = _position.dx / 1000;
        });
      },
      onPanEnd: (details) {
        if (_position.dx.abs() > 100) {
          if (_position.dx > 0) {
            widget.onSwipeRight();
          } else {
            widget.onSwipeLeft();
          }
        }
        setState(() {
          _position = Offset.zero;
          _rotation = 0;
        });
      },
      child: Transform.translate(
        offset: _position,
        child: Transform.rotate(
          angle: _rotation,
          child: ProfileCard(
            profile: widget.profile,
            showActions: false,
          ),
        ),
      ),
    );
  }
}

/// Online status indicator
class OnlineStatusIndicator extends StatelessWidget {
  const OnlineStatusIndicator({
    super.key,
    required this.isOnline,
    this.size = 12,
  });

  final bool isOnline;
  final double size;

  @override
  Widget build(BuildContext context) {
    final design = Theme.of(context).extension<DesignSystemThemeExtension>();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isOnline
            ? (design?.designSystemColors.success ?? Colors.green)
            : (design?.designSystemColors.textMuted ?? Colors.grey),
        shape: BoxShape.circle,
      ),
    );
  }
}
