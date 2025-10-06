import 'package:flutter/material.dart';
import 'navigation_item.dart';

// Import the new screens from the screens directory
import '../screens/home/home_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/library/library_screen.dart';
import '../screens/discover/discover_screen.dart';
import '../screens/profile/profile_screen.dart';

// TODO: Missing page files - commented out until pages are created
// import '../pages/event_page.dart' as MainEventPage;
// import '../pages/settings_page.dart' as MainSettingsPage;
// import '../pages/welcome_page.dart';

// Import auth pages
// import '../pages/auth/login_page.dart';
// import '../pages/auth/signup_page.dart';
// import '../pages/auth/forgot_password_page.dart';
// import '../pages/auth/otp_verification_page.dart';
// import '../pages/auth/change_password_page.dart';

// Import onboarding pages
// import '../pages/onboarding/onboarding_first_name_page.dart';
// import '../pages/onboarding/onboarding_birthday_page.dart';
// import '../pages/onboarding/onboarding_gender_page.dart';
// import '../pages/onboarding/onboarding_interests_page.dart';

// Import social pages
// import '../pages/social/match_recommendations_page.dart';
// import '../pages/social/watch_party_detail_page.dart';

// Import demo pages
// import '../pages/demo/user_profile_demo_page.dart';

// Import the stories page from new_pages directory
// import '../pages/new_pages/stories_page.dart';

/// Main navigation items for the bottom navigation bar
final List<NavigationItem> mainNavigationItems = [
  // Main Navigation Screens
  NavigationItem(
    icon: Icons.home_outlined,
    label: 'Home',
    pageBuilder: (context) => const HomeScreen(),
  ),
  NavigationItem(
    icon: Icons.search,
    label: 'Search',
    pageBuilder: (context) => const SearchScreen(),
  ),
  NavigationItem(
    icon: Icons.people,
    label: 'Discover',
    pageBuilder: (context) => const DiscoverScreen(),
  ),
  NavigationItem(
    icon: Icons.chat_bubble_outline,
    label: 'Chat',
    pageBuilder: (context) => const ChatScreen(),
  ),
  NavigationItem(
    icon: Icons.music_note,
    label: 'Library',
    pageBuilder: (context) => const LibraryScreen(),
  ),
  NavigationItem(
    icon: Icons.person,
    label: 'Profile',
    pageBuilder: (context) => const ProfileScreen(),
  ),
];

/// Additional pages accessible via navigation drawer or buttons
// TODO: Commented out until missing page files are created
/*
final List<NavigationItem> additionalNavigationItems = [
  // Auth Pages
  NavigationItem(
    icon: Icons.login,
    label: 'Login',
    pageBuilder: (context) => const LoginPage(),
  ),
  NavigationItem(
    icon: Icons.person_add,
    label: 'Sign Up',
    pageBuilder: (context) => const SignupPage(),
  ),
  NavigationItem(
    icon: Icons.lock_reset,
    label: 'Forgot Password',
    pageBuilder: (context) => const ForgotPasswordPage(),
  ),
  NavigationItem(
    icon: Icons.verified,
    label: 'OTP Verification',
    pageBuilder: (context) => const OtpVerificationPage(),
  ),
  NavigationItem(
    icon: Icons.password,
    label: 'Change Password',
    pageBuilder: (context) => const ChangePasswordPage(),
  ),

  // Onboarding Pages
  NavigationItem(
    icon: Icons.badge,
    label: 'First Name',
    pageBuilder: (context) => const OnboardingFirstNamePage(),
  ),
  NavigationItem(
    icon: Icons.cake,
    label: 'Birthday',
    pageBuilder: (context) => const OnboardingBirthdayPage(),
  ),
  NavigationItem(
    icon: Icons.wc,
    label: 'Gender',
    pageBuilder: (context) => const OnboardingGenderPage(),
  ),
  NavigationItem(
    icon: Icons.interests,
    label: 'Interests',
    pageBuilder: (context) => const OnboardingInterestsPage(),
  ),

  // Social Pages
  NavigationItem(
    icon: Icons.favorite,
    label: 'Match Recommendations',
    pageBuilder: (context) => const MatchRecommendationsPage(),
  ),
  NavigationItem(
    icon: Icons.tv,
    label: 'Watch Party Detail',
    pageBuilder: (context) => const WatchPartyDetailPage(),
  ),

  // Demo Pages
  NavigationItem(
    icon: Icons.account_circle,
    label: 'User Profile Demo',
    pageBuilder: (context) => const UserProfileDemoPage(),
  ),

  // Other Pages
  NavigationItem(
    icon: Icons.event,
    label: 'Events',
    pageBuilder: (context) => const MainEventPage.EventPage(),
  ),
  NavigationItem(
    icon: Icons.settings,
    label: 'Settings',
    pageBuilder: (context) => const MainSettingsPage.SettingsPage(),
  ),
  NavigationItem(
    icon: Icons.waving_hand,
    label: 'Welcome',
    pageBuilder: (context) => const WelcomePage(),
  ),
  NavigationItem(
    icon: Icons.headphones,
    label: 'Stories',
    pageBuilder: (context) => const StoriesPage(),
  ),
];
*/

// Temporary empty list to allow compilation
final List<NavigationItem> additionalNavigationItems = [];