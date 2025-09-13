import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

// BLoCs
import 'blocs/auth/login/login_bloc.dart';
import 'blocs/auth/register/register_bloc.dart';

// Repositories
import 'domain/repositories/auth_repository.dart';

// Pages
import 'presentation/pages/home_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/new_pages/main.dart';
// import 'presentation/pages/new_pages/profile_page.dart';
import 'presentation/pages/new_pages/service_connection_page.dart';
import 'presentation/pages/new_pages/settings_page.dart';
import 'presentation/pages/new_pages/admin_dashboard_page.dart';
import 'presentation/pages/new_pages/event_page.dart';

// Utilities
import 'utils/colors.dart';
import 'presentation/constants/app_constants.dart';

/// Main application widget for MusicBud
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: _buildBlocProviders(),
      child: _buildMaterialApp(),
    );
  }

  /// Builds the list of BLoC providers for the application
  List<BlocProvider> _buildBlocProviders() {
    final sl = GetIt.instance;

    return [
      // Authentication BLoCs (only the ones not provided in main.dart)
      BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(authRepository: sl<AuthRepository>()),
      ),
      BlocProvider<RegisterBloc>(
        create: (context) => RegisterBloc(authRepository: sl<AuthRepository>()),
      ),
    ];
  }

  /// Builds the MaterialApp with theme and routing
  Widget _buildMaterialApp() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appTitle,
      theme: _buildAppTheme(),
      initialRoute: AppConstants.loginRoute,
      routes: _buildAppRoutes(),
    );
  }

  /// Builds the application theme
  ThemeData _buildAppTheme() {
    return ThemeData(
      colorScheme: AppColors.colorScheme,
      useMaterial3: true,
      textTheme: GoogleFonts.josefinSansTextTheme(
        ThemeData.light().textTheme,
      ),
      // Additional theme customizations
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.backgroundColor,
        foregroundColor: AppConstants.textColor,
        elevation: 0,
      ),
      scaffoldBackgroundColor: AppConstants.backgroundColor,
      primaryColor: AppConstants.primaryColor,
    );
  }

  /// Builds the application routes
  Map<String, WidgetBuilder> _buildAppRoutes() {
    return {
      AppConstants.homeRoute: (context) => const NewMainScreen(),
      AppConstants.loginRoute: (context) => const LoginPage(),
      AppConstants.homePageRoute: (context) => const HomePage(),
      // AppConstants.profileRoute: (context) => const ProfilePage(),
      '/services': (context) => const ServiceConnectionPage(),
      '/settings': (context) => const SettingsPage(),
      '/admin': (context) => const AdminDashboardPage(),
      '/events': (context) => const EventPage(),
    };
  }
}

/// Application configuration and constants
class AppConfig {
  /// Application name
  static const String appName = 'MusicBud';

  /// Application version
  static const String appVersion = '1.0.0';

  /// Application description
  static const String appDescription = 'Connect through music';

  /// Build number
  static const String buildNumber = '1';

  /// Minimum supported Flutter version
  static const String minFlutterVersion = '3.0.0';
}
