import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';
import '../../widgets/common/index.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: appTheme.colors.darkTone,
      appBar: AppBar(
        backgroundColor: appTheme.colors.darkTone,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: appTheme.colors.pureWhite,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(appTheme.spacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                Text(
                  'Create Account',
                  style: appTheme.typography.displayH1.copyWith(
                    color: appTheme.colors.pureWhite,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: appTheme.spacing.sm),
                Text(
                  'Join our musical community today',
                  style: appTheme.typography.bodyH8.copyWith(
                    color: appTheme.colors.lightGray,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: appTheme.spacing.xxl),

                // Full Name Field
                AppInputField(
                  controller: _fullNameController,
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    if (value.length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ),

                SizedBox(height: appTheme.spacing.lg),

                // Email Field
                AppInputField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),

                SizedBox(height: appTheme.spacing.lg),

                // Password Field
                AppInputField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Create a password',
                  obscureText: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      color: appTheme.colors.lightGray,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),

                SizedBox(height: appTheme.spacing.lg),

                // Confirm Password Field
                AppInputField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  hint: 'Confirm your password',
                  obscureText: !_isConfirmPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      color: appTheme.colors.lightGray,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),

                SizedBox(height: appTheme.spacing.lg),

                // Terms and Conditions
                Row(
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreeToTerms = value ?? false;
                        });
                      },
                      activeColor: appTheme.colors.primaryRed,
                      checkColor: appTheme.colors.pureWhite,
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: appTheme.typography.bodyH8.copyWith(
                            color: appTheme.colors.lightGray,
                          ),
                          children: [
                            const TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                color: appTheme.colors.primaryRed,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: appTheme.colors.primaryRed,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: appTheme.spacing.xl),

                // Sign Up Button
                AppButton(
                  text: 'Create Account',
                  onPressed: _agreeToTerms ? () {
                    if (_formKey.currentState!.validate()) {
                      // Handle sign up logic
                    }
                  } : null,
                  variant: AppButtonVariant.primary,
                  size: AppButtonSize.large,
                ),

                SizedBox(height: appTheme.spacing.lg),

                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: appTheme.colors.lightGray.withValues(alpha: 0.3),
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.md),
                      child: Text(
                        'OR',
                        style: appTheme.typography.bodyH8.copyWith(
                          color: appTheme.colors.lightGray,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: appTheme.colors.lightGray.withValues(alpha: 0.3),
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: appTheme.spacing.lg),

                // Social Sign Up Buttons
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: 'Google',
                        onPressed: () {
                          // Handle Google sign up
                        },
                        variant: AppButtonVariant.secondary,
                        size: AppButtonSize.medium,
                        icon: Icons.g_mobiledata,
                      ),
                    ),
                    SizedBox(width: appTheme.spacing.md),
                    Expanded(
                      child: AppButton(
                        text: 'Apple',
                        onPressed: () {
                          // Handle Apple sign up
                        },
                        variant: AppButtonVariant.secondary,
                        size: AppButtonSize.medium,
                        icon: Icons.apple,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: appTheme.spacing.xl),

                // Sign In Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: appTheme.typography.bodyH8.copyWith(
                        color: appTheme.colors.lightGray,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Sign In',
                        style: appTheme.typography.bodyH8.copyWith(
                          color: appTheme.colors.primaryRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}