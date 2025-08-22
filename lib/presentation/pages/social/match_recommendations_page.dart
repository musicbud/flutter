import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';
import '../../widgets/common/index.dart';

class MatchRecommendationsPage extends StatefulWidget {
  const MatchRecommendationsPage({super.key});

  @override
  State<MatchRecommendationsPage> createState() => _MatchRecommendationsPageState();
}

class _MatchRecommendationsPageState extends State<MatchRecommendationsPage> {
  final List<Map<String, dynamic>> _recommendations = [
    {
      'id': '1',
      'name': 'Sarah Johnson',
      'age': 24,
      'location': 'New York, NY',
      'distance': '2.3 km',
      'bio': 'Music producer and DJ. Love electronic music and underground raves.',
      'interests': ['Electronic', 'DJ', 'Music Production'],
      'matchPercentage': 95,
      'profileImage': 'https://via.placeholder.com/150',
      'isOnline': true,
    },
    {
      'id': '2',
      'name': 'Mike Chen',
      'age': 26,
      'location': 'Los Angeles, CA',
      'distance': '5.1 km',
      'bio': 'Guitarist in a rock band. Looking for people to jam with!',
      'interests': ['Rock', 'Guitar', 'Jamming'],
      'matchPercentage': 87,
      'profileImage': 'https://via.placeholder.com/150',
      'isOnline': false,
    },
    {
      'id': '3',
      'name': 'Emma Rodriguez',
      'age': 22,
      'location': 'Miami, FL',
      'distance': '1.8 km',
      'bio': 'Classical pianist and music teacher. Passionate about classical and jazz.',
      'interests': ['Classical', 'Jazz', 'Piano'],
      'matchPercentage': 92,
      'profileImage': 'https://via.placeholder.com/150',
      'isOnline': true,
    },
    {
      'id': '4',
      'name': 'Alex Thompson',
      'age': 28,
      'location': 'Chicago, IL',
      'distance': '3.7 km',
      'bio': 'Hip-hop artist and producer. Always looking for new collaborations.',
      'interests': ['Hip Hop', 'Rap', 'Production'],
      'matchPercentage': 89,
      'profileImage': 'https://via.placeholder.com/150',
      'isOnline': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: appTheme.colors.darkTone,
      appBar: AppBar(
        backgroundColor: appTheme.colors.darkTone,
        elevation: 0,
        title: Text(
          'Match Recommendations',
          style: appTheme.typography.headlineH6.copyWith(
            color: appTheme.colors.pureWhite,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: appTheme.colors.pureWhite,
            ),
            onPressed: () {
              // Show filter options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Stats
          Container(
            padding: EdgeInsets.all(appTheme.spacing.lg),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(appTheme.spacing.md),
                    decoration: BoxDecoration(
                      color: appTheme.colors.primaryRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(appTheme.radius.md),
                      border: Border.all(
                        color: appTheme.colors.primaryRed.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${_recommendations.length}',
                          style: appTheme.typography.displayH1.copyWith(
                            color: appTheme.colors.primaryRed,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          'New Matches',
                          style: appTheme.typography.bodyH8.copyWith(
                            color: appTheme.colors.lightGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: appTheme.spacing.md),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(appTheme.spacing.md),
                    decoration: BoxDecoration(
                      color: appTheme.colors.primaryRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(appTheme.radius.md),
                      border: Border.all(
                        color: appTheme.colors.primaryRed.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '89%',
                          style: appTheme.typography.displayH1.copyWith(
                            color: appTheme.colors.primaryRed,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          'Avg. Match',
                          style: appTheme.typography.bodyH8.copyWith(
                            color: appTheme.colors.lightGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Recommendations List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
              itemCount: _recommendations.length,
              itemBuilder: (context, index) {
                final recommendation = _recommendations[index];

                return Container(
                  margin: EdgeInsets.only(bottom: appTheme.spacing.lg),
                  child: AppCard(
                    variant: AppCardVariant.profile,
                    child: Column(
                      children: [
                        // Profile Header
                        Row(
                          children: [
                            // Profile Image
                            Stack(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(appTheme.radius.lg),
                                    image: DecorationImage(
                                      image: NetworkImage(recommendation['profileImage']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                if (recommendation['isOnline'])
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: appTheme.colors.darkTone,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            SizedBox(width: appTheme.spacing.lg),

                            // Profile Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        recommendation['name'],
                                        style: appTheme.typography.headlineH6.copyWith(
                                          color: appTheme.colors.pureWhite,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: appTheme.spacing.sm),
                                      Text(
                                        '${recommendation['age']}',
                                        style: appTheme.typography.bodyH8.copyWith(
                                          color: appTheme.colors.lightGray,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: appTheme.spacing.xs),
                                  Text(
                                    recommendation['location'],
                                    style: appTheme.typography.bodyH8.copyWith(
                                      color: appTheme.colors.lightGray,
                                    ),
                                  ),
                                  SizedBox(height: appTheme.spacing.xs),
                                  Text(
                                    '${recommendation['distance']} away',
                                    style: appTheme.typography.bodyH8.copyWith(
                                      color: appTheme.colors.primaryRed,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Match Percentage
                            Container(
                              padding: EdgeInsets.all(appTheme.spacing.sm),
                              decoration: BoxDecoration(
                                gradient: appTheme.gradients.primaryGradient,
                                borderRadius: BorderRadius.circular(appTheme.radius.md),
                              ),
                              child: Text(
                                '${recommendation['matchPercentage']}%',
                                style: appTheme.typography.bodyH8.copyWith(
                                  color: appTheme.colors.pureWhite,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: appTheme.spacing.lg),

                        // Bio
                        Text(
                          recommendation['bio'],
                          style: appTheme.typography.bodyH8.copyWith(
                            color: appTheme.colors.lightGray,
                            height: 1.4,
                          ),
                        ),

                        SizedBox(height: appTheme.spacing.md),

                        // Interests
                        Wrap(
                          spacing: appTheme.spacing.sm,
                          runSpacing: appTheme.spacing.xs,
                          children: recommendation['interests'].map<Widget>((interest) {
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
                                interest,
                                style: appTheme.typography.bodyH8.copyWith(
                                  color: appTheme.colors.primaryRed,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        SizedBox(height: appTheme.spacing.lg),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: AppButton(
                                text: 'Pass',
                                onPressed: () {
                                  // Handle pass action
                                },
                                variant: AppButtonVariant.secondary,
                                size: AppButtonSize.medium,
                              ),
                            ),
                            SizedBox(width: appTheme.spacing.md),
                            Expanded(
                              child: AppButton(
                                text: 'Like',
                                onPressed: () {
                                  // Handle like action
                                },
                                variant: AppButtonVariant.primary,
                                size: AppButtonSize.medium,
                              ),
                            ),
                            SizedBox(width: appTheme.spacing.md),
                            Expanded(
                              child: AppButton(
                                text: 'Message',
                                onPressed: () {
                                  // Handle message action
                                },
                                variant: AppButtonVariant.secondary,
                                size: AppButtonSize.medium,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}