import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';
import '../../widgets/common/index.dart';

class OnboardingInterestsPage extends StatefulWidget {
  const OnboardingInterestsPage({super.key});

  @override
  State<OnboardingInterestsPage> createState() => _OnboardingInterestsPageState();
}

class _OnboardingInterestsPageState extends State<OnboardingInterestsPage> {
  final Set<String> _selectedInterests = {};
  bool _isValid = false;

  final List<Map<String, dynamic>> _interestCategories = [
    {
      'category': 'Music Genres',
      'interests': [
        {'id': 'pop', 'name': 'Pop', 'icon': Icons.music_note},
        {'id': 'rock', 'name': 'Rock', 'icon': Icons.rocket_launch},
        {'id': 'hip_hop', 'name': 'Hip Hop', 'icon': Icons.headphones},
        {'id': 'electronic', 'name': 'Electronic', 'icon': Icons.electric_bolt},
        {'id': 'jazz', 'name': 'Jazz', 'icon': Icons.piano},
        {'id': 'classical', 'name': 'Classical', 'icon': Icons.music_note},
        {'id': 'country', 'name': 'Country', 'icon': Icons.landscape},
        {'id': 'r_b', 'name': 'R&B', 'icon': Icons.favorite},
      ],
    },
    {
      'category': 'Activities',
      'interests': [
        {'id': 'concerts', 'name': 'Concerts', 'icon': Icons.music_note},
        {'id': 'festivals', 'name': 'Festivals', 'icon': Icons.celebration},
        {'id': 'clubbing', 'name': 'Clubbing', 'icon': Icons.nightlife},
        {'id': 'dancing', 'name': 'Dancing', 'icon': Icons.directions_run},
        {'id': 'instrument', 'name': 'Playing Instrument', 'icon': Icons.piano},
        {'id': 'singing', 'name': 'Singing', 'icon': Icons.mic_external_on},
        {'id': 'music_production', 'name': 'Music Production', 'icon': Icons.music_note},
        {'id': 'music_discovery', 'name': 'Music Discovery', 'icon': Icons.explore},
      ],
    },
    {
      'category': 'Social',
      'interests': [
        {'id': 'music_parties', 'name': 'Music Parties', 'icon': Icons.celebration},
        {'id': 'music_clubs', 'name': 'Music Clubs', 'icon': Icons.nightlife},
        {'id': 'music_communities', 'name': 'Music Communities', 'icon': Icons.group},
        {'id': 'collaboration', 'name': 'Collaboration', 'icon': Icons.handshake},
        {'id': 'music_sharing', 'name': 'Music Sharing', 'icon': Icons.share},
        {'id': 'music_reviews', 'name': 'Music Reviews', 'icon': Icons.rate_review},
        {'id': 'music_news', 'name': 'Music News', 'icon': Icons.newspaper},
        {'id': 'music_history', 'name': 'Music History', 'icon': Icons.history},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _updateValidation();
  }

  void _toggleInterest(String interestId) {
    setState(() {
      if (_selectedInterests.contains(interestId)) {
        _selectedInterests.remove(interestId);
      } else {
        _selectedInterests.add(interestId);
      }
      _updateValidation();
    });
  }

  void _updateValidation() {
    setState(() {
      _isValid = _selectedInterests.length >= 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: appTheme.colors.darkTone,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(appTheme.spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress Indicator
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      gradient: appTheme.gradients.primaryGradient,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.check,
                      size: 18,
                      color: appTheme.colors.pureWhite,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: EdgeInsets.symmetric(horizontal: appTheme.spacing.sm),
                      decoration: BoxDecoration(
                        color: appTheme.colors.primaryRed,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      gradient: appTheme.gradients.primaryGradient,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.check,
                      size: 18,
                      color: appTheme.colors.pureWhite,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: EdgeInsets.symmetric(horizontal: appTheme.spacing.sm),
                      decoration: BoxDecoration(
                        color: appTheme.colors.primaryRed,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      gradient: appTheme.gradients.primaryGradient,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.check,
                      size: 18,
                      color: appTheme.colors.pureWhite,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: EdgeInsets.symmetric(horizontal: appTheme.spacing.sm),
                      decoration: BoxDecoration(
                        color: appTheme.colors.primaryRed,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      gradient: appTheme.gradients.primaryGradient,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.favorite,
                      size: 18,
                      color: appTheme.colors.pureWhite,
                    ),
                  ),
                ],
              ),

              SizedBox(height: appTheme.spacing.lg),

              // Title and Description
              Text(
                'What are your music interests?',
                style: appTheme.typography.displayH1.copyWith(
                  color: appTheme.colors.pureWhite,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: appTheme.spacing.sm),
              Text(
                'Select at least 3 interests to help us personalize your experience',
                style: appTheme.typography.bodyH8.copyWith(
                  color: appTheme.colors.lightGray,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: appTheme.spacing.md),

              // Selected Count
              Text(
                '${_selectedInterests.length}/24 selected',
                style: appTheme.typography.bodyH8.copyWith(
                  color: appTheme.colors.primaryRed,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: appTheme.spacing.lg),

              // Interests Grid
              Expanded(
                child: ListView.builder(
                  itemCount: _interestCategories.length,
                  itemBuilder: (context, categoryIndex) {
                    final category = _interestCategories[categoryIndex];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: appTheme.spacing.md,
                            horizontal: appTheme.spacing.sm,
                          ),
                          child: Text(
                            category['category'],
                            style: appTheme.typography.headlineH6.copyWith(
                              color: appTheme.colors.pureWhite,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 2.5,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: category['interests'].length,
                          itemBuilder: (context, interestIndex) {
                            final interest = category['interests'][interestIndex];
                            final isSelected = _selectedInterests.contains(interest['id']);

                            return GestureDetector(
                              onTap: () => _toggleInterest(interest['id']),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? appTheme.colors.primaryRed.withValues(alpha: 0.1)
                                      : appTheme.colors.darkTone,
                                  borderRadius: BorderRadius.circular(appTheme.radius.md),
                                  border: Border.all(
                                    color: isSelected
                                        ? appTheme.colors.primaryRed
                                        : appTheme.colors.lightGray.withValues(alpha: 0.3),
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      interest['icon'],
                                      color: isSelected
                                          ? appTheme.colors.primaryRed
                                          : appTheme.colors.lightGray,
                                      size: 20,
                                    ),
                                    SizedBox(width: appTheme.spacing.sm),
                                    Expanded(
                                      child: Text(
                                        interest['name'],
                                        style: appTheme.typography.bodyH8.copyWith(
                                          color: isSelected
                                              ? appTheme.colors.primaryRed
                                              : appTheme.colors.pureWhite,
                                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: appTheme.spacing.md),
                      ],
                    );
                  },
                ),
              ),

              SizedBox(height: appTheme.spacing.lg),

              // Continue Button
              AppButton(
                text: 'Continue',
                onPressed: _isValid ? () {
                  // Navigate to main app or next onboarding step
                  // Navigator.pushReplacement(context, MaterialPageRoute(
                  //   builder: (context) => MainApp(),
                  // ));
                } : null,
                variant: AppButtonVariant.primary,
                size: AppButtonSize.large,
              ),

              SizedBox(height: appTheme.spacing.lg),

              // Skip for now
              Center(
                child: TextButton(
                  onPressed: () {
                    // Skip onboarding and go to main app
                  },
                  child: Text(
                    'Skip for now',
                    style: appTheme.typography.bodyH8.copyWith(
                      color: appTheme.colors.lightGray,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}