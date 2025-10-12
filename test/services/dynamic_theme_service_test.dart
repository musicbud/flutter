import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:musicbud_flutter/services/dynamic_theme_service.dart';
import 'package:musicbud_flutter/services/dynamic_config_service.dart';
import 'package:musicbud_flutter/core/theme/design_system.dart';


void main() {
  group('DynamicThemeService Tests', () {
    late DynamicThemeService themeService;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
    });

    setUp(() async {
      // Reset config service to defaults
      await DynamicConfigService.instance.reset();
      await DynamicConfigService.instance.initialize();
      
      themeService = DynamicThemeService.instance;
      await themeService.initialize();
    });

    group('Theme Mode Management', () {
      test('should initialize with dark theme mode by default', () {
        // Default theme in DynamicConfigService is 'dark'
        expect(themeService.themeMode, ThemeMode.dark);
        expect(themeService.currentThemeName, 'dark');
      });

      test('should set light theme mode', () async {
        await themeService.setThemeMode(ThemeMode.light);
        expect(themeService.themeMode, ThemeMode.light);
        expect(themeService.currentThemeName, 'light');
      });

      test('should set dark theme mode', () async {
        await themeService.setThemeMode(ThemeMode.dark);
        expect(themeService.themeMode, ThemeMode.dark);
        expect(themeService.currentThemeName, 'dark');
      });
    });

    group('Theme Data Generation', () {
      test('should return DesignSystem light theme', () {
        final lightTheme = themeService.lightTheme;
        
        expect(lightTheme.useMaterial3, true);
        expect(lightTheme.brightness, Brightness.light);
        expect(lightTheme.colorScheme.primary, DesignSystem.primary);
      });

      test('should return DesignSystem dark theme', () {
        final darkTheme = themeService.darkTheme;
        
        expect(darkTheme.useMaterial3, true);
        expect(darkTheme.brightness, Brightness.dark);
        expect(darkTheme.colorScheme.primary, DesignSystem.primary);
      });

      test('should get theme data based on brightness', () {
        final lightThemeData = themeService.getThemeData(Brightness.light);
        final darkThemeData = themeService.getThemeData(Brightness.dark);
        
        expect(lightThemeData.brightness, Brightness.light);
        expect(darkThemeData.brightness, Brightness.dark);
      });
    });

    group('Dynamic Spacing and Sizing', () {
      testWidgets('should calculate dynamic padding correctly', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(
          home: Builder(
            builder: (context) {
              final padding = themeService.getDynamicPadding(context);
              expect(padding, isA<EdgeInsets>());
              return Container();
            },
          ),
        ));
      });

      test('should calculate dynamic spacing', () {
        const baseSpacing = 16.0;
        final dynamicSpacing = themeService.getDynamicSpacing(baseSpacing);
        
        expect(dynamicSpacing, isA<double>());
        expect(dynamicSpacing, greaterThan(0));
      });

      test('should calculate dynamic font size', () {
        const baseFontSize = 16.0;
        final dynamicFontSize = themeService.getDynamicFontSize(baseFontSize);
        
        expect(dynamicFontSize, isA<double>());
        expect(dynamicFontSize, greaterThan(0));
      });

      test('should adjust spacing in compact mode', () async {
        // Enable compact mode through config service
        await DynamicConfigService.instance.set('ui.compact_mode', true);
        
        const baseSpacing = 16.0;
        final compactSpacing = themeService.getDynamicSpacing(baseSpacing);
        
        // In compact mode, spacing should be 70% of base
        expect(compactSpacing, equals(baseSpacing * 0.7));
        expect(compactSpacing, lessThan(baseSpacing));
        
        // Reset compact mode to not affect other tests
        await DynamicConfigService.instance.set('ui.compact_mode', false);
      });
    });

    group('Responsive Theme', () {
      testWidgets('should create responsive theme for mobile', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(400, 800));
        
        await tester.pumpWidget(MaterialApp(
          theme: DesignSystem.lightTheme,
          home: Builder(
            builder: (context) {
              final responsiveTheme = themeService.createResponsiveTheme(context);
              expect(responsiveTheme, isA<ThemeData>());
              return Container();
            },
          ),
        ));
      });

      testWidgets('should create responsive theme for tablet', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 1024));
        
        await tester.pumpWidget(MaterialApp(
          theme: DesignSystem.lightTheme,
          home: Builder(
            builder: (context) {
              final responsiveTheme = themeService.createResponsiveTheme(context);
              expect(responsiveTheme, isA<ThemeData>());
              return Container();
            },
          ),
        ));
      });

      testWidgets('should create responsive theme for desktop', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(1400, 1024));
        
        await tester.pumpWidget(MaterialApp(
          theme: DesignSystem.lightTheme,
          home: Builder(
            builder: (context) {
              final responsiveTheme = themeService.createResponsiveTheme(context);
              expect(responsiveTheme, isA<ThemeData>());
              return Container();
            },
          ),
        ));
      });
    });

    group('Theme-Aware Helpers', () {
      testWidgets('should return theme-aware colors', (WidgetTester tester) async {
        const lightColor = Colors.white;
        const darkColor = Colors.black;
        
        await tester.pumpWidget(MaterialApp(
          theme: DesignSystem.lightTheme,
          home: Builder(
            builder: (context) {
              final color = themeService.getThemeAwareColor(
                context,
                lightColor: lightColor,
                darkColor: darkColor,
              );
              expect(color, lightColor);
              return Container();
            },
          ),
        ));
      });

      testWidgets('should return theme-aware icons', (WidgetTester tester) async {
        const lightIcon = Icons.light_mode;
        const darkIcon = Icons.dark_mode;
        
        await tester.pumpWidget(MaterialApp(
          theme: DesignSystem.lightTheme,
          home: Builder(
            builder: (context) {
              final icon = themeService.getThemeAwareIcon(
                context,
                lightIcon: lightIcon,
                darkIcon: darkIcon,
              );
              expect(icon, lightIcon);
              return Container();
            },
          ),
        ));
      });
    });

    group('Settings Management', () {
      test('should manage animations setting', () async {
        expect(themeService.animationsEnabled, true);
        
        await themeService.setAnimationsEnabled(false);
        expect(themeService.animationsEnabled, false);
        
        // Restore to original state
        await themeService.setAnimationsEnabled(true);
        expect(themeService.animationsEnabled, true);
      });

      test('should manage compact mode setting', () async {
        expect(themeService.compactMode, false);
        
        await themeService.setCompactMode(true);
        expect(themeService.compactMode, true);
        
        // Restore to original state
        await themeService.setCompactMode(false);
        expect(themeService.compactMode, false);
      });
    });
  });
}