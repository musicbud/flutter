import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../widgets/common/index.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> _welcomeData = [
    {
      'title': 'Welcome to MusicBud',
      'subtitle': 'Your ultimate music companion',
      'description': 'Discover new music, connect with fellow music lovers, and create unforgettable musical experiences together.',
      'icon': Icons.music_note,
      'color': Color(0xFFFE2C54),
    },
    {
      'title': 'Connect & Share',
      'subtitle': 'Build your music community',
      'description': 'Find people who share your musical taste, join watch parties, and discover music through your connections.',
      'icon': Icons.people,
      'color': Color(0xFF2D55FF),
    },
    {
      'title': 'Discover & Explore',
      'subtitle': 'Never-ending music journey',
      'description': 'Get personalized recommendations, explore new genres, and stay updated with the latest music trends.',
      'icon': Icons.explore,
      'color': Color(0xFF2D55FF),
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _welcomeData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: appTheme.colors.darkTone,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(appTheme.spacing.lg),
                child: TextButton(
                  onPressed: () {
                    // Navigate to login/signup
                  },
                  child: Text(
                    'Skip',
                    style: appTheme.typography.bodyH8.copyWith(
                      color: appTheme.colors.lightGray,
                    ),
                  ),
                ),
              ),
            ),

            // Page Content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _welcomeData.length,
                itemBuilder: (context, index) {
                  final data = _welcomeData[index];

                  return Padding(
                    padding: EdgeInsets.all(appTheme.spacing.lg),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                data['color'],
                                data['color'].withOpacity(0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(appTheme.radius.xl),
                          ),
                          child: Icon(
                            data['icon'],
                            size: 60,
                            color: appTheme.colors.pureWhite,
                          ),
                        ),

                        SizedBox(height: appTheme.spacing.xxl),

                        // Title
                        Text(
                          data['title'],
                          style: appTheme.typography.displayH1.copyWith(
                            color: appTheme.colors.pureWhite,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: appTheme.spacing.md),

                        // Subtitle
                        Text(
                          data['subtitle'],
                          style: appTheme.typography.headlineH6.copyWith(
                            color: appTheme.colors.primaryRed,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: appTheme.spacing.lg),

                        // Description
                        Text(
                          data['description'],
                          style: appTheme.typography.bodyH8.copyWith(
                            color: appTheme.colors.lightGray,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Page Indicators
            Padding(
              padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _welcomeData.length,
                  (index) => Container(
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? appTheme.colors.primaryRed
                          : appTheme.colors.lightGray.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: appTheme.spacing.lg),

            // Navigation Buttons
            Padding(
              padding: EdgeInsets.all(appTheme.spacing.lg),
              child: Row(
                children: [
                  // Previous Button
                  if (_currentPage > 0)
                    Expanded(
                      child: AppButton(
                        text: 'Previous',
                        onPressed: _previousPage,
                        variant: AppButtonVariant.secondary,
                        size: AppButtonSize.large,
                      ),
                    ),

                  if (_currentPage > 0) SizedBox(width: appTheme.spacing.md),

                  // Next/Get Started Button
                  Expanded(
                    flex: _currentPage == 0 ? 1 : 1,
                    child: AppButton(
                      text: _currentPage == _welcomeData.length - 1 ? 'Get Started' : 'Next',
                      onPressed: _currentPage == _welcomeData.length - 1
                          ? () {
                              // Navigate to login/signup
                            }
                          : _nextPage,
                      variant: AppButtonVariant.primary,
                      size: AppButtonSize.large,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}