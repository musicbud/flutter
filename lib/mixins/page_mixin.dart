import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Mixin that provides common page functionality
mixin PageMixin<T extends StatefulWidget> on State<T> {
  /// Whether the page is currently loading
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    if (_isLoading != value) {
      setState(() => _isLoading = value);
    }
  }

  /// Whether the page has an error
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  set errorMessage(String? value) {
    if (_errorMessage != value) {
      setState(() => _errorMessage = value);
    }
  }

  /// Clear error message
  void clearError() {
    errorMessage = null;
  }

  /// Show loading overlay
  void showLoading() {
    isLoading = true;
  }

  /// Hide loading overlay
  void hideLoading() {
    isLoading = false;
  }

  /// Show error message
  void showError(String message) {
    errorMessage = message;
    hideLoading();
  }

  /// Clear all states
  void clearState() {
    isLoading = false;
    errorMessage = null;
  }

  /// Handle async operations with loading and error states
  Future<void> handleAsyncOperation(
    Future<void> Function() operation, {
    String? loadingMessage,
    String? errorMessage = 'An error occurred. Please try again.',
  }) async {
    try {
      showLoading();
      clearError();
      await operation();
      hideLoading();
    } catch (e) {
      showError(errorMessage ?? e.toString());
    }
  }

  /// Set preferred orientations for the page
  void setPreferredOrientations(List<DeviceOrientation> orientations) {
    SystemChrome.setPreferredOrientations(orientations);
  }

  /// Reset to default orientations
  void resetPreferredOrientations() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// Set status bar style
  void setStatusBarStyle({
    Brightness? statusBarBrightness,
    Color? statusBarColor,
    Brightness? statusBarIconBrightness,
  }) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: statusBarBrightness,
        statusBarColor: statusBarColor,
        statusBarIconBrightness: statusBarIconBrightness,
      ),
    );
  }

  /// Show snack bar
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    Color? textColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor),
        ),
        duration: duration,
        backgroundColor: backgroundColor,
      ),
    );
  }

  /// Show success snack bar
  void showSuccessSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  /// Show error snack bar
  void showErrorSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  /// Show info snack bar
  void showInfoSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );
  }

  /// Hide keyboard
  void hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  /// Check if keyboard is visible
  bool get isKeyboardVisible {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  /// Get safe area padding
  EdgeInsets get safeAreaPadding {
    return MediaQuery.of(context).padding;
  }

  /// Get screen size
  Size get screenSize {
    return MediaQuery.of(context).size;
  }

  /// Get screen width
  double get screenWidth => screenSize.width;

  /// Get screen height
  double get screenHeight => screenSize.height;

  /// Check if device is tablet
  bool get isTablet {
    return screenWidth > 600;
  }

  /// Check if device is phone
  bool get isPhone => !isTablet;
}