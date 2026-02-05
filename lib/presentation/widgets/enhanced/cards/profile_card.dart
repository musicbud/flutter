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

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(DesignSystem.spacingLG),
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
                          ? const Icon(Icons.person, size: 40)
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
                            color: DesignSystem.success,
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
                const SizedBox(width: DesignSystem.spacingLG),
                // Profile Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            profile.name,
                            style: (DesignSystem.titleMedium).copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (profile.age != null) ...[
                            const SizedBox(width: DesignSystem.spacingSM),
                            Text(
                              '${profile.age}',
                              style: DesignSystem.bodyMedium,
                            ),
                          ],
                        ],
                      ),
                      if (profile.location != null) ...[
                        const SizedBox(height: DesignSystem.spacingXS),
                        Text(
                          profile.location!,
                          style: (DesignSystem.bodySmall).copyWith(
                            color: DesignSystem.textMuted,
                          ),
                        ),
                      ],
                      if (profile.distance != null) ...[
                        const SizedBox(height: DesignSystem.spacingXS),
                        Text(
                          '${profile.distance} away',
                          style: (DesignSystem.caption).copyWith(
                            color: DesignSystem.primary,
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignSystem.spacingSM,
                      vertical: DesignSystem.spacingXS,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          DesignSystem.primary,
                          DesignSystem.secondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
                    ),
                    child: Text(
                      '${profile.matchPercentage}%',
                      style: (DesignSystem.bodySmall).copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            
            if (profile.bio != null) ...[
              const SizedBox(height: DesignSystem.spacingLG),
              Text(
                profile.bio!,
                style: (DesignSystem.bodyMedium).copyWith(
                  height: 1.4,
                ),
              ),
            ],

            if (profile.interests.isNotEmpty) ...[
              const SizedBox(height: DesignSystem.spacingMD),
              Wrap(
                spacing: DesignSystem.spacingSM,
                runSpacing: DesignSystem.spacingXS,
                children: profile.interests.map((interest) {
                  return Chip(
                    label: Text(
                      interest,
                      style: const TextStyle(fontSize: 12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingXS),
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
            ],

            if (showActions) ...[
              const SizedBox(height: DesignSystem.spacingLG),
              Row(
                children: [
                  if (onPass != null)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onPass,
                        child: const Text('Pass'),
                      ),
                    ),
                  if (onPass != null && onLike != null)
                    const SizedBox(width: DesignSystem.spacingSM),
                  if (onLike != null)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onLike,
                        child: const Text('Like'),
                      ),
                    ),
                  if (onMessage != null) ...[
                    const SizedBox(width: DesignSystem.spacingSM),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onMessage,
                        icon: const Icon(Icons.message, size: 18),
                        label: const Text('Message'),
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

    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: profile.imageUrl != null ? NetworkImage(profile.imageUrl!) : null,
            child: profile.imageUrl == null ? const Icon(Icons.person) : null,
          ),
          if (profile.isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: DesignSystem.success,
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
            const Text(', '),
            Text(
              '${profile.age}',
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
          const Spacer(),
          if (profile.matchPercentage != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: DesignSystem.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${profile.matchPercentage}%',
                style: const TextStyle(
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
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isOnline
            ? (DesignSystem.success)
            : (DesignSystem.textMuted),
        shape: BoxShape.circle,
      ),
    );
  }
}
