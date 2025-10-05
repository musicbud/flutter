import 'package:flutter/material.dart';
import '../presentation/pages/profile_page.dart';
import '../presentation/pages/search_page.dart';
import '../presentation/pages/user_profile_demo_page.dart';
import '../presentation/pages/welcome_page.dart';
import '../presentation/pages/new_pages/sories.dart';
import '../presentation/pages/new_pages/settings_page.dart';
import '../presentation/pages/new_pages/user_management_page.dart';
import '../presentation/pages/onboarding/onboarding_birthday_page.dart';

class AppRouter {
  static const String home = '/';
  static const String profile = '/profile';
  static const String search = '/search';
  static const String userProfileDemo = '/user-profile-demo';
  static const String welcome = '/welcome';
  static const String stories = '/stories';
  static const String settings = '/settings';
  static const String userManagement = '/user-management';
  static const String onboarding = '/onboarding';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final routeName = settings.name;
    if (routeName == home) {
      return MaterialPageRoute(
        builder: (_) => const WelcomePage(),
      );
    } else if (routeName == profile) {
      return MaterialPageRoute(
        builder: (_) => const ProfilePage(),
      );
    } else if (routeName == search) {
      return MaterialPageRoute(
        builder: (_) => const SearchPage(),
      );
    } else if (routeName == userProfileDemo) {
      return MaterialPageRoute(
        builder: (_) => const UserProfileDemoPage(),
      );
    } else if (routeName == welcome) {
      return MaterialPageRoute(
        builder: (_) => const WelcomePage(),
      );
    } else if (routeName == stories) {
      return MaterialPageRoute(
        builder: (_) => const StoriesPage(),
      );
    } else if (routeName == settings) {
      return MaterialPageRoute(
        builder: (_) => const SettingsPage(),
      );
    } else if (routeName == userManagement) {
      return MaterialPageRoute(
        builder: (_) => const UserManagementPage(),
      );
    } else if (routeName == onboarding) {
      return MaterialPageRoute(
        builder: (_) => const OnboardingBirthdayPage(),
      );
    } else {
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for $routeName'),
          ),
        ),
      );
    }
  }
}
