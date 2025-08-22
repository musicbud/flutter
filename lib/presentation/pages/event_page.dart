
import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../widgets/common/index.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  String _selectedCategory = 'All';
  List<String> _categories = ['All', 'Live Music', 'Festivals', 'Workshops', 'Meetups', 'Concerts'];

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: appTheme.colors.darkTone,
      appBar: AppBar(
        backgroundColor: appTheme.colors.darkTone,
        elevation: 0,
        title: Text(
          'Events',
          style: appTheme.typography.headlineH6.copyWith(
            color: appTheme.colors.pureWhite,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: appTheme.colors.pureWhite,
            ),
            onPressed: () {
              // Handle search
            },
          ),
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: appTheme.colors.pureWhite,
            ),
            onPressed: () {
              // Handle filter
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(appTheme.spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured Event
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(appTheme.radius.xl),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    appTheme.colors.primaryRed,
                    appTheme.colors.primaryRed.withOpacity(0.7),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(appTheme.radius.xl),
                      child: CustomPaint(
                        painter: EventMusicNotePainter(),
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            gradient: appTheme.gradients.primaryGradient,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(appTheme.radius.xl),
                              bottomRight: Radius.circular(appTheme.radius.xl),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
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
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: appTheme.spacing.sm,
                                  vertical: appTheme.spacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: appTheme.colors.pureWhite.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(appTheme.radius.sm),
                                ),
                                child: Text(
                                  'Featured',
                                  style: appTheme.typography.bodyH8.copyWith(
                                    color: appTheme.colors.pureWhite,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: appTheme.spacing.md),
                          Text(
                            'Summer Music Festival 2024',
                            style: appTheme.typography.displayH1.copyWith(
                              color: appTheme.colors.pureWhite,
                              fontSize: 24,
                            ),
                          ),
                          SizedBox(height: appTheme.spacing.sm),
                          Text(
                            'July 15-17, 2024 • Central Park, NYC',
                            style: appTheme.typography.bodyH8.copyWith(
                              color: appTheme.colors.pureWhite.withOpacity(0.9),
                            ),
                          ),
                          SizedBox(height: appTheme.spacing.md),
                          Row(
                            children: [
                              Icon(
                                Icons.people,
                                color: appTheme.colors.pureWhite,
                                size: 16,
                              ),
                              SizedBox(width: appTheme.spacing.xs),
                              Text(
                                '2.5K attending',
                                style: appTheme.typography.bodyH8.copyWith(
                                  color: appTheme.colors.pureWhite.withOpacity(0.9),
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: appTheme.spacing.md),
                              Icon(
                                Icons.star,
                                color: appTheme.colors.pureWhite,
                                size: 16,
                              ),
                              SizedBox(width: appTheme.spacing.xs),
                              Text(
                                '4.8 ★',
                                style: appTheme.typography.bodyH8.copyWith(
                                  color: appTheme.colors.pureWhite.withOpacity(0.9),
                                  fontSize: 12,
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

            SizedBox(height: appTheme.spacing.xl),

            // Event Categories
            Text(
              'Categories',
              style: appTheme.typography.headlineH6.copyWith(
                color: appTheme.colors.pureWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: appTheme.spacing.md),

            // Category Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: appTheme.spacing.md,
              mainAxisSpacing: appTheme.spacing.md,
              children: [
                _buildCategoryCard('Concerts', Icons.music_note, appTheme),
                _buildCategoryCard('Festivals', Icons.celebration, appTheme),
                _buildCategoryCard('Workshops', Icons.school, appTheme),
                _buildCategoryCard('Meetups', Icons.group, appTheme),
              ],
            ),

            SizedBox(height: appTheme.spacing.xl),

            // Upcoming Events
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Upcoming Events',
                  style: appTheme.typography.headlineH6.copyWith(
                    color: appTheme.colors.pureWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // View all events
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
            SizedBox(height: appTheme.spacing.md),

            // Event List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: appTheme.spacing.md),
                  child: AppCard(
                    variant: AppCardVariant.event,
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(appTheme.radius.md),
                            gradient: appTheme.gradients.primaryGradient,
                          ),
                          child: Icon(
                            Icons.event,
                            size: 40,
                            color: appTheme.colors.pureWhite,
                          ),
                        ),
                        SizedBox(width: appTheme.spacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jazz Night at Blue Note',
                                style: appTheme.typography.headlineH6.copyWith(
                                  color: appTheme.colors.pureWhite,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: appTheme.spacing.xs),
                              Text(
                                'June 20, 2024 • 8:00 PM',
                                style: appTheme.typography.bodyH8.copyWith(
                                  color: appTheme.colors.lightGray,
                                ),
                              ),
                              SizedBox(height: appTheme.spacing.xs),
                              Text(
                                'Blue Note Jazz Club, NYC',
                                style: appTheme.typography.bodyH8.copyWith(
                                  color: appTheme.colors.lightGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppButton(
                          text: 'Book',
                          onPressed: () {
                            // Handle booking
                          },
                          variant: AppButtonVariant.primary,
                          size: AppButtonSize.small,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, AppTheme appTheme) {
    return Container(
      decoration: BoxDecoration(
        color: appTheme.colors.darkTone,
        borderRadius: BorderRadius.circular(appTheme.radius.lg),
        border: Border.all(
          color: appTheme.colors.lightGray.withOpacity(0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: appTheme.colors.primaryRed,
            size: 32,
          ),
          SizedBox(height: appTheme.spacing.sm),
          Text(
            title,
            style: appTheme.typography.bodyH8.copyWith(
              color: appTheme.colors.pureWhite,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for Music Notes Background
class EventMusicNotePainter extends CustomPainter {
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