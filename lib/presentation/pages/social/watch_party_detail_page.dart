import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';
import '../../widgets/common/index.dart';

class WatchPartyDetailPage extends StatefulWidget {
  const WatchPartyDetailPage({super.key});

  @override
  State<WatchPartyDetailPage> createState() => _WatchPartyDetailPageState();
}

class _WatchPartyDetailPageState extends State<WatchPartyDetailPage> {
  bool _isJoined = false;
  bool _isLiked = false;
  int _likeCount = 127;
  int _participantCount = 23;

  final Map<String, dynamic> _partyDetails = {
    'title': 'Late Night Jazz Session',
    'host': 'Emma Rodriguez',
    'hostImage': 'https://via.placeholder.com/150',
    'date': 'Tonight at 9:00 PM',
    'duration': '2 hours',
    'genre': 'Jazz',
    'description': 'Join us for an intimate jazz session featuring some of the best local jazz musicians. We\'ll be listening to classic jazz standards and discovering new artists together.',
    'location': 'Virtual Room',
    'maxParticipants': 50,
    'currentParticipants': 23,
    'tags': ['Jazz', 'Live Music', 'Virtual', 'Collaborative'],
  };

  final List<Map<String, dynamic>> _participants = [
    {
      'name': 'Emma Rodriguez',
      'image': 'https://via.placeholder.com/150',
      'role': 'Host',
      'isOnline': true,
    },
    {
      'name': 'Mike Chen',
      'image': 'https://via.placeholder.com/150',
      'role': 'Co-host',
      'isOnline': true,
    },
    {
      'name': 'Sarah Johnson',
      'image': 'https://via.placeholder.com/150',
      'role': 'Participant',
      'isOnline': true,
    },
    {
      'name': 'Alex Thompson',
      'image': 'https://via.placeholder.com/150',
      'role': 'Participant',
      'isOnline': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: appTheme.colors.darkTone,
      body: CustomScrollView(
        slivers: [
          // App Bar with Party Image
          SliverAppBar(
            expandedHeight: 250,
            backgroundColor: appTheme.colors.darkTone,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      appTheme.colors.primaryRed.withOpacity(0.8),
                      appTheme.colors.darkTone,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Background Pattern
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: appTheme.colors.primaryRed.withOpacity(0.1),
                        ),
                        child: CustomPaint(
                          painter: WatchPartyMusicNotePainter(),
                        ),
                      ),
                    ),
                    // Party Info Overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(appTheme.spacing.lg),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              appTheme.colors.darkTone.withOpacity(0.8),
                              appTheme.colors.darkTone,
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _partyDetails['title'],
                              style: appTheme.typography.displayH1.copyWith(
                                color: appTheme.colors.pureWhite,
                                fontSize: 28,
                              ),
                            ),
                            SizedBox(height: appTheme.spacing.sm),
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: appTheme.colors.lightGray,
                                  size: 16,
                                ),
                                SizedBox(width: appTheme.spacing.xs),
                                Text(
                                  'Hosted by ${_partyDetails['host']}',
                                  style: appTheme.typography.bodyH8.copyWith(
                                    color: appTheme.colors.lightGray,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: appTheme.colors.pureWhite,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.share,
                  color: appTheme.colors.pureWhite,
                ),
                onPressed: () {
                  // Handle share
                },
              ),
            ],
          ),

          // Party Details
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(appTheme.spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Info Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.schedule,
                          title: 'Date & Time',
                          value: _partyDetails['date'],
                          appTheme: appTheme,
                        ),
                      ),
                      SizedBox(width: appTheme.spacing.md),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.timer,
                          title: 'Duration',
                          value: _partyDetails['duration'],
                          appTheme: appTheme,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: appTheme.spacing.md),

                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.music_note,
                          title: 'Genre',
                          value: _partyDetails['genre'],
                          appTheme: appTheme,
                        ),
                      ),
                      SizedBox(width: appTheme.spacing.md),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.location_on,
                          title: 'Location',
                          value: _partyDetails['location'],
                          appTheme: appTheme,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: appTheme.spacing.lg),

                  // Description
                  Text(
                    'About this party',
                    style: appTheme.typography.headlineH6.copyWith(
                      color: appTheme.colors.pureWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: appTheme.spacing.sm),
                  Text(
                    _partyDetails['description'],
                    style: appTheme.typography.bodyH8.copyWith(
                      color: appTheme.colors.lightGray,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: appTheme.spacing.lg),

                  // Tags
                  Text(
                    'Tags',
                    style: appTheme.typography.headlineH6.copyWith(
                      color: appTheme.colors.pureWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: appTheme.spacing.sm),
                  Wrap(
                    spacing: appTheme.spacing.sm,
                    runSpacing: appTheme.spacing.xs,
                    children: _partyDetails['tags'].map<Widget>((tag) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: appTheme.spacing.sm,
                          vertical: appTheme.spacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: appTheme.colors.primaryRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(appTheme.radius.sm),
                          border: Border.all(
                            color: appTheme.colors.primaryRed.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          tag,
                          style: appTheme.typography.bodyH8.copyWith(
                            color: appTheme.colors.primaryRed,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: appTheme.spacing.lg),

                  // Participants
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Participants (${_partyDetails['currentParticipants']}/${_partyDetails['maxParticipants']})',
                        style: appTheme.typography.headlineH6.copyWith(
                          color: appTheme.colors.pureWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Show all participants
                        },
                        child: Text(
                          'View All',
                          style: appTheme.typography.bodyH8.copyWith(
                            color: appTheme.colors.primaryRed,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: appTheme.spacing.sm),

                  // Participants Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _participants.length,
                    itemBuilder: (context, index) {
                      final participant = _participants[index];

                      return Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(appTheme.radius.lg),
                                  image: DecorationImage(
                                    image: NetworkImage(participant['image']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              if (participant['isOnline'])
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: appTheme.colors.darkTone,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: appTheme.spacing.xs),
                          Text(
                            participant['name'],
                            style: appTheme.typography.bodyH8.copyWith(
                              color: appTheme.colors.pureWhite,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            participant['role'],
                            style: appTheme.typography.bodyH8.copyWith(
                              color: appTheme.colors.lightGray,
                              fontSize: 9,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    },
                  ),

                  SizedBox(height: appTheme.spacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Action Bar
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(appTheme.spacing.lg),
        decoration: BoxDecoration(
          color: appTheme.colors.darkTone,
          border: Border(
            top: BorderSide(
              color: appTheme.colors.lightGray.withOpacity(0.2),
            ),
          ),
        ),
        child: Row(
          children: [
            // Like Button
            Container(
              decoration: BoxDecoration(
                color: appTheme.colors.darkTone,
                borderRadius: BorderRadius.circular(appTheme.radius.md),
                border: Border.all(
                  color: appTheme.colors.lightGray.withOpacity(0.3),
                ),
              ),
              child: IconButton(
                icon: Icon(
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                  color: _isLiked ? appTheme.colors.primaryRed : appTheme.colors.lightGray,
                ),
                onPressed: () {
                  setState(() {
                    _isLiked = !_isLiked;
                    _likeCount += _isLiked ? 1 : -1;
                  });
                },
              ),
            ),

            SizedBox(width: appTheme.spacing.sm),

            Text(
              '$_likeCount',
              style: appTheme.typography.bodyH8.copyWith(
                color: appTheme.colors.lightGray,
              ),
            ),

            const Spacer(),

            // Join/Leave Button
            AppButton(
              text: _isJoined ? 'Leave Party' : 'Join Party',
              onPressed: () {
                setState(() {
                  _isJoined = !_isJoined;
                  _participantCount += _isJoined ? 1 : -1;
                });
              },
              variant: _isJoined ? AppButtonVariant.secondary : AppButtonVariant.primary,
              size: AppButtonSize.large,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required AppTheme appTheme,
  }) {
    return Container(
      padding: EdgeInsets.all(appTheme.spacing.md),
      decoration: BoxDecoration(
        color: appTheme.colors.darkTone,
        borderRadius: BorderRadius.circular(appTheme.radius.md),
        border: Border.all(
          color: appTheme.colors.lightGray.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: appTheme.colors.primaryRed,
            size: 24,
          ),
          SizedBox(height: appTheme.spacing.sm),
          Text(
            title,
            style: appTheme.typography.bodyH8.copyWith(
              color: appTheme.colors.lightGray,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: appTheme.spacing.xs),
          Text(
            value,
            style: appTheme.typography.bodyH8.copyWith(
              color: appTheme.colors.pureWhite,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Custom Painter for Music Notes Background
class WatchPartyMusicNotePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    // Draw some simple music note shapes
    for (int i = 0; i < 5; i++) {
      final x = (size.width / 5) * i + 20;
      final y = (size.height / 3) * (i % 3) + 50;

      // Draw note head
      canvas.drawCircle(Offset(x, y), 8, paint);
      // Draw stem
      canvas.drawRect(
        Rect.fromLTWH(x + 8, y - 20, 2, 20),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}