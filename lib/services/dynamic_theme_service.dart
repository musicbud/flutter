import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dynamic_config_service.dart';
import '../core/theme/design_system.dart';

/// Service for managing dynamic themes
class DynamicThemeService extends ChangeNotifier {
  static DynamicThemeService? _instance;
  static DynamicThemeService get instance => _instance ??= DynamicThemeService._();

  DynamicThemeService._();

  final DynamicConfigService _config = DynamicConfigService.instance;
  SharedPreferences? _preferences;
  ThemeMode _themeMode = ThemeMode.system;
  ColorScheme? _customColorScheme;

  /// Initialize the theme service
  Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
    final themeString = _config.getTheme();
    _themeMode = _parseThemeMode(themeString);
    await _loadCustomColorScheme();
  }

  /// Parse theme mode from string
  ThemeMode _parseThemeMode(String theme) {
    switch (theme.toLowerCase()) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  /// Load custom color scheme from configuration
  Future<void> _loadCustomColorScheme() async {
    // TODO: Load custom color scheme from configuration
    // This could be user-defined colors or brand colors
  }

  /// Get current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Get current theme name
  String get currentThemeName {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  /// Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _config.setTheme(_getThemeString(mode));
  }

  /// Get theme string from theme mode
  String _getThemeString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  /// Get dynamic light theme using DesignSystem
  ThemeData get lightTheme {
    final baseTheme = DesignSystem.lightTheme;
    
    // Apply any custom color scheme if set
    if (_customColorScheme != null) {
      return baseTheme.copyWith(
        colorScheme: _customColorScheme,
      );
    }
    
    return baseTheme;
  }

  /// Get dynamic dark theme using DesignSystem
  ThemeData get darkTheme {
    final baseTheme = DesignSystem.darkTheme;
    
    // Apply any custom color scheme if set
    if (_customColorScheme != null) {
      return baseTheme.copyWith(
        colorScheme: _customColorScheme,
      );
    }
    
    return baseTheme;
  }

  /// Get primary color from configuration
  Color _getPrimaryColor() {
    // Use DesignSystem primary color as default
    return DesignSystem.primary;
  }

  /// Set custom primary color
  Future<void> setPrimaryColor(Color color) async {
    // TODO: Save primary color to configuration
    await _loadCustomColorScheme();
  }

  /// Get theme data based on brightness
  ThemeData getThemeData(Brightness brightness) {
    return brightness == Brightness.light ? lightTheme : darkTheme;
  }

  /// Check if animations are enabled
  bool get animationsEnabled {
    return _config.get<bool>('ui.enable_animations', defaultValue: true);
  }

  /// Set animations enabled/disabled
  Future<void> setAnimationsEnabled(bool enabled) async {
    await _config.set('ui.enable_animations', enabled);
  }

  /// Check if compact mode is enabled
  bool get compactMode {
    return _config.get<bool>('ui.compact_mode', defaultValue: false);
  }

  /// Set compact mode
  Future<void> setCompactMode(bool enabled) async {
    await _config.set('ui.compact_mode', enabled);
  }

  /// Get dynamic padding based on compact mode
  EdgeInsets getDynamicPadding(BuildContext context) {
    final basePadding = MediaQuery.of(context).padding;
    final multiplier = compactMode ? 0.7 : 1.0;
    const baseSpacing = DesignSystem.spacingMD;

    return EdgeInsets.only(
      top: basePadding.top * multiplier,
      bottom: basePadding.bottom * multiplier,
      left: baseSpacing * multiplier,
      right: baseSpacing * multiplier,
    );
  }

  /// Get dynamic spacing based on compact mode
  double getDynamicSpacing(double baseSpacing) {
    return compactMode ? baseSpacing * 0.7 : baseSpacing;
  }

  /// Get dynamic font size based on compact mode
  double getDynamicFontSize(double baseFontSize) {
    return compactMode ? baseFontSize * 0.9 : baseFontSize;
  }

  /// Create a responsive theme based on screen size
  ThemeData createResponsiveTheme(BuildContext context) {
    final baseTheme = getThemeData(Theme.of(context).brightness);
    final screenWidth = MediaQuery.of(context).size.width;

    // Adjust theme based on screen size
    if (screenWidth < 600) {
      // Mobile theme adjustments
      return baseTheme.copyWith(
        textTheme: baseTheme.textTheme.apply(
          fontSizeFactor: 0.9,
        ),
      );
    } else if (screenWidth < 1200) {
      // Tablet theme adjustments
      return baseTheme.copyWith(
        textTheme: baseTheme.textTheme.apply(
          fontSizeFactor: 1.1,
        ),
      );
    } else {
      // Desktop theme adjustments
      return baseTheme.copyWith(
        textTheme: baseTheme.textTheme.apply(
          fontSizeFactor: 1.2,
        ),
      );
    }
  }

  /// Get theme-aware color
  Color getThemeAwareColor(BuildContext context, {
    required Color lightColor,
    required Color darkColor,
  }) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light ? lightColor : darkColor;
  }

  /// Get theme-aware icon
  IconData getThemeAwareIcon(BuildContext context, {
    required IconData lightIcon,
    required IconData darkIcon,
  }) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light ? lightIcon : darkIcon;
  }

  /// Set theme mode
  Future<void> setTheme(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    await _saveThemeMode(mode);
  }

  /// Save theme mode to preferences
  Future<void> _saveThemeMode(ThemeMode mode) async {
    await _preferences?.setString('theme_mode', mode.toString());
  }
}
