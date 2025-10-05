import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';
import '../../widgets/common/index.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: appTheme.colors.darkTone,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(appTheme.spacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: appTheme.spacing.xxl),

                // Logo and Title
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
                          Icons.music_note,
                          size: 40,
                          color: appTheme.colors.pureWhite,
                        ),
                      ),
                      SizedBox(height: appTheme.spacing.lg),
                      Text(
                        'Welcome Back!',
                        style: appTheme.typography.displayH1.copyWith(
                          color: appTheme.colors.pureWhite,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: appTheme.spacing.sm),
                      Text(
                        'Sign in to continue your musical journey',
                        style: appTheme.typography.bodyH8.copyWith(
                          color: appTheme.colors.lightGray,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: appTheme.spacing.xxl),

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
                  hint: 'Enter your password',
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
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                SizedBox(height: appTheme.spacing.md),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Navigate to forgot password page
                    },
                    child: Text(
                      'Forgot Password?',
                      style: appTheme.typography.bodyH8.copyWith(
                        color: appTheme.colors.primaryRed,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: appTheme.spacing.lg),

                // Login Button
                AppButton(
                  text: 'Sign In',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle login logic
                    }
                  },
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

                // Social Login Buttons
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: 'Google',
                        onPressed: () {
                          // Handle Google sign in
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
                          // Handle Apple sign in
                        },
                        variant: AppButtonVariant.secondary,
                        size: AppButtonSize.medium,
                        icon: Icons.apple,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: appTheme.spacing.xl),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: appTheme.typography.bodyH8.copyWith(
                        color: appTheme.colors.lightGray,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to sign up page
                      },
                      child: Text(
                        'Sign Up',
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