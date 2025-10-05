import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';
import '../../widgets/common/index.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
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
        title: Text(
          'Change Password',
          style: appTheme.typography.headlineH6.copyWith(
            color: appTheme.colors.pureWhite,
          ),
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
                SizedBox(height: appTheme.spacing.lg),

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
                          Icons.lock_outline,
                          size: 40,
                          color: appTheme.colors.pureWhite,
                        ),
                      ),
                      SizedBox(height: appTheme.spacing.lg),
                      Text(
                        'Change Your Password',
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
                  'Enter your current password and create a new one to keep your account secure.',
                  style: appTheme.typography.bodyH8.copyWith(
                    color: appTheme.colors.lightGray,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: appTheme.spacing.xxl),

                // Current Password Field
                AppInputField(
                  controller: _currentPasswordController,
                  label: 'Current Password',
                  hint: 'Enter your current password',
                  obscureText: !_isCurrentPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isCurrentPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      color: appTheme.colors.lightGray,
                    ),
                    onPressed: () {
                      setState(() {
                        _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your current password';
                    }
                    return null;
                  },
                ),

                SizedBox(height: appTheme.spacing.lg),

                // New Password Field
                AppInputField(
                  controller: _newPasswordController,
                  label: 'New Password',
                  hint: 'Enter your new password',
                  obscureText: !_isNewPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isNewPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      color: appTheme.colors.lightGray,
                    ),
                    onPressed: () {
                      setState(() {
                        _isNewPasswordVisible = !_isNewPasswordVisible;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    if (value == _currentPasswordController.text) {
                      return 'New password must be different from current password';
                    }
                    return null;
                  },
                ),

                SizedBox(height: appTheme.spacing.lg),

                // Confirm New Password Field
                AppInputField(
                  controller: _confirmPasswordController,
                  label: 'Confirm New Password',
                  hint: 'Confirm your new password',
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
                      return 'Please confirm your new password';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),

                SizedBox(height: appTheme.spacing.lg),

                // Password Requirements
                Container(
                  padding: EdgeInsets.all(appTheme.spacing.md),
                  decoration: BoxDecoration(
                    color: appTheme.colors.darkTone,
                    borderRadius: BorderRadius.circular(appTheme.radius.md),
                    border: Border.all(
                      color: appTheme.colors.lightGray.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Password Requirements:',
                        style: appTheme.typography.bodyH8.copyWith(
                          color: appTheme.colors.pureWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: appTheme.spacing.sm),
                      _buildRequirement(
                        'At least 8 characters long',
                        _newPasswordController.text.length >= 8,
                        appTheme,
                      ),
                      _buildRequirement(
                        'Contains uppercase letter',
                        _newPasswordController.text.contains(RegExp(r'[A-Z]')),
                        appTheme,
                      ),
                      _buildRequirement(
                        'Contains lowercase letter',
                        _newPasswordController.text.contains(RegExp(r'[a-z]')),
                        appTheme,
                      ),
                      _buildRequirement(
                        'Contains number',
                        _newPasswordController.text.contains(RegExp(r'[0-9]')),
                        appTheme,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: appTheme.spacing.xl),

                // Change Password Button
                AppButton(
                  text: 'Change Password',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle password change logic
                      _showPasswordChangedDialog(context, appTheme);
                    }
                  },
                  variant: AppButtonVariant.primary,
                  size: AppButtonSize.large,
                ),

                SizedBox(height: appTheme.spacing.lg),

                // Cancel Button
                AppButton(
                  text: 'Cancel',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  variant: AppButtonVariant.secondary,
                  size: AppButtonSize.large,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequirement(String text, bool isMet, AppTheme appTheme) {
    return Padding(
      padding: EdgeInsets.only(top: appTheme.spacing.xs),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            color: isMet ? appTheme.colors.primaryRed : appTheme.colors.lightGray,
            size: 16,
          ),
          SizedBox(width: appTheme.spacing.sm),
          Text(
            text,
            style: appTheme.typography.bodyH8.copyWith(
              color: isMet ? appTheme.colors.pureWhite : appTheme.colors.lightGray,
            ),
          ),
        ],
      ),
    );
  }

  void _showPasswordChangedDialog(BuildContext context, AppTheme appTheme) {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                'Password Changed!',
                style: appTheme.typography.headlineH6.copyWith(
                  color: appTheme.colors.pureWhite,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: appTheme.spacing.sm),
              Text(
                'Your password has been updated successfully.',
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