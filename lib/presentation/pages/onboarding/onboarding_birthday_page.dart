import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';
import '../../widgets/common/index.dart';

class OnboardingBirthdayPage extends StatefulWidget {
  const OnboardingBirthdayPage({super.key});

  @override
  State<OnboardingBirthdayPage> createState() => _OnboardingBirthdayPageState();
}

class _OnboardingBirthdayPageState extends State<OnboardingBirthdayPage> {
  DateTime? _selectedDate;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    // Set default date to 18 years ago
    _selectedDate = DateTime.now().subtract(const Duration(days: 18 * 365));
    _isValid = true;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().subtract(const Duration(days: 18 * 365)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppTheme.of(context).colors.primaryRed,
              onPrimary: AppTheme.of(context).colors.pureWhite,
              surface: AppTheme.of(context).colors.darkTone,
              onSurface: AppTheme.of(context).colors.pureWhite,
            ),
            dialogBackgroundColor: AppTheme.of(context).colors.darkTone,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _isValid = true;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
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
                      Icons.cake,
                      size: 18,
                      color: appTheme.colors.pureWhite,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: EdgeInsets.symmetric(horizontal: appTheme.spacing.sm),
                      decoration: BoxDecoration(
                        color: appTheme.colors.lightGray.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: appTheme.colors.lightGray.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.person_outline,
                      size: 18,
                      color: appTheme.colors.darkTone,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: EdgeInsets.symmetric(horizontal: appTheme.spacing.sm),
                      decoration: BoxDecoration(
                        color: appTheme.colors.lightGray.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: appTheme.colors.lightGray.withOpacity(0.3),
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
                'When\'s your birthday?',
                style: appTheme.typography.displayH1.copyWith(
                  color: appTheme.colors.pureWhite,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: appTheme.spacing.sm),
              Text(
                'We\'ll use this to show you age-appropriate content',
                style: appTheme.typography.bodyH8.copyWith(
                  color: appTheme.colors.lightGray,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: appTheme.spacing.xxl),

              // Birthday Selection
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: EdgeInsets.all(appTheme.spacing.lg),
                  decoration: BoxDecoration(
                    color: appTheme.colors.darkTone,
                    borderRadius: BorderRadius.circular(appTheme.radius.lg),
                    border: Border.all(
                      color: appTheme.colors.primaryRed,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.cake,
                        size: 48,
                        color: appTheme.colors.primaryRed,
                      ),
                      SizedBox(height: appTheme.spacing.md),
                      Text(
                        _selectedDate != null ? _formatDate(_selectedDate!) : 'Select Date',
                        style: appTheme.typography.headlineH6.copyWith(
                          color: appTheme.colors.pureWhite,
                        ),
                      ),
                      if (_selectedDate != null) ...[
                        SizedBox(height: appTheme.spacing.sm),
                        Text(
                          'Age: ${_calculateAge(_selectedDate!)} years old',
                          style: appTheme.typography.bodyH8.copyWith(
                            color: appTheme.colors.lightGray,
                          ),
                        ),
                      ],
                      SizedBox(height: appTheme.spacing.md),
                      Text(
                        'Tap to change',
                        style: appTheme.typography.bodyH8.copyWith(
                          color: appTheme.colors.primaryRed,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: appTheme.spacing.xxl),

              // Continue Button
              AppButton(
                text: 'Continue',
                onPressed: _isValid ? () {
                  // Navigate to next onboarding page
                  // Navigator.push(context, MaterialPageRoute(
                  //   builder: (context) => OnboardingGenderPage(),
                  // ));
                } : null,
                variant: AppButtonVariant.primary,
                size: AppButtonSize.large,
              ),

              const Spacer(),

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