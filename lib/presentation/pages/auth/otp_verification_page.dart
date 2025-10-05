import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';
import '../../widgets/common/index.dart';

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );
  int _currentIndex = 0;
  bool _isResendEnabled = true;
  int _resendCountdown = 30;

  @override
  void initState() {
    super.initState();
    _startResendCountdown();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startResendCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
        _startResendCountdown();
      } else if (mounted) {
        setState(() {
          _isResendEnabled = true;
        });
      }
    });
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
      _currentIndex = index + 1;
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
      _currentIndex = index - 1;
    }
    setState(() {});
  }

  String get _otpCode {
    return _otpControllers.map((controller) => controller.text).join();
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
                        Icons.phone_android,
                        size: 40,
                        color: appTheme.colors.pureWhite,
                      ),
                    ),
                    SizedBox(height: appTheme.spacing.lg),
                    Text(
                      'OTP Verification',
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
                'We have sent a verification code to your phone number. Please enter the 6-digit code.',
                style: appTheme.typography.bodyH8.copyWith(
                  color: appTheme.colors.lightGray,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: appTheme.spacing.xxl),

              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (index) => SizedBox(
                    width: 50,
                    child: TextField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: appTheme.typography.headlineH6.copyWith(
                        color: appTheme.colors.pureWhite,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: appTheme.colors.darkTone,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(appTheme.radius.md),
                          borderSide: BorderSide(
                            color: _currentIndex == index
                                ? appTheme.colors.primaryRed
                                : appTheme.colors.lightGray.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(appTheme.radius.md),
                          borderSide: BorderSide(
                            color: appTheme.colors.lightGray.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(appTheme.radius.md),
                          borderSide: BorderSide(
                            color: appTheme.colors.primaryRed,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) => _onOtpChanged(value, index),
                    ),
                  ),
                ),
              ),

              SizedBox(height: appTheme.spacing.xl),

              // Verify Button
              AppButton(
                text: 'Verify OTP',
                onPressed: _otpCode.length == 6 ? () {
                  // Handle OTP verification logic
                  _showVerificationSuccessDialog(context, appTheme);
                } : null,
                variant: AppButtonVariant.primary,
                size: AppButtonSize.large,
              ),

              SizedBox(height: appTheme.spacing.lg),

              // Resend Code
              Center(
                child: Column(
                  children: [
                    Text(
                      "Didn't receive the code? ",
                      style: appTheme.typography.bodyH8.copyWith(
                        color: appTheme.colors.lightGray,
                      ),
                    ),
                    TextButton(
                      onPressed: _isResendEnabled ? () {
                        setState(() {
                          _isResendEnabled = false;
                          _resendCountdown = 30;
                        });
                        _startResendCountdown();
                        // Handle resend logic
                      } : null,
                      child: Text(
                        _isResendEnabled
                            ? 'Resend Code'
                            : 'Resend Code in $_resendCountdown seconds',
                        style: appTheme.typography.bodyH8.copyWith(
                          color: _isResendEnabled
                              ? appTheme.colors.primaryRed
                              : appTheme.colors.lightGray.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: appTheme.spacing.lg),

              // Change Phone Number
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Change Phone Number',
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

  void _showVerificationSuccessDialog(BuildContext context, AppTheme appTheme) {
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
                'Verification Successful!',
                style: appTheme.typography.headlineH6.copyWith(
                  color: appTheme.colors.pureWhite,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: appTheme.spacing.sm),
              Text(
                'Your phone number has been verified successfully.',
                style: appTheme.typography.bodyH8.copyWith(
                  color: appTheme.colors.lightGray,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            AppButton(
              text: 'Continue',
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to next page or main app
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