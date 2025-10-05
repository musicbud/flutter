import 'package:flutter/material.dart';

/// App-wide constants for consistent styling and behavior
class AppConstants {
  // Colors
  static const Color primaryColor = Color(0xFFFF6B8F);
  static const Color backgroundColor = Colors.black;
  static const Color surfaceColor = Color.fromARGB(121, 59, 59, 59);
  static const Color textColor = Colors.white;
  static const Color textSecondaryColor = Colors.white70;
  static const Color borderColor = Color(0xFFCFD0FD);
  static const Color errorColor = Colors.red;
  static const Color successColor = Colors.green;

  // Dimensions
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double defaultIconSize = 24.0;
  static const double defaultButtonHeight = 48.0;
  static const double defaultTextFieldHeight = 56.0;

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    color: textColor,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subheadingStyle = TextStyle(
    color: textColor,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyStyle = TextStyle(
    color: textColor,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle captionStyle = TextStyle(
    color: textSecondaryColor,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  // Durations
  static Duration get defaultAnimationDuration => const Duration(milliseconds: 300);
  static Duration get defaultSnackBarDuration => const Duration(seconds: 3);
  static Duration get defaultDebounceDuration => const Duration(milliseconds: 500);

  // Asset Paths
  static const String defaultCoverImage = ''; // No default cover image
  static const String defaultProfileImage = ''; // No default profile image
  static const String defaultMusicCover = 'assets/music_cover.jpg';

  // API Constants
  static const int defaultPageSize = 20;
  static const int maxRetryAttempts = 3;
  static Duration get requestTimeout => const Duration(seconds: 30);

  // Navigation
  static const String homeRoute = '/';
  static const String loginRoute = '/login';
  static const String homePageRoute = '/home';
  static const String profileRoute = '/profile';
  static const String chatRoute = '/chat';
  static const String searchRoute = '/search';
  static const String storiesRoute = '/stories';

  // App Information
  static const String appTitle = 'MusicBud';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Connect through music';

  // Shared Preferences Keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userProfileKey = 'user_profile';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';

  // Validation
  static const int minPasswordLength = 8;
  static const int maxUsernameLength = 30;
  static const int maxBioLength = 500;
  static RegExp get emailRegex => RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );

  // Error Messages
  static const String networkErrorMessage = 'Network error. Please check your connection.';
  static const String serverErrorMessage = 'Server error. Please try again later.';
  static const String authenticationErrorMessage = 'Authentication failed. Please log in again.';
  static const String validationErrorMessage = 'Please check your input and try again.';
  static const String unknownErrorMessage = 'An unknown error occurred. Please try again.';

  // Success Messages
  static const String profileUpdatedMessage = 'Profile updated successfully!';
  static const String passwordChangedMessage = 'Password changed successfully!';
  static const String logoutMessage = 'Logged out successfully!';
  static const String itemSavedMessage = 'Item saved successfully!';
}