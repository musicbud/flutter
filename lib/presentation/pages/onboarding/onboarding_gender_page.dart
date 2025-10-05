import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';
import '../../widgets/common/index.dart';

class OnboardingGenderPage extends StatefulWidget {
  const OnboardingGenderPage({super.key});

  @override
  State<OnboardingGenderPage> createState() => _OnboardingGenderPageState();
}

class _OnboardingGenderPageState extends State<OnboardingGenderPage> {
  String? _selectedGender;
  bool _isValid = false;

  final List<Map<String, dynamic>> _genderOptions = [
    {
      'value': 'male',
      'label': 'Male',
      'icon': Icons.male,
      'description': 'I identify as male',
    },
    {
      'value': 'female',
      'label': 'Female',
      'icon': Icons.female,
      'description': 'I identify as female',
    },
    {
      'value': 'non_binary',
      'label': 'Non-binary',
      'icon': Icons.person,
      'description': 'I identify as non-binary',
    },
    {
      'value': 'prefer_not_to_say',
      'label': 'Prefer not to say',
      'icon': Icons.help_outline,
      'description': 'I prefer not to specify',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedGender = 'prefer_not_to_say';
    _isValid = true;
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
                      Icons.person_outline,
                      size: 18,
                      color: appTheme.colors.pureWhite,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: EdgeInsets.symmetric(horizontal: appTheme.spacing.sm),
                      decoration: BoxDecoration(
                        color: appTheme.colors.lightGray.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: appTheme.colors.lightGray.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.favorite,
                      size: 18,
                      color: appTheme.colors.darkTone,
                    ),
                  ),
                ],
              ),

              SizedBox(height: appTheme.spacing.xxl),

              // Title and Description
              Text(
                'What\'s your gender?',
                style: appTheme.typography.displayH1.copyWith(
                  color: appTheme.colors.pureWhite,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: appTheme.spacing.sm),
              Text(
                'This helps us personalize your experience and show relevant content',
                style: appTheme.typography.bodyH8.copyWith(
                  color: appTheme.colors.lightGray,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: appTheme.spacing.xxl),

              // Gender Options
              Expanded(
                child: ListView.builder(
                  itemCount: _genderOptions.length,
                  itemBuilder: (context, index) {
                    final option = _genderOptions[index];
                    final isSelected = _selectedGender == option['value'];

                    return Padding(
                      padding: EdgeInsets.only(bottom: appTheme.spacing.md),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedGender = option['value'];
                            _isValid = true;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(appTheme.spacing.lg),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? appTheme.colors.primaryRed.withValues(alpha: 0.1)
                                : appTheme.colors.darkTone,
                            borderRadius: BorderRadius.circular(appTheme.radius.lg),
                            border: Border.all(
                              color: isSelected
                                  ? appTheme.colors.primaryRed
                                  : appTheme.colors.lightGray.withValues(alpha: 0.3),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? appTheme.colors.primaryRed
                                      : appTheme.colors.lightGray.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(appTheme.radius.md),
                                ),
                                child: Icon(
                                  option['icon'],
                                  size: 24,
                                  color: isSelected
                                      ? appTheme.colors.pureWhite
                                      : appTheme.colors.lightGray,
                                ),
                              ),
                              SizedBox(width: appTheme.spacing.lg),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      option['label'],
                                      style: appTheme.typography.headlineH6.copyWith(
                                        color: isSelected
                                            ? appTheme.colors.primaryRed
                                            : appTheme.colors.pureWhite,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: appTheme.spacing.xs),
                                    Text(
                                      option['description'],
                                      style: appTheme.typography.bodyH8.copyWith(
                                        color: appTheme.colors.lightGray,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: appTheme.colors.primaryRed,
                                  size: 24,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: appTheme.spacing.lg),

              // Continue Button
              AppButton(
                text: 'Continue',
                onPressed: _isValid ? () {
                  // Navigate to next onboarding page
                  // Navigator.push(context, MaterialPageRoute(
                  //   builder: (context) => OnboardingInterestsPage(),
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