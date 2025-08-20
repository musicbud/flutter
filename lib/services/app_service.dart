import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Centralized application service for common functionality
class AppService {
  static final AppService _instance = AppService._internal();
  factory AppService() => _instance;
  AppService._internal();

  /// Shared preferences instance
  SharedPreferences? _prefs;

  /// Initialize the app service
  Future<void> initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      if (kDebugMode) {
        debugPrint('🔧 AppService initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to initialize AppService: $e');
      }
    }
  }

  /// Get shared preferences instance
  SharedPreferences? get prefs => _prefs;

  /// Check if the app is running in debug mode
  bool get isDebugMode => kDebugMode;

  /// Check if the app is running in release mode
  bool get isReleaseMode => !kDebugMode;

  /// Check if the app is running in profile mode
  bool get isProfileMode => kProfileMode;

  /// Get app version information
  String get appVersion => '1.0.0';

  /// Get build number
  String get buildNumber => '1';

  /// Get minimum supported Flutter version
  String get minFlutterVersion => '3.0.0';

  /// Check if the app is running on a physical device
  bool get isPhysicalDevice => !kIsWeb && !kDebugMode;

  /// Check if the app is running on web
  bool get isWeb => kIsWeb;

  /// Check if the app is running on mobile
  bool get isMobile => !kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);

  /// Check if the app is running on desktop
  bool get isDesktop => !kIsWeb && (defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.macOS || defaultTargetPlatform == TargetPlatform.linux);

  /// Get target platform
  TargetPlatform get targetPlatform => defaultTargetPlatform;

  /// Get platform name as string
  String get platformName {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'Android';
      case TargetPlatform.iOS:
        return 'iOS';
      case TargetPlatform.windows:
        return 'Windows';
      case TargetPlatform.macOS:
        return 'macOS';
      case TargetPlatform.linux:
        return 'Linux';
      case TargetPlatform.fuchsia:
        return 'Fuchsia';
      default:
        return 'Unknown';
    }
  }

  /// Check if the device has a notch
  bool hasNotch(double statusBarHeight) {
    return statusBarHeight > 20;
  }

  /// Get device orientation
  Orientation getDeviceOrientation() {
    // This would need to be implemented with MediaQuery in a widget context
    return Orientation.portrait;
  }

  /// Check if the device is in landscape mode
  bool isLandscape(double width, double height) {
    return width > height;
  }

  /// Check if the device is in portrait mode
  bool isPortrait(double width, double height) {
    return height > width;
  }

  /// Get screen density
  double getScreenDensity() {
    // This would need to be implemented with MediaQuery in a widget context
    return 1.0;
  }

  /// Check if the device supports haptic feedback
  bool get supportsHapticFeedback {
    return defaultTargetPlatform == TargetPlatform.iOS ||
           defaultTargetPlatform == TargetPlatform.android;
  }

  /// Perform haptic feedback
  Future<void> performHapticFeedback() async {
    if (supportsHapticFeedback) {
      await HapticFeedback.vibrate();
    }
  }

  /// Check if the device has internet connectivity
  Future<bool> hasInternetConnectivity() async {
    try {
      // This is a placeholder - in a real app you'd check actual connectivity
      // You could use connectivity_plus package or similar
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to check internet connectivity: $e');
      }
      return false;
    }
  }

  /// Check if the device has sufficient storage
  Future<bool> hasSufficientStorage() async {
    try {
      // This is a placeholder - in a real app you'd check actual storage
      // You could use disk_space package or similar
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to check storage: $e');
      }
      return false;
    }
  }

  /// Get device information
  Map<String, dynamic> getDeviceInfo() {
    return {
      'platform': platformName,
      'isDebug': isDebugMode,
      'isPhysicalDevice': isPhysicalDevice,
      'isWeb': isWeb,
      'isMobile': isMobile,
      'isDesktop': isDesktop,
      'appVersion': appVersion,
      'buildNumber': buildNumber,
      'minFlutterVersion': minFlutterVersion,
    };
  }

  /// Log device information
  void logDeviceInfo() {
    if (kDebugMode) {
      final deviceInfo = getDeviceInfo();
      debugPrint('📱 Device Information:');
      deviceInfo.forEach((key, value) {
        debugPrint('  $key: $value');
      });
    }
  }
}