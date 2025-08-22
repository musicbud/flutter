import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';
import '../../widgets/common/index.dart';

class OnboardingFirstNamePage extends StatefulWidget {
  const OnboardingFirstNamePage({super.key});

  @override
  State<OnboardingFirstNamePage> createState() => _OnboardingFirstNamePageState();
}

class _OnboardingFirstNamePageState extends State<OnboardingFirstNamePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_validateInput);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    super.dispose();
  }

  void _validateInput() {
    setState(() {
      _isValid = _firstNameController.text.trim().length >= 2;
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
          child: Form(
            key: _formKey,
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
                          color: appTheme.colors.lightGray.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: appTheme.colors.primaryRed,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        Icons.person,
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
                        Icons.cake,
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
                  'What\'s your first name?',
                  style: appTheme.typography.displayH1.copyWith(
                    color: appTheme.colors.pureWhite,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: appTheme.spacing.sm),
                Text(
                  'We\'ll use this to personalize your experience',
                  style: appTheme.typography.bodyH8.copyWith(
                    color: appTheme.colors.lightGray,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: appTheme.spacing.xxl),

                // First Name Input Field
                AppInputField(
                  controller: _firstNameController,
                  label: 'First Name',
                  hint: 'Enter your first name',
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),

                SizedBox(height: appTheme.spacing.xxl),

                // Continue Button
                AppButton(
                  text: 'Continue',
                  onPressed: _isValid ? () {
                    if (_formKey.currentState!.validate()) {
                      // Navigate to next onboarding page
                      // Navigator.push(context, MaterialPageRoute(
                      //   builder: (context) => OnboardingBirthdayPage(),
                      // ));
                    }
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
      ),
    );
  }
}