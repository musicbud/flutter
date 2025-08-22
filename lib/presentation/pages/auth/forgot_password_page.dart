import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';
import '../../widgets/common/index.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
                SizedBox(height: appTheme.spacing.xxl),

                // Icon and Title
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: appTheme.gradients.primaryGradient,
                          borderRadius: BorderRadius.circular(appTheme.radius.lg),
                        ),
                        child: Icon(
                          Icons.lock_reset,
                          size: 40,
                          color: appTheme.colors.pureWhite,
                        ),
                      ),
                      SizedBox(height: appTheme.spacing.lg),
                      Text(
                        'Forgot Password?',
                        style: appTheme.typography.displayH1.copyWith(
                          color: appTheme.colors.pureWhite,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: appTheme.spacing.lg),

                // Description
                Text(
                  'Don\'t worry! It happens. Please enter the email address associated with your account.',
                  style: appTheme.typography.bodyH8.copyWith(
                    color: appTheme.colors.lightGray,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: appTheme.spacing.xxl),

                // Email Field
                AppInputField(
                  controller: _emailController,
                  label: 'Email Address',
                  hint: 'Enter your email address',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),

                SizedBox(height: appTheme.spacing.xl),

                // Submit Button
                AppButton(
                  text: 'Send Reset Link',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle password reset logic
                      _showResetEmailSentDialog(context, appTheme);
                    }
                  },
                  variant: AppButtonVariant.primary,
                  size: AppButtonSize.large,
                ),

                SizedBox(height: appTheme.spacing.lg),

                // Back to Login
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Back to Login',
                      style: appTheme.typography.bodyH8.copyWith(
                        color: appTheme.colors.primaryRed,
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

  void _showResetEmailSentDialog(BuildContext context, AppTheme appTheme) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appTheme.colors.darkTone,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(appTheme.radius.lg),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: appTheme.gradients.primaryGradient,
                  borderRadius: BorderRadius.circular(appTheme.radius.lg),
                ),
                child: Icon(
                  Icons.check,
                  size: 30,
                  color: appTheme.colors.pureWhite,
                ),
              ),
              SizedBox(height: appTheme.spacing.lg),
              Text(
                'Reset Link Sent!',
                style: appTheme.typography.headlineH6.copyWith(
                  color: appTheme.colors.pureWhite,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: appTheme.spacing.sm),
              Text(
                'We have sent a password reset link to your email address. Please check your inbox and follow the instructions.',
                style: appTheme.typography.bodyH8.copyWith(
                  color: appTheme.colors.lightGray,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            AppButton(
              text: 'OK',
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              variant: AppButtonVariant.primary,
              size: AppButtonSize.medium,
            ),
          ],
        );
      },
    );
  }
}